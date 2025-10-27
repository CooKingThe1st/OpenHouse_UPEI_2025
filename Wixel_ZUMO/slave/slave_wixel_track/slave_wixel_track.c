/*
 * ================= SLAVE WIXEL INTEGRATED VERSION =================
 *
 * State Machine: IDLE -> HOME -> IDLE
 *                IDLE -> PREP -> RUN -> IDLE
 * 
 * Features:
 * - HOME state: Rotate to face target (working P-controller)
 * - RUN state: Waypoint path following (rotate-then-drive)
 * - Manual PWM mode for calibration
 * - 3-press calibration system
 * - Velocity to PWM conversion
 * 
 * LED States:
 * - RED: IDLE
 * - BLUE: HOME (rotating to face target)
 * - GREEN: RUN (following waypoints)
 * - PURPLE: PREP (collecting waypoints)
 * - YELLOW: CALIBRATE_VALIDATE
 * ============================================================
 */

#include <wixel.h>
#include <usb.h>
#include <radio_registers.h>

/* ================== CONFIGURATION CONSTANTS ================== */

// --- Slave Configuration ---
#define THIS_SLAVE_ADDRESS      0x01 // from 0x01 to 0x04
// #define PRE_X -2700
// #define PRE_Y -2400

// for 0x02 it is -2700 -2400

// increasing X, same y
// # still  and --

// --- Command Definitions ---
#define CMD_STOP                0x10
#define CMD_GO_TO               0x11
#define CMD_PREP                0x12
#define CMD_RUN                 0x13
#define CMD_AUX                 0x14
#define CMD_CALIBRATE           0x15

// --- Protocol Definitions ---
#define MESSAGE_DELIMITER       0xFF
#define BYTES_PER_SLAVE         16
#define RADIO_PACKET_SIZE       64

// --- GPIO Pin Definitions (RGB Control) ---
#define LED_RED_PIN             2
#define LED_GREEN_PIN           1
#define LED_BLUE_PIN            7

// --- Motor Control Pins ---
#define R_PWM_PIN               3
#define R_DIR_PIN               5
#define L_PWM_PIN               4
#define L_DIR_PIN               6

// --- Rotation Controller Parameters ---
#define ROTATION_KP_NUM         3      // Numerator for 1.5 gain (3/2)
#define ROTATION_KP_DEN         2      // Denominator
#define MAX_ROTATION_PWM        100    // Max PWM for rotation
#define MIN_ROTATION_PWM        50     // Min PWM to overcome friction
#define HEADING_THRESHOLD       5      // degrees - stop when within this

// --- Steering While Driving Parameters ---
#define STEERING_KP             2      // Proportional gain for steering correction
#define MAX_STEERING_ADJUST     30     // Max PWM adjustment for steering

// --- Forward Motion Parameters ---
#define FORWARD_SPEED_PWM       80     // PWM for forward motion in RUN state
#define GOAL_THRESHOLD          150    // mm - waypoint reached threshold

// --- HOME State Behavior Flag ---
#define HOME_ROTATE_ONLY        0      // 1 = rotate only, 0 = drive to target

// Motor control limits
#define PWM_DEADZONE            40     // Dead zone to overcome static friction

// --- Timing Constants ---
#define CONNECTION_TIMEOUT      3000
#define GO_TO_TIMEOUT           10000
#define RUN_TIMEOUT             60000  // 60 seconds for RUN state

// --- Position Filtering ---
#define POSITION_JUMP_THRESHOLD 500
#define FILTER_ALPHA_HIGH       0.95
#define FILTER_ALPHA_LOW        0.2

// --- Waypoint Configuration ---
#define MAX_WAYPOINTS           20

/* ================== STATE MACHINE DEFINITIONS ================== */

#define STATE_IDLE              0
#define STATE_HOME              1
#define STATE_RUN               2
#define STATE_PREP              3
#define STATE_CALIBRATE_VALIDATE 16

/* ================== GLOBAL VARIABLES ================== */

