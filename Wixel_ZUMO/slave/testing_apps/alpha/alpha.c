// Wixel Pin(s),Zumo Shield Pin(s),Function / Purpose "VIN, GND","5V (or VIN), GND",Power: The Zumo Shield is powering the Wixel. (My hypothesis on the exact pins) P1_3,D9 (Right PWM),Motor Control: Right Motor Speed P1_4,D10 (Left PWM),Motor Control: Left Motor Speed P1_5,D7 (Right Dir),Motor Control: Right Motor Direction P1_6,D8 (Left Dir),Motor Control: Left Motor Direction P1_0,D6,Buzzer: To make sounds. (As you noted!) P0_0,A1,Analog Input: Almost certainly to read the battery voltage. RST,RST,Reset: Links the Zumo's reset button to the Wixel's reset pin. "P1_1, P1_2, P1_7",Custom RGB LED,"Status LED: Controls the Red, Green, and Blue channels of the custom LED." this is the connection layout between a zumo board v1.2 and the wixel. remmeber it
// P1_1 = GREEN 
// P1_2 = RED 
// P1_7 = BLUE ✓
/**
 * ZUMO RIGHT MOTOR FORWARD/REVERSE TEST (Corrected)
 * -------------------
 * This app definitively tests the Right Motor direction pin (P1_5 -> D7).
 *
 * IT INCLUDES THE FIX: P1_5 is forced into GPIO mode by clearing
 * its bit in the P1SEL register. This stops the I2C peripheral
 * from hijacking the pin.
 *
 * - Runs Right Motor FORWARD for 2 seconds.
 * - STOPS for 2 seconds.
 * - Runs Right Motor REVERSE for 2 seconds.
 * - STOPS for 2 seconds.
 * - Repeats.
 */
/**
 * ZUMO DUAL MOTOR TEST (Both wheels opposite directions)
 * -------------------
 * Right Motor: P1_3 (PWM - D9), P1_5 (Dir - D7)
 * Left Motor:  P1_4 (PWM - D10), P1_6 (Dir - D8)
 *
 * Test Sequence:
 * - Both FORWARD for 2 seconds
 * - Both STOP for 1 second
 * - Both REVERSE for 2 seconds
 * - Both STOP for 1 second
 * - Repeat
 */


#include <wixel.h>
#include <usb.h>
#include <usb_com.h>
#include <time.h>       // For getMs()

// -- Motor Pin Definitions --
#define R_PWM_PIN       3  // P1_3 (D9)
#define R_DIR_PIN       5  // P1_5 (D7)
#define L_PWM_PIN       4  // P1_4 (D10)
#define L_DIR_PIN       6  // P1_6 (D8)

// Set a medium speed for the test (out of 255)
#define MOTOR_SPEED 100

// -- Timing Variables --
uint32 lastRedLedToggle = 0;
uint32 lastMotorActionTime = 0;
uint8 motorState = 0; // 0=Stop, 1=Forward, 2=Stop, 3=Reverse
uint32 currentTime;


/**
 * Initializes Timer 3 for PWM on P1_3 and P1_4 and sets duty cycle to 0.
 */
void timer3Init()
{
    T3CTL = 0b01110000;   // Prescaler 1:8, frequency = 11.7 kHz
    T3CC0 = T3CC1 = 0;    // Set duty cycles to zero
    T3CCTL0 = T3CCTL1 = 0b00100100;
    PERCFG &= ~(1<<5);    // Alternate location
    P1SEL |= (1<<3) | (1<<4);  // P1_3 and P1_4 as PWM
}

/**
 * Blinks the onboard RED LED as a heartbeat.
 */
void updateHeartbeatLed()
{
    // Blink every 500ms
    if (getMs() - lastRedLedToggle >= 500)
    {
        LED_RED_TOGGLE();
        lastRedLedToggle = getMs();
    }
}

// void sendMsg(const char *msg)
// sendMsg("FORWARD\n"); for example
// { 
//     static __xdata uint8 buffer[16];   
//     uint8 i = 0;

//     // Copy message from code memory into xdata RAM buffer
//     while (msg[i] != 0 && i < sizeof(buffer))
//     {
//         buffer[i] = msg[i];
//         i++;
//     }

//     usbComTxSend(buffer, i);
// }

uint8 i;
void main()
{
    systemInit();
    usbInit();

    // Explicitly configure the red LED pin as output
    LED_RED(0);
    LED_RED_TOGGLE();
    
    delayMs(200);
    
    // 10-second bootloader window with red LED toggle
    for(i = 0; i < 70; i++) {
        LED_RED_TOGGLE();
        boardService();
        usbComService();
        delayMs(100);
    }
    
    // Turn off red LED after bootloader window
    LED_RED(0);

    // *** TARGETED GPIO RESET (preserve USB) ***
    // Disable ALL peripherals on Port 1 FIRST
    P1SEL = 0x00;     // Force ALL P1 pins to GPIO mode
    P1DIR = 0x00;     // Start with all inputs
    P1 = 0x00;        // Clear all output values
    
    // Disable timers that might conflict
    T1CTL = 0x00;
    T3CTL = 0x00;
    T4CTL = 0x00;
    
    // NOW set up our specific pins as outputs
    P1DIR |= (1 << 1) | (1 << 2) | (1 << 7);  // RGB pins as outputs
    P1DIR |= (1 << 5) | (1 << 6);  // Motor direction pins as outputs (both wheels)
    
    // Verify P1SEL is still clear
    P1SEL = 0x00;
    
    // === LED Test Sequence ===
    
    // All OFF (active-low: 0xFF means all high = all off)
    P1 = 0xFF;
    delayMs(1000);
    
    // Red ON only
    P1 = 0b11111101;  // Only bit 1 is 0
    delayMs(300);
    
    // Green ON only
    P1 = 0b11111011;  // Only bit 2 is 0
    delayMs(300);
    
    // Blue ON only
    P1 = 0b01111111;  // Only bit 7 is 0
    delayMs(300);
    
    // All OFF again
    P1 = 0xFF;
    delayMs(500);

    // === Initialize Motor Control ===
    timer3Init();
    
    // === Motor Direction Test (Run Once) ===
    
    // TEST 1: RIGHT FORWARD (full speed), LEFT FORWARD (half speed) - RED LED ON
    P1 = 0b10011110;  // Bits 5,6 = 0 (both forward), Bit 1 = 0 (RED LED ON)
    T3CC0 = MOTOR_SPEED;
    T3CC1 = MOTOR_SPEED / 2;
    delayMs(2000);
    
    // TEST 2: STOP - GREEN LED ON
    T3CC0 = 0;
    T3CC1 = 0;
    P1 = 0b11111011;  // Bits 5,6 = 0 (stay forward), Bit 2 = 0 (GREEN LED ON)
    delayMs(1000);
    
    // TEST 3: RIGHT REVERSE (half speed), LEFT REVERSE (full speed) - BLUE LED ON
    P1 = 0b01111111;  // Bits 5,6 = 1 (both reverse), Bit 7 = 0 (BLUE LED ON)
    T3CC0 = MOTOR_SPEED / 2;
    T3CC1 = MOTOR_SPEED;
    delayMs(2000);
    
    // TEST 4: STOP - ALL RGB OFF
    T3CC0 = 0;
    T3CC1 = 0;
    P1 = 0xFF;  // All LEDs off
    delayMs(1000);
    
    // TEST 5: RIGHT FORWARD, LEFT REVERSE - RED + GREEN = YELLOW LED
    P1 = 0b10111100;  // Bit 5=0 (right forward), Bit 6=1 (left reverse), Bits 1,2=0 (RED+GREEN)
    T3CC0 = MOTOR_SPEED;
    T3CC1 = MOTOR_SPEED;
    delayMs(2000);
    
    // TEST 6: STOP - BLUE LED ON (show it's independent)
    T3CC0 = 0;
    T3CC1 = 0;
    P1 = 0b01111111;  // Bit 7 = 0 (BLUE LED ON)
    delayMs(1000);
    
    // TEST 7: RIGHT REVERSE, LEFT FORWARD - RED + BLUE = MAGENTA LED
    P1 = 0b11011101;  // Bit 5=1 (right reverse), Bit 6=0 (left forward), Bits 1,7=0 (RED+BLUE)
    T3CC0 = MOTOR_SPEED;
    T3CC1 = MOTOR_SPEED;
    delayMs(2000);
    
    // TEST 8: ALL OFF - FINAL STOP
    T3CC0 = 0;
    T3CC1 = 0;
    P1 = 0xFF;
    delayMs(500);
    
    // === Continuous Loop (Heartbeat only) ===
    lastRedLedToggle = getMs();
    
    while(1)
    {
        boardService();
        usbComService();
        updateHeartbeatLed();
    }
}