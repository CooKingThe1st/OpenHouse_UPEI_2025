/*
 * ================= SLAVE WIXEL CODE =================
 *
 * This code receives commands from the master Wixel and controls
 * RGB LEDs and a motor based on the received commands.
 *
 * Features:
 * - Direct radio register control (RX mode)
 * - DMA-based packet reception
 * - Parses addressed packets from master
 * - Controls RGB LEDs (P1_1=RED, P1_2=GREEN, P1_7=BLUE)
 * - Controls motor direction and speed based on LED color
 * - LED Status Feedback:
 *   * RED LED: ON when connected
 *   * YELLOW LED: Pulses when data is received
 *
 * Motor Control Logic:
 * - GREEN/BLUE: Forward
 * - RED: Backward
 * - NONE (OFF): Stop
 *
 * C89 Style: All variables at the top.
 * ====================================================
 */

#include <wixel.h>
#include <radio_registers.h>

/* ================== CONFIGURATION CONSTANTS ================== */

// --- Slave Configuration ---
#define THIS_SLAVE_ADDRESS  0x01

// --- Protocol Definitions ---
#define CMD_SET_LED         0x01
#define MESSAGE_DELIMITER   0xFF
#define RADIO_PACKET_SIZE   16

// --- GPIO Pin Definitions (RGB Control) ---
#define LED_RED_PIN         1   // P1_1 = RGB Red
#define LED_GREEN_PIN       2   // P1_2 = RGB Green
#define LED_BLUE_PIN        7   // P1_7 = RGB Blue


// --- Motor Control Pins (FROM ALPHA.C) ---
#define R_PWM_PIN           3   // P1_3 = Right Motor PWM (D9)
#define R_DIR_PIN           5   // P1_5 = Right Motor Direction (D7)
#define L_PWM_PIN           4   // P1_4 = Left Motor PWM (D10)
#define L_DIR_PIN           6   // P1_6 = Left Motor Direction (D8)

// --- Motor Control Values ---
#define MOTOR_SPEED         100  // PWM duty cycle (0-255)

// --- Timing Constants ---
#define CONNECTION_TIMEOUT  2000   // 2 seconds without packet = no connection
#define YELLOW_LED_PULSE    100    // Yellow LED pulse duration (ms)

/* ================== GLOBAL VARIABLES (C89 Style) ================== */

// Radio RX packet buffer
static volatile XDATA uint8 rxPacket[1 + RADIO_PACKET_SIZE + 2];

// Current RGB LED values
uint8 ledRed = 0;
uint8 ledGreen = 0;
uint8 ledBlue = 0;

// Last time we received a valid packet
uint16 lastPacketTime = 0;

// Flag to track if we just received data (for yellow LED pulse)
BIT dataReceivedFlag = 0;
uint16 dataReceivedTime = 0;

/*
 * Initialize Timer3 for PWM output (MATCHING ALPHA.C)
 */
void timer3Init()
{
    T3CTL = 0b01110000;      // Prescaler 1:8, frequency = 11.7 kHz (matches alpha.c)
    T3CC0 = T3CC1 = 0;       // Set duty cycles to zero
    T3CCTL0 = T3CCTL1 = 0b00100100;    // Compare mode
    PERCFG &= ~(1<<5);       // Alternate location (matches alpha.c)
    P1SEL |= (1<<R_PWM_PIN) | (1<<L_PWM_PIN);  // P1_3 and P1_4 as PWM
}

/*
 * Initialize the radio for direct reception
 */
