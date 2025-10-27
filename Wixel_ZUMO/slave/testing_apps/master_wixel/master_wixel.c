/*
 * ================= MASTER WIXEL CODE (v7 - SIMPLIFIED) =================
 *
 * Simplified Logic:
 * - State is directly controlled by serial input (modulo 4)
 * - Send packet matching current state every 1000ms
 * - No auto-cycling, no state locking
 *
 * LED Feedback:
 *   * RED LED: Pulses when receiving serial commands
 *   * GREEN LED: Pulses when sending radio packets
 *   * YELLOW LED: Heartbeat/debug indicator
 * =======================================================
 */

#include <wixel.h>
#include <radio_registers.h>
#include <usb.h>
#include <usb_com.h>
#include <stdio.h>

/* ================== CONFIGURATION CONSTANTS ================== */

// --- Slave Addresses ---
#define SLAVE_1_ADDRESS     0x01
#define SLAVE_2_ADDRESS     0x02

// --- Protocol Definitions ---
#define CMD_SET_LED         0x01
#define MESSAGE_DELIMITER   0xFF
#define PACKET_DATA_LENGTH  16
#define RADIO_PACKET_SIZE   16

// --- Timing ---
#define PACKET_INTERVAL     1000     // Send packet every 1000ms
#define SERIAL_RX_PULSE     100      // Red LED pulse duration (ms)
#define RADIO_TX_PULSE      100      // Green LED pulse duration (ms)

// --- State Machine States ---
#define STATE_RED_GREEN     0
#define STATE_OFF_1         1
#define STATE_BLUE_YELLOW   2
#define STATE_OFF_2         3

/* ================== GLOBAL VARIABLES ================== */

// Radio TX packet buffer (packet[0] = length, packet[1..16] = data)
static volatile XDATA uint8 txPacket[1 + RADIO_PACKET_SIZE];

// Response buffer for USB serial (must be XDATA)
static XDATA uint8 serialResponse[32];

// Time of the last packet transmission
uint32 lastTxTime;

// The current state
uint8 state;

// LED pulse tracking
BIT serialRxPulseActive = 0;
uint16 serialRxPulseStart = 0;

BIT radioTxPulseActive = 0;
uint16 radioTxPulseStart = 0;

/*
 * Initialize the radio for direct transmission
 */
void radioInit()
{
    radioRegistersInit();
    
    CHANNR = 128;
    PKTLEN = RADIO_PACKET_SIZE;
    MCSM0 = 0x14;
    MCSM1 = 0x00;
    IOCFG2 = 0b011011;
    
    // Configure DMA channel for radio TX
    dmaConfig.radio.DC6 = 19;
    dmaConfig.radio.SRCADDRH = (unsigned int)txPacket >> 8;
    dmaConfig.radio.SRCADDRL = (unsigned int)txPacket;
    dmaConfig.radio.DESTADDRH = XDATA_SFR_ADDRESS(RFD) >> 8;
    dmaConfig.radio.DESTADDRL = XDATA_SFR_ADDRESS(RFD);
    dmaConfig.radio.LENL = 1 + RADIO_PACKET_SIZE;
    dmaConfig.radio.VLEN_LENH = 0b00100000;
    dmaConfig.radio.DC7 = 0x40;
    
    txPacket[0] = RADIO_PACKET_SIZE;
    
    RFST = 4;  // Switch to IDLE
}

/*
 * Send the prepared TX packet via DMA
 */
void sendRadioPacket()
{
    if (MARCSTATE == 1)  // Radio must be in IDLE state
    {
        RFIF &= ~(1<<4);
        DMAARM |= (1<<DMA_CHANNEL_RADIO);
        RFST = 3;  // Switch to TX
        
        // Trigger green LED pulse
        radioTxPulseActive = 1;
        radioTxPulseStart = (uint16)getMs();
    }
}

/*
 * Update LED indicators
 */
void updateLeds()
{
    uint16 now = (uint16)getMs();
    
    // RED LED: Pulse when serial data received
    if (serialRxPulseActive)
    {
        if ((uint16)(now - serialRxPulseStart) < SERIAL_RX_PULSE)
        {
            LED_RED(1);
        }
        else
        {
            LED_RED(0);
            serialRxPulseActive = 0;
        }
    }
    else
    {
        LED_RED(0);
    }
    
    // GREEN LED: Pulse when radio packet sent
    if (radioTxPulseActive)
    {
        if ((uint16)(now - radioTxPulseStart) < RADIO_TX_PULSE)
        {
            LED_GREEN(1);
        }
        else
        {
            LED_GREEN(0);
            radioTxPulseActive = 0;
        }
    }
    else
    {
        LED_GREEN(0);
    }
    
    // YELLOW LED: Heartbeat (toggle every 500ms)
    LED_YELLOW_TOGGLE();
}

/*
 * Process a byte received from USB serial
 * State = input modulo 4 (so any number works)
 */
void processSerialByte(uint8 byteReceived)
{
    uint8 responseLength;
    
    // Convert ASCII digit to number
    if (byteReceived >= '0' && byteReceived <= '9')
    {
        state = (byteReceived - '0') % 4;
    }
    else
    {
        // If not a digit, just use the byte value modulo 4
        state = byteReceived % 4;
    }
    
    // Send confirmation back to serial using global XDATA buffer
    responseLength = sprintf(serialResponse, "State=%d\r\n", state);
    usbComTxSend(serialResponse, responseLength);
    
    // Trigger red LED pulse
    serialRxPulseActive = 1;
    serialRxPulseStart = (uint16)getMs();
}

/*
 * Check for and process bytes from USB serial
 */
void processBytesFromUsb()
{
    uint8 bytesAvailable = usbComRxAvailable();
    while(bytesAvailable && usbComTxAvailable() >= 32)
    {
        processSerialByte(usbComRxReceiveByte());
        bytesAvailable--;
    }
}

/*
 * Prepare packet based on current state
 */
void preparePacket()
{
    switch(state)
    {
        case STATE_RED_GREEN:
            // --- Slave 1: RED ---
            txPacket[1]  = SLAVE_1_ADDRESS;
            txPacket[2]  = 0x00;
            txPacket[3]  = 0x00;
            txPacket[4]  = CMD_SET_LED;
            txPacket[5]  = 255;
            txPacket[6]  = 0;
            txPacket[7]  = 0;
            txPacket[8]  = MESSAGE_DELIMITER;
            // --- Slave 2: GREEN ---
            txPacket[9]  = SLAVE_2_ADDRESS;
            txPacket[10] = 0x00;
            txPacket[11] = 0x00;
            txPacket[12] = CMD_SET_LED;
            txPacket[13] = 0;
            txPacket[14] = 255;
            txPacket[15] = 0;
            txPacket[16] = MESSAGE_DELIMITER;
            break;

        case STATE_OFF_1:
            // --- Slave 1: OFF ---
            txPacket[1]  = SLAVE_1_ADDRESS;
            txPacket[2]  = 0x00;
            txPacket[3]  = 0x00;
            txPacket[4]  = CMD_SET_LED;
            txPacket[5]  = 0;
            txPacket[6]  = 0;
            txPacket[7]  = 0;
            txPacket[8]  = MESSAGE_DELIMITER;
            // --- Slave 2: OFF ---
            txPacket[9]  = SLAVE_2_ADDRESS;
            txPacket[10] = 0x00;
            txPacket[11] = 0x00;
            txPacket[12] = CMD_SET_LED;
            txPacket[13] = 0;
            txPacket[14] = 0;
            txPacket[15] = 0;
            txPacket[16] = MESSAGE_DELIMITER;
            break;

        case STATE_BLUE_YELLOW:
            // --- Slave 1: BLUE ---
            txPacket[1]  = SLAVE_1_ADDRESS;
            txPacket[2]  = 0x00;
            txPacket[3]  = 0x00;
            txPacket[4]  = CMD_SET_LED;
            txPacket[5]  = 0;
            txPacket[6]  = 0;
            txPacket[7]  = 255;
            txPacket[8]  = MESSAGE_DELIMITER;
            // --- Slave 2: YELLOW ---
            txPacket[9]  = SLAVE_2_ADDRESS;
            txPacket[10] = 0x00;
            txPacket[11] = 0x00;
            txPacket[12] = CMD_SET_LED;
            txPacket[13] = 255;
            txPacket[14] = 255;
            txPacket[15] = 0;
            txPacket[16] = MESSAGE_DELIMITER;
            break;

        case STATE_OFF_2:
            // --- Slave 1: OFF ---
            txPacket[1]  = SLAVE_1_ADDRESS;
            txPacket[2]  = 0x00;
            txPacket[3]  = 0x00;
            txPacket[4]  = CMD_SET_LED;
            txPacket[5]  = 0;
            txPacket[6]  = 0;
            txPacket[7]  = 0;
            txPacket[8]  = MESSAGE_DELIMITER;
            // --- Slave 2: OFF ---
            txPacket[9]  = SLAVE_2_ADDRESS;
            txPacket[10] = 0x00;
            txPacket[11] = 0x00;
            txPacket[12] = CMD_SET_LED;
            txPacket[13] = 0;
            txPacket[14] = 0;
            txPacket[15] = 0;
            txPacket[16] = MESSAGE_DELIMITER;
            break;
    }
}

/*
 * Main function
 */
void main()
{
    systemInit();
    usbInit();
    radioInit();

    state = STATE_RED_GREEN;
    lastTxTime = getMs();

    while(1)
    {
        boardService();
        usbComService();
        
        // Process any incoming serial commands
        processBytesFromUsb();
        
        // Update LED states
        updateLeds();
        
        // Send packet every 1000ms
        if (getMs() - lastTxTime >= PACKET_INTERVAL)
        {
            lastTxTime = getMs();
            preparePacket();
            sendRadioPacket();
        }
    }
}