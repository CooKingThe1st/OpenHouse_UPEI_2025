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

#include <wixel.h>
#include <usb.h>
#include <usb_com.h>
#include <time.h>       // For getMs()

// -- Motor Pin Definitions --
#define R_PWM_PIN       3  // P1_3 (T3CC0)
#define R_DIR_PIN       5  // P1_5 (D7)

// Set a medium speed for the test (out of 255)
#define MOTOR_SPEED 150

// -- Timing Variables --
uint32 lastRedLedToggle = 0;
uint32 lastMotorActionTime = 0;
uint8 motorState = 0; // 0=Stop, 1=Forward, 2=Stop, 3=Reverse

/**
 * Initializes Timer 3 for PWM on P1_3 and P1_4 and sets duty cycle to 0.
 */
void timer3Init()
{
    T3CTL = 0b01110000;   // Prescaler 1:8, frequency = 11.7 kHz
    T3CC0 = T3CC1 = 0;    // Set duty cycles to zero
    T3CCTL0 = T3CCTL1 = 0b00100100;
    PERCFG &= ~(1<<5);
    P1SEL |= (1<<3) | (1<<4);
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

// void updateMotorState() {
// if (motorState == 0) sendMsg("STOP1\n");
// else if (motorState == 1) sendMsg("FORWARD\n");
// else if (motorState == 2) sendMsg("STOP2\n");
// else if (motorState == 3) sendMsg("REVERSE\n");

//     if (getMs() - lastMotorActionTime >= 2000) {
//         motorState = (motorState + 1) % 4;
        
//         switch(motorState) {
//             case 0: // STOP (after reverse)
//                 T3CC0 = 0;
//                 usbComService(); // Allow USB messages to send
//                 // printf("STOP\r\n");
//                 break;
                
//             case 1: // FORWARD
//                 setDigitalOutput(R_DIR_PIN, 0);
//                 T3CC0 = MOTOR_SPEED;
//                 // printf("FORWARD - P1_%d = 0\r\n", R_DIR_PIN);
//                 break;
                
//             case 2: // STOP (after forward)
//                 T3CC0 = 0;
//                 // printf("STOP\r\n");
//                 break;
                
//             case 3: // REVERSE
//                 setDigitalOutput(R_DIR_PIN, 1);
//                 T3CC0 = MOTOR_SPEED;
//                 // printf("REVERSE - P1_%d = 1\r\n", R_DIR_PIN);
//                 break;
//         }
//         lastMotorActionTime = getMs();
//     }
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
    
    // Disable timers that might conflict (but NOT the one USB uses)
    T1CTL = 0x00;
    T3CTL = 0x00;
    T4CTL = 0x00;
    
    // DON'T touch U0CSR or U1CSR - USB needs these!
    
    // NOW set up our specific pins as outputs
    P1DIR |= (1 << 1) | (1 << 2) | (1 << 7);  // RGB pins as outputs
    P1DIR |= (1 << 5);  // Motor direction as output
    
    // Verify P1SEL is still clear
    P1SEL = 0x00;
    
    // === LED Test Sequence ===
    
    // All OFF (active-low: 0xFF means all high = all off)
    P1 = 0xFF;
    delayMs(1000);
    
    // Red ON only
    P1 = 0b11111101;  // Only bit 1 is 0
    delayMs(1000);
    
    // Green ON only
    P1 = 0b11111011;  // Only bit 2 is 0
    delayMs(1000);
    
    // Blue ON only
    P1 = 0b01111111;  // Only bit 7 is 0
    delayMs(1000);
    
    // All OFF again
    P1 = 0xFF;
    delayMs(500);
    
    // === Initialize Motor Control ===
    timer3Init();
    
    // === Motor Direction Test ===
    
    // FORWARD - Direction bit 5 = 0, RGB all off (1)
    P1 = 0b11011111;  // Bit 5 = 0 (direction), RGB bits high (off)
    T3CC0 = MOTOR_SPEED;
    delayMs(2000);
    
    // STOP
    T3CC0 = 0;
    delayMs(1000);
    
    // REVERSE - Direction bit 5 = 1, RGB all off (1)
    P1 = 0b11111111;  // Bit 5 = 1 (direction), RGB bits high (off)
    T3CC0 = MOTOR_SPEED;
    delayMs(2000);
    
    // STOP
    T3CC0 = 0;

    while(1)
    {
        boardService();
        usbComService();
        delayMs(100);
    }
}