void radioInit()
{
    radioRegistersInit();
    
    CHANNR = 128;
    PKTLEN = RADIO_PACKET_SIZE;
    
    MCSM0 = 0x14;
    MCSM1 = 0x00;
    
    dmaConfig.radio.DC6 = 19;
    
    dmaConfig.radio.SRCADDRH = XDATA_SFR_ADDRESS(RFD) >> 8;
    dmaConfig.radio.SRCADDRL = XDATA_SFR_ADDRESS(RFD);
    dmaConfig.radio.DESTADDRH = (unsigned int)rxPacket >> 8;
    dmaConfig.radio.DESTADDRL = (unsigned int)rxPacket;
    dmaConfig.radio.LENL = 1 + PKTLEN + 2;
    dmaConfig.radio.VLEN_LENH = 0b10000000;
    dmaConfig.radio.DC7 = 0x10;
    
    DMAARM |= (1<<DMA_CHANNEL_RADIO);
    RFST = 2;
}

/*
 * Initialize GPIO pins for RGB LED control and motor control (MATCHING ALPHA.C GPIO SETUP)
 */

uint8 __fsi__;
// give the wixel some times to recover to bootloader in case of malfunction
void failSafeBootloader(){
    
    // Explicitly configure the red LED pin as output
    LED_RED(0);
    LED_RED_TOGGLE();
    
    delayMs(200);
    
    // 7-second bootloader window with red LED toggle
    for(__fsi__ = 0; __fsi__ < 70; __fsi__++) {
        LED_RED_TOGGLE();
        boardService();
        usbComService();
        delayMs(100);
    }
    
    // Turn off red LED after bootloader window
    LED_RED(0);
}

void gpioInit()
{
    failSafeBootloader();
    // *** TARGETED GPIO RESET (from alpha.c) ***
    P1SEL = 0x00;     // Force ALL P1 pins to GPIO mode
    P1DIR = 0x00;     // Start with all inputs
    P1 = 0x00;        // Clear all output values
    
    // Disable timers that might conflict
    T1CTL = 0x00;
    T3CTL = 0x00;
    T4CTL = 0x00;
    
    // NOW set up our specific pins as outputs
    P1DIR |= (1 << LED_RED_PIN) | (1 << LED_GREEN_PIN) | (1 << LED_BLUE_PIN);  // RGB pins
    P1DIR |= (1 << R_DIR_PIN) | (1 << L_DIR_PIN);  // Motor direction pins (both wheels)
    
    // Verify P1SEL is still clear for GPIO pins
    P1SEL = 0x00;
    
    // Initialize RGB LEDs to OFF (active-low)
    P1_1 = 1;
    P1_2 = 1;
    P1_7 = 1;
    
    // Initialize motor to STOP
    T3CC0 = 0;
    T3CC1 = 0;
    P1_5 = 0;
    P1_6 = 0;
}

/*
 * Update the RGB LED outputs
 */
void updateRgbLeds()
{
    P1_1 = (ledRed > 127) ? 0 : 1;
    P1_2 = (ledGreen > 127) ? 0 : 1;
    P1_7 = (ledBlue > 127) ? 0 : 1;
}

/*
 * Control both motors based on LED color (MATCHING ALPHA.C LOGIC)
 * - GREEN/BLUE: Forward (both motors, direction bits = 0)
 * - RED: Backward (both motors, direction bits = 1)
 * - NONE (OFF): Stop (PWM = 0)
 */
void updateMotor()
{
    BIT isGreen = (ledGreen > 127);
    BIT isBlue = (ledBlue > 127);
    BIT isRed = (ledRed > 127);
    
    if (isGreen || isBlue)
    {
        // FORWARD - Direction bits 5,6 = 0
        P1_5 = 0;  // Right motor forward
        P1_6 = 0;  // Left motor forward
        T3CC0 = MOTOR_SPEED;  // Right motor PWM
        T3CC1 = MOTOR_SPEED;  // Left motor PWM
    }
    else if (isRed)
    {
        // BACKWARD - Direction bits 5,6 = 1
        P1_5 = 1;  // Right motor reverse
        P1_6 = 1;  // Left motor reverse
        T3CC0 = MOTOR_SPEED;  // Right motor PWM
        T3CC1 = MOTOR_SPEED;  // Left motor PWM
    }
    else
    {
        // STOP - PWM = 0, Direction bits = 0
        T3CC0 = 0;
        T3CC1 = 0;
        P1_5 = 0;
        P1_6 = 0;
    }
}