// Radio RX packet buffer
static volatile XDATA uint8 rxPacket[1 + RADIO_PACKET_SIZE + 2];

// State machine
uint8 currentState = STATE_IDLE;

// LED timing
uint16 lastPacketTimeCheck = 0;
uint16 lastPacketTime = 0;
uint16 counter_loop = 0;
uint32 now = 0;
uint32 rxPulseStart = 1;

// Position data (from OptiTrack) - mm
int16 posX = 0;
int16 posY = 0;
int16 posTheta = 0;

// Filtered position
int16 filteredX = 0;
int16 filteredY = 0;
int16 filteredTheta = 0;

// Target location (for GO_TO)
int16 targetX = 0;
int16 lastTargetX = 0;
int16 targetY = 0;
int16 lastTargetY = 0;

// State timeout tracking
uint32 stateStartTime = 0;

// Motor PWM values
int16 pwm_left = 0;
int16 pwm_right = 0;

// Manual PWM (for calibration)
int16 manualPwmLeft = 0;
int16 manualPwmRight = 0;

// Waypoint buffer
typedef struct
{
    uint8 order;
    int16 x;
    int16 y;
} Waypoint;

Waypoint waypoints[MAX_WAYPOINTS];
uint8 waypointCount = 0;
uint8 waypointInputIndex = 0;
uint8 currentWaypointIndex = 0;

// RUN state sub-state (0 = rotating, 1 = driving)
uint8 runSubState = 0;

// HOME state sub-state (0 = rotating, 1 = driving) - used when HOME_ROTATE_ONLY = 0
uint8 homeSubState = 0;

// Misc
uint8 i;

// --- Calibration Data ---
typedef struct {
    int16 xa, ya, thetaa;
    int16 xb, yb, thetab;
    int16 xc, yc, thetac;
} CalibrationData;

static volatile CalibrationData calData;
int16 orientationOffset = 0;  // degrees
int16 cal_targetHeading = 0;
int16 cal_headingError = 0;
uint8 calib_step = 0;

/* ================== HELPER FUNCTIONS ================== */

int16 abs16(int16 val)
{
    return (val < 0) ? -val : val;
}

/*
 * Check if position is within threshold (avoids sqrt for efficiency)
 */
uint8 isWithinThreshold(int16 currentX, int16 currentY, int16 targetX, int16 targetY, int16 threshold)
{
    int16 dx = targetX - currentX;
    int16 dy = targetY - currentY;
    int32 distSquared = (int32)dx * dx + (int32)dy * dy;
    int32 thresholdSquared = (int32)threshold * threshold;
    
    return (distSquared < thresholdSquared);
}

/* ================== ROTATION FUNCTIONS ================== */

int16 calculateTargetHeading(int16 currentX, int16 currentY, int16 goalX, int16 goalY)
{
    int32 dx, dy;
    int32 absX, absY;
    int16 angle;
    int32 ratio;
    
    dx = (int32)goalX - (int32)currentX;
    dy = (int32)goalY - (int32)currentY;
    
    if (dx == 0 && dy == 0)
        return 0;
    
    if (dx == 0)
        return (dy > 0) ? 90 : -90;
    
    if (dy == 0)
        return (dx > 0) ? 0 : 180;
    
    absX = (dx > 0) ? dx : -dx;
    absY = (dy > 0) ? dy : -dy;
    
    if (absX > absY)
    {
        ratio = (absY * 1000L) / absX;
        angle = (int16)((57300L * ratio) / (1000000L + (280L * ratio * ratio) / 1000L));
    }
    else
    {
        ratio = (absX * 1000L) / absY;
        angle = 90 - (int16)((57300L * ratio) / (1000000L + (280L * ratio * ratio) / 1000L));
    }
    
    if (dx >= 0 && dy >= 0)
        return angle;
    else if (dx < 0 && dy >= 0)
        return 180 - angle;
    else if (dx < 0 && dy < 0)
        return angle - 180;
    else
        return -angle;
}

void calculateAndApplyOffset()
{
    int16 actualHeading, reportedHeading;
    actualHeading = calculateTargetHeading(calData.xa, calData.ya, calData.xb, calData.yb);
    reportedHeading = calData.thetaa;
    orientationOffset = actualHeading - reportedHeading;

    if (orientationOffset > 180) { orientationOffset -= 360; }
    if (orientationOffset < -180) { orientationOffset += 360; }
}

void filterPosition()
{
    int16 dx, dy;
    int32 distSquared;
    int16 alpha_num, alpha_den;
    
    dx = posX - filteredX;
    dy = posY - filteredY;
    distSquared = (int32)dx * dx + (int32)dy * dy;
    
    if (distSquared > (int32)POSITION_JUMP_THRESHOLD * POSITION_JUMP_THRESHOLD)
    {
        alpha_num = 1;
        alpha_den = 5;
    }
    else
    {
        alpha_num = 9;
        alpha_den = 10;
    }
    
    filteredX = posX;
    filteredY = posY;
    filteredTheta = posTheta;
}

void rotationController(int16 currentHeading, int16 targetHeading)
{
    int16 error;
    int16 abs_error;
    int32 pwm_raw;
    int16 pwm;
    
    error = targetHeading - currentHeading;
    
    if (error > 180)
        error -= 360;
    if (error < -180)
        error += 360;
    
    abs_error = (error >= 0) ? error : -error;
    
    if (abs_error < HEADING_THRESHOLD)
    {
        pwm_left = 0;
        pwm_right = 0;
        return;
    }
    
    pwm_raw = ((int32)error * ROTATION_KP_NUM) / ROTATION_KP_DEN;
    
    if (pwm_raw > MAX_ROTATION_PWM)
        pwm = MAX_ROTATION_PWM;
    else if (pwm_raw < -MAX_ROTATION_PWM)
        pwm = -MAX_ROTATION_PWM;
    else
        pwm = (int16)pwm_raw;
    
    if (pwm > 0 && pwm < MIN_ROTATION_PWM)
        pwm = MIN_ROTATION_PWM;
    else if (pwm < 0 && pwm > -MIN_ROTATION_PWM)
        pwm = -MIN_ROTATION_PWM;
    
    if (pwm > 0)
    {
        pwm_left = -pwm;
        pwm_right = pwm;
    }
    else
    {
        pwm_left = -pwm;
        pwm_right = pwm;
    }
}

/* ================== MOTOR CONTROL ================== */

void timer3Init()
{
    T3CTL = 0b01110000;
    T3CC0 = T3CC1 = 0;
    T3CCTL0 = T3CCTL1 = 0b00100100;
    PERCFG &= ~(1<<5);
    P1SEL |= (1<<R_PWM_PIN) | (1<<L_PWM_PIN);
}

void setMotorsPWM()
{
    if (pwm_left >= 0)
    {
        T3CC1 = pwm_left;
        P1_6 = 0;
    }
    else
    {
        T3CC1 = -pwm_left;
        P1_6 = 1;
    }
    
    if (pwm_right >= 0)
    {
        T3CC0 = pwm_right;
        P1_5 = 0;
    }
    else
    {
        T3CC0 = -pwm_right;
        P1_5 = 1;
    }
}

void stopMotors()
{
    T3CC0 = 0;
    T3CC1 = 0;
    P1_5 = 0;
    P1_6 = 0;
}

/* ================== RADIO INITIALIZATION ================== */

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
    dmaConfig.radio.LENL = 1 + RADIO_PACKET_SIZE + 2;
    dmaConfig.radio.VLEN_LENH = 0b10000000;
    dmaConfig.radio.DC7 = 0x10;
    DMAARM |= (1<<DMA_CHANNEL_RADIO);
    RFST = 2;
}

void gpioInit()
{
    P1SEL = 0x00;
    P1DIR = 0x00;
    P1 = 0x00;
    T1CTL = 0x00;
    T3CTL = 0x00;
    T4CTL = 0x00;
    P1DIR |= (1 << LED_RED_PIN) | (1 << LED_GREEN_PIN) | (1 << LED_BLUE_PIN);
    P1DIR |= (1 << R_DIR_PIN) | (1 << L_DIR_PIN);
    P1SEL = 0x00;
    P1_1 = 1;
    P1_2 = 1;
    P1_7 = 1;
    T3CC0 = 0;
    T3CC1 = 0;
    P1_5 = 0;
    P1_6 = 0;
}

/* ================== LED CONTROL ================== */

void updateRgbLeds()
{
    if (currentState == STATE_CALIBRATE_VALIDATE)
    {
        // YELLOW (RED + GREEN)
        P1_2 = 0;
        P1_1 = 0;
        P1_7 = 1;
    }
    else if (currentState == STATE_HOME)
    {
        // BLUE
        P1_2 = 1;
        P1_1 = 1;
        P1_7 = 0;
    }
    else if (currentState == STATE_RUN)
    {
        // GREEN if is starting the mission.
        P1_2 = 1;
        P1_1 = 0;
        P1_7 = 1;

        if (currentWaypointIndex == 0){
            // Flash Green + Blue (CYAN) for start of RUN instead
            P1_7 = 0;
        }
    }
    else if (currentState == STATE_PREP)
    {
        // PURPLE (RED + BLUE)
        P1_2 = 0;
        P1_1 = 1;
        P1_7 = 0;
    }
    else // STATE_IDLE
    {
        // RED
        P1_2 = 0;
        P1_1 = 1;
        P1_7 = 1;
    }
}

/* ================== PACKET PROCESSING ================== */

void extractPositionData(uint8 offset)
{
    uint8 rawTheta;
    int16 mapped_theta;

    posX = (int16)((rxPacket[offset + 1] << 8) | rxPacket[offset + 2]);
    posY = (int16)((rxPacket[offset + 3] << 8) | rxPacket[offset + 4]);
    rawTheta = rxPacket[offset + 5]; 
    
    mapped_theta = (int16)(((int32)rawTheta * 360L) / 256L);
    mapped_theta += orientationOffset;
    
    if (mapped_theta > 180)
    {
        posTheta = mapped_theta - 360;
    }
    else if (mapped_theta < -180)
    {
        posTheta = mapped_theta + 360;
    }
    else
    {
        posTheta = mapped_theta;
    }
}

void handleCmdStop()
{
    currentState = STATE_IDLE;
    calib_step = 0;
    waypointCount = 0;
    currentWaypointIndex = 0;
    runSubState = 0;
    homeSubState = 0;
    pwm_left = 0;
    pwm_right = 0;
    stopMotors();
}

void handleCmdGoTo(uint8 offset)
{
    targetX = (int16)((rxPacket[offset + 7] << 8) | rxPacket[offset + 8]);
    targetY = (int16)((rxPacket[offset + 9] << 8) | rxPacket[offset + 10]);
    
    if (currentState == STATE_HOME && targetX == lastTargetX && targetY == lastTargetY)
    {
        return;
    }
    
    if (currentState == STATE_HOME)
    {
        if (targetX != lastTargetX || targetY != lastTargetY)
        {
            stateStartTime = (uint32)getMs();
            lastTargetX = targetX;
            lastTargetY = targetY;
            homeSubState = 0;  // Reset to rotation
        }
    }
    else
    {
        stateStartTime = (uint32)getMs();
        lastTargetX = targetX;
        lastTargetY = targetY;
        homeSubState = 0;  // Start with rotation
    }

    currentState = STATE_HOME;
    calib_step = 0;
}

void handleCmdPrep(uint8 offset)
{
    uint8 order;
    int16 wp_x, wp_y;
    
    if (currentState != STATE_IDLE && currentState != STATE_PREP)
    {
        return;
    }

    if (currentState == STATE_IDLE)
    {
        // First PREP packet received - reset waypoint buffer
        waypointCount = 0;
        currentState = STATE_PREP;
    }
    
    // Extract single waypoint from packet (5 bytes starting at offset+7)
    // Format: order, x_high, x_low, y_high, y_low
    order = rxPacket[offset + 7];
    wp_x = (int16)((rxPacket[offset + 8] << 8) | rxPacket[offset + 9]);
    wp_y = (int16)((rxPacket[offset + 10] << 8) | rxPacket[offset + 11]);
    
    // Validate order is within range
    if (order < MAX_WAYPOINTS)
    {
        // Store waypoint at its order index
        waypoints[order].order = order;
        waypoints[order].x = wp_x;
        waypoints[order].y = wp_y;
        
        // Update waypointCount to highest order + 1
        if (order >= waypointCount)
            waypointCount = order + 1;
    }
}

void handleCmdRun()
{
    if (currentState != STATE_PREP)
    {
        return;
    }
    
    if (waypointCount > 0)
    {
        currentState = STATE_RUN;
        currentWaypointIndex = 0;
        runSubState = 0;  // Start with rotation
        stateStartTime = (uint32)getMs();
    }
}

void executeManualPwm()
{
    P1_2 = 0; P1_1 = 0; P1_7 = 1;
    delayMs(100);
    P1_2 = 1; P1_1 = 1; P1_7 = 1;
    
    pwm_left = manualPwmLeft;
    pwm_right = manualPwmRight;
    setMotorsPWM();
    delayMs(2000);
    
    stopMotors();
    manualPwmLeft = 0;
    manualPwmRight = 0;
    
    P1_2 = 0; P1_1 = 0; P1_7 = 1;
    delayMs(100);
    P1_2 = 1; P1_1 = 1; P1_7 = 1;

    pwm_left = 0;
    pwm_right = 0;
    currentState = STATE_IDLE;
}

void handleCmdAux(uint8 offset)
{
    uint8 auxSubCmd = rxPacket[offset + 7];
    switch(auxSubCmd)
    {
        case 0x9F:
            break;
            
        case 0x1F:
            currentState = STATE_IDLE;
            calib_step = 0;
            manualPwmLeft = (int16)((rxPacket[offset + 8] << 8) | rxPacket[offset + 9]);
            manualPwmRight = (int16)((rxPacket[offset + 10] << 8) | rxPacket[offset + 11]);
            executeManualPwm();
            break;
            
        default:
            break;
    }
}

void handleCmdCalibrate()
{
    currentState = STATE_CALIBRATE_VALIDATE;
    updateRgbLeds();

    if (calib_step == 0)
    {
        orientationOffset = 0;
        stopMotors();
        
        calData.xa = posX; calData.ya = posY; 
        calData.thetaa = posTheta - orientationOffset;
        
        pwm_left = 70;
        pwm_right = 70;
        setMotorsPWM();
        delayMs(3000);
        stopMotors();
        pwm_left = 0;
        pwm_right = 0;
        
        calib_step = 1;
        currentState = STATE_IDLE;
    }
    else if (calib_step == 1)
    {
        stopMotors();

        calData.xb = posX; calData.yb = posY; calData.thetab = posTheta;

        pwm_left = -60;
        pwm_right = 60;
        setMotorsPWM();
        delayMs(2000);
        stopMotors();
        pwm_left = 0;
        pwm_right = 0;
        
        calib_step = 2;
        currentState = STATE_IDLE;
    }
    else if (calib_step == 2)
    {
        stopMotors();
        pwm_left = 0;
        pwm_right = 0;
        
        calData.xc = posX; calData.yc = posY; calData.thetac = posTheta;

        calculateAndApplyOffset();
        
        currentState = STATE_CALIBRATE_VALIDATE;
        stateStartTime = (uint32)getMs();
        
        calib_step = 0;
    }
}

void receiveAndProcessPackets()
{
    uint8 slaveAddress;
    uint8 cmd;
    uint8 packetOffset;
    
    if (RFIF & (1<<4))
    {
        if (radioCrcPassed())
        {
            lastPacketTime = (uint16)getMs();
            
            if (lastPacketTime != lastPacketTimeCheck)
            {
                rxPulseStart = 1;
                lastPacketTimeCheck = lastPacketTime;
            }

            if (THIS_SLAVE_ADDRESS == 0x01)
                packetOffset = 1;
            else if (THIS_SLAVE_ADDRESS == 0x02)
                packetOffset = 17;
            else if (THIS_SLAVE_ADDRESS == 0x03)
                packetOffset = 33;
            else if (THIS_SLAVE_ADDRESS == 0x04)
                packetOffset = 49;
            else
            {
                RFIF &= ~(1<<4);
                DMAARM |= (1<<DMA_CHANNEL_RADIO);
                RFST = 2;
                return;
            }
            
            slaveAddress = rxPacket[packetOffset + 0];
            cmd = rxPacket[packetOffset + 6];
            
            if (slaveAddress != THIS_SLAVE_ADDRESS)
            {
                RFIF &= ~(1<<4);
                DMAARM |= (1<<DMA_CHANNEL_RADIO);
                RFST = 2;
                return;
            }
            
            extractPositionData(packetOffset);
            filterPosition();
            
            switch(cmd)
            {
                case CMD_STOP:
                    handleCmdStop();
                    break;
                case CMD_GO_TO:
                    handleCmdGoTo(packetOffset);
                    break;
                case CMD_PREP:
                    handleCmdPrep(packetOffset);
                    break;
                case CMD_RUN:
                    handleCmdRun();
                    break;
                case CMD_CALIBRATE:
                    handleCmdCalibrate();
                    break;
                case CMD_AUX:
                    handleCmdAux(packetOffset);
                    break;
            }
        }
        
        RFIF &= ~(1<<4);
        DMAARM |= (1<<DMA_CHANNEL_RADIO);
        RFST = 2;
    }
}

void handlePacketTimeout()
{
    if ((uint16)(getMs() - lastPacketTime) > CONNECTION_TIMEOUT)
    {
        currentState = STATE_IDLE;
        calib_step = 0;
        waypointCount = 0;
        currentWaypointIndex = 0;
        runSubState = 0;
        homeSubState = 0;
        pwm_left = 0;
        pwm_right = 0;
        stopMotors();
    }
}

/* ================== STATE MACHINE ================== */

void updateHomeState()
{
    uint32 elapsedTime = now - stateStartTime;
    int16 targetHeading;
    int16 headingError;
    int16 abs_error;
    
    if (elapsedTime >= GO_TO_TIMEOUT)
    {
        currentState = STATE_IDLE;
        homeSubState = 0;
        pwm_left = 0;
        pwm_right = 0;
        stopMotors();
        lastTargetX = 0;
        lastTargetY = 0;
        return;
    }
    
#if HOME_ROTATE_ONLY
    // ===== MODE 1: ROTATE ONLY (original behavior) =====
    targetHeading = calculateTargetHeading(filteredX, filteredY, targetX, targetY);
    
    headingError = targetHeading - filteredTheta;
    if (headingError > 180)
        headingError -= 360;
    if (headingError < -180)
        headingError += 360;
    
    abs_error = (headingError >= 0) ? headingError : -headingError;
    
    if (abs_error < HEADING_THRESHOLD)
    {
        pwm_left = 0;
        pwm_right = 0;
        currentState = STATE_IDLE;
        stopMotors();
    }
    else
    {
        rotationController(filteredTheta, targetHeading);
    }
#else
    // ===== MODE 2: DRIVE TO TARGET (rotate-then-drive) =====
    if (homeSubState == 0)
    {
        // ROTATING to face target
        targetHeading = calculateTargetHeading(filteredX, filteredY, targetX, targetY);
        
        headingError = targetHeading - filteredTheta;
        if (headingError > 180)
            headingError -= 360;
        if (headingError < -180)
            headingError += 360;
        
        abs_error = (headingError >= 0) ? headingError : -headingError;
        
        if (abs_error < HEADING_THRESHOLD)
        {
            // Aligned, switch to driving
            homeSubState = 1;
        }
        else
        {
            rotationController(filteredTheta, targetHeading);
        }
    }
    else if (homeSubState == 1)
    {
        // DRIVING forward to target with steering correction
        if (isWithinThreshold(filteredX, filteredY, targetX, targetY, GOAL_THRESHOLD))
        {
            // Target reached
            currentState = STATE_IDLE;
            homeSubState = 0;
            pwm_left = 0;
            pwm_right = 0;
            stopMotors();
            lastTargetX = 0;
            lastTargetY = 0;
        }
        else
        {
            // Calculate current heading error while driving
            targetHeading = calculateTargetHeading(filteredX, filteredY, targetX, targetY);
            
            headingError = targetHeading - filteredTheta;
            if (headingError > 180)
                headingError -= 360;
            if (headingError < -180)
                headingError += 360;
            
            abs_error = (headingError >= 0) ? headingError : -headingError;
            
            // If heading error too large, stop driving and go back to rotation
            if (abs_error > 45)
            {
                homeSubState = 0;  // Back to rotation phase
                pwm_left = 0;
                pwm_right = 0;
            }
            else
            {
                // Apply proportional steering correction while driving
                int16 steeringAdjust = (headingError * STEERING_KP);
                
                // Clamp steering adjustment
                if (steeringAdjust > MAX_STEERING_ADJUST)
                    steeringAdjust = MAX_STEERING_ADJUST;
                if (steeringAdjust < -MAX_STEERING_ADJUST)
                    steeringAdjust = -MAX_STEERING_ADJUST;
                
                // Apply differential drive: left wheel slower for right turn, vice versa
                pwm_left = FORWARD_SPEED_PWM - steeringAdjust;
                pwm_right = FORWARD_SPEED_PWM + steeringAdjust;
                
                // Ensure motors don't reverse or stall
                if (pwm_left < 0) pwm_left = 0;
                if (pwm_right < 0) pwm_right = 0;
            }
        }
    }
#endif
}

void updateRunState()
{
    uint32 elapsedTime = now - stateStartTime;
    int16 targetHeading;
    int16 headingError;
    int16 abs_error;
    
    if (elapsedTime >= RUN_TIMEOUT)
    {
        currentState = STATE_IDLE;
        waypointCount = 0;
        currentWaypointIndex = 0;
        runSubState = 0;
        pwm_left = 0;
        pwm_right = 0;
        stopMotors();
        return;
    }
    
    if (currentWaypointIndex >= waypointCount)
    {
        // All waypoints reached
        currentState = STATE_IDLE;
        waypointCount = 0;
        currentWaypointIndex = 0;
        runSubState = 0;
        pwm_left = 0;
        pwm_right = 0;
        stopMotors();
        return;
    }
    
    // Get current waypoint
    targetX = waypoints[currentWaypointIndex].x;
    targetY = waypoints[currentWaypointIndex].y;
    
    if (runSubState == 0)
    {
        // ROTATING to face waypoint
        targetHeading = calculateTargetHeading(filteredX, filteredY, targetX, targetY);
        
        headingError = targetHeading - filteredTheta;
        if (headingError > 180)
            headingError -= 360;
        if (headingError < -180)
            headingError += 360;
        
        abs_error = (headingError >= 0) ? headingError : -headingError;
        
        if (abs_error < HEADING_THRESHOLD)
        {
            // Aligned, switch to driving
            runSubState = 1;
        }
        else
        {
            rotationController(filteredTheta, targetHeading);
        }
    }
    else if (runSubState == 1)
    {
        // DRIVING forward to waypoint with steering correction
        if (isWithinThreshold(filteredX, filteredY, targetX, targetY, GOAL_THRESHOLD))
        {
            // Waypoint reached
            currentWaypointIndex++;
            runSubState = 0;  // Reset to rotation for next waypoint
            pwm_left = 0;
            pwm_right = 0;
        }
        else
        {
            // Calculate current heading error while driving
            targetHeading = calculateTargetHeading(filteredX, filteredY, targetX, targetY);
            
            headingError = targetHeading - filteredTheta;
            if (headingError > 180)
                headingError -= 360;
            if (headingError < -180)
                headingError += 360;
            
            abs_error = (headingError >= 0) ? headingError : -headingError;
            
            // If heading error too large, stop driving and go back to rotation
            if (abs_error > 45)
            {
                runSubState = 0;  // Back to rotation phase
                pwm_left = 0;
                pwm_right = 0;
            }
            else
            {
                // Apply proportional steering correction while driving
                int16 steeringAdjust = (headingError * STEERING_KP);
                
                // Clamp steering adjustment
                if (steeringAdjust > MAX_STEERING_ADJUST)
                    steeringAdjust = MAX_STEERING_ADJUST;
                if (steeringAdjust < -MAX_STEERING_ADJUST)
                    steeringAdjust = -MAX_STEERING_ADJUST;
                
                // Apply differential drive: left wheel slower for right turn, vice versa
                pwm_left = FORWARD_SPEED_PWM - steeringAdjust;
                pwm_right = FORWARD_SPEED_PWM + steeringAdjust;
                
                // Ensure motors don't reverse or stall
                if (pwm_left < 0) pwm_left = 0;
                if (pwm_right < 0) pwm_right = 0;
            }
        }
    }
}

void updateStateMachine()
{
    switch(currentState)
    {
        case STATE_IDLE:
            stopMotors();
            break;
        case STATE_HOME:
            updateHomeState();
            break;
        case STATE_RUN:
            updateRunState();
            break;
        case STATE_PREP:
            // Stay in PREP, just update LED
            break;
        case STATE_CALIBRATE_VALIDATE:
            cal_targetHeading = calculateTargetHeading(filteredX, filteredY, 0, 0);
            rotationController(filteredTheta, cal_targetHeading);
            
            cal_headingError = cal_targetHeading - filteredTheta;
            if (cal_headingError > 180) cal_headingError -= 360;
            if (cal_headingError < -180) cal_headingError += 360;
            
            if (abs16(cal_headingError) < HEADING_THRESHOLD)
            {
                currentState = STATE_IDLE;
            }
            break;
    }
}

/* ================== MAIN FUNCTION ================== */

void main()
{
    systemInit();
    gpioInit();
    timer3Init();
    radioInit();
    
    lastPacketTime = (uint16)getMs();
    
    // RGB LED Test Sequence
    P1_2 = 0; P1_1 = 1; P1_7 = 1; delayMs(300);  // RED
    P1_2 = 1; P1_1 = 0; P1_7 = 1; delayMs(300);  // GREEN
    P1_2 = 1; P1_1 = 1; P1_7 = 0; delayMs(300);  // BLUE
    P1_2 = 0; P1_1 = 1; P1_7 = 0; delayMs(300);  // PURPLE
    P1_2 = 1; P1_1 = 1; P1_7 = 1; delayMs(500);  // OFF
    
    lastPacketTime = (uint16)getMs();
    currentState = STATE_IDLE;
    
    // Main Loop
    while(1)
    {
        boardService();
        
        now = (uint32)getMs();
        
        // Heartbeat
        counter_loop++;
        counter_loop %= 5001;
        if (counter_loop % 500 == 0)
            LED_YELLOW_TOGGLE();
        
        // Process packets
        receiveAndProcessPackets();
        
        // RED LED pulse on packet
        if (rxPulseStart < 600)
        {
            LED_RED(1);
            rxPulseStart += 1;
        }
        else
        {
            LED_RED(0);
        }
        
        // State machine and control
        handlePacketTimeout();
        updateStateMachine();
        updateRgbLeds();
        setMotorsPWM();
    }
}