/*
 * Update status LEDs (red for connection, yellow for data)
 */
void updateStatusLeds()
{
    uint16 now = (uint16)getMs();
    BIT isConnected = ((uint16)(now - lastPacketTime) < CONNECTION_TIMEOUT);
    
    // RED LED: ON when connected, OFF when disconnected
    if (isConnected)
    {
        LED_RED(1);
    }
    else
    {
        LED_RED(0);
    }
    
    // YELLOW LED: Pulse for 100ms when data received
    if (dataReceivedFlag)
    {
        if ((uint16)(now - dataReceivedTime) < YELLOW_LED_PULSE)
        {
            LED_YELLOW(1);
        }
        else
        {
            LED_YELLOW(0);
            dataReceivedFlag = 0;
        }
    }
    else
    {
        LED_YELLOW(0);
    }
}

/*
 * Process received radio packets
 */
void receiveAndProcessPackets()
{
    if (RFIF & (1<<4))
    {
        if (radioCrcPassed())
        {
            uint8 slaveAddress;
            uint8 slaveCmd;
            uint8 slaveRed;
            uint8 slaveGreen;
            uint8 slaveBlue;
            
            if (THIS_SLAVE_ADDRESS == 0x01)
            {
                slaveAddress = rxPacket[1];
                slaveCmd = rxPacket[4];
                slaveRed = rxPacket[5];
                slaveGreen = rxPacket[6];
                slaveBlue = rxPacket[7];
            }
            else  // THIS_SLAVE_ADDRESS == 0x02
            {
                slaveAddress = rxPacket[9];
                slaveCmd = rxPacket[12];
                slaveRed = rxPacket[13];
                slaveGreen = rxPacket[14];
                slaveBlue = rxPacket[15];
            }
            
            if (slaveAddress == THIS_SLAVE_ADDRESS && slaveCmd == CMD_SET_LED)
            {
                ledRed = slaveRed;
                ledGreen = slaveGreen;
                ledBlue = slaveBlue;
                lastPacketTime = (uint16)getMs();
                
                dataReceivedFlag = 1;
                dataReceivedTime = (uint16)getMs();
            }
        }
        
        RFIF &= ~(1<<4);
        DMAARM |= (1<<DMA_CHANNEL_RADIO);
        RFST = 2;
    }
}

/*
 * Timeout handler: turn off LEDs and motor if no packet received
 */
void handlePacketTimeout()
{
    if ((uint16)(getMs() - lastPacketTime) > CONNECTION_TIMEOUT)
    {
        ledRed = 0;
        ledGreen = 0;
        ledBlue = 0;
    }
}

/*
 * Main function
 */
void main()
{
    systemInit();
    radioInit();
    gpioInit();
    
    lastPacketTime = (uint16)getMs();
    
    // === RGB LED Test Sequence ===
    P1_1 = 0;  // Red on
    P1_2 = 1;
    P1_7 = 1;
    delayMs(500);
    
    P1_1 = 1;
    P1_2 = 0;  // Green on
    P1_7 = 1;
    delayMs(500);
    
    P1_1 = 1;
    P1_2 = 1;
    P1_7 = 0;  // Blue on
    delayMs(500);
    
    P1_1 = 0;
    P1_2 = 0;
    P1_7 = 0;  // All on
    delayMs(500);
    
    P1_1 = 1;
    P1_2 = 1;
    P1_7 = 1;  // All off
    delayMs(500);

    lastPacketTime = (uint16)getMs();
    
    // === Initialize Motor Control ===
    timer3Init();
    
    while(1)
    {
        boardService();
        receiveAndProcessPackets();
        handlePacketTimeout();
        updateRgbLeds();
        updateMotor();
        updateStatusLeds();
    }
}