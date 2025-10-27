import math
import matplotlib.pyplot as plt
import numpy as np

# --- Constants for C Data Types ---
INT16_MAX = 32767
INT16_MIN = -32768
INT32_MAX = 2147483647
INT32_MIN = -2147483648

def to_int16(value: int) -> int:
    """Simulates C's 16-bit signed integer behavior (wrap-around)."""
    return (value + INT16_MAX + 1) % 65536 - (INT16_MAX + 1)

def to_int32(value: int) -> int:
    """Simulates C's 32-bit signed integer behavior (wrap-around)."""
    return (value + INT32_MAX + 1) % 4294967296 - (INT32_MAX + 1)

def cast_to_int16(value: float) -> int:
    """Simulates C's (int16) cast from a float/double."""
    value = int(value) # Truncates decimal
    return to_int16(value)

def cast_to_int32(value: float) -> int:
    """Simulates C's (int32) cast from a float/double."""
    value = int(value) # Truncates decimal
    return to_int32(value)

# --- Constants from slave_wixel_track.c ---
ZUMO_MAX_PWM = 255
ZUMO_MAX_VELOCITY_PWM = 150  # PWM for max speed estimate
ZUMO_MAX_VELOCITY_MMS = 700  # mm/s at PWM=150
WHEELBASE_MM = 100     # Distance between left and right wheels (mm)
STEERING_GAIN = 2      # Proportional steering gain
MIN_PWM = 40           # Minimum PWM (no movement)
MAX_PWM = 120          # Maximum PWM
PWM_DEADZONE = 30      # Dead zone to overcome static friction

def velocity_to_pwm(velocity_mms: int) -> int:
    """
    Mimics the velocityToPWM C function *with* integer math simulation.
    """
    if velocity_mms == 0:
        return 0

    # C code: pwm = ((int32)velocity_mms * ZUMO_MAX_VELOCITY_PWM) / ZUMO_MAX_VELOCITY_MMS;
    intermediate_mul = to_int32(int(velocity_mms) * ZUMO_MAX_VELOCITY_PWM)
    
    if intermediate_mul < 0:
        pwm = int(intermediate_mul / ZUMO_MAX_VELOCITY_MMS) # C-style truncation
    else:
        pwm = intermediate_mul // ZUMO_MAX_VELOCITY_MMS # Floor division is fine
        
    pwm = to_int32(pwm) # Result is still int32
    
    if pwm > MAX_PWM:
        pwm = MAX_PWM
    elif pwm < -MAX_PWM:
        pwm = -MAX_PWM

    if 0 < pwm < PWM_DEADZONE:
        pwm = PWM_DEADZONE
    elif -PWM_DEADZONE < pwm < 0:
        pwm = -PWM_DEADZONE
        
    return cast_to_int16(pwm)


def apf_to_motor(apf_vel_x: float, apf_vel_y: float, current_theta_deg: float) -> (int, int):
    """
    Mimics the apf2motor C function.
    Converts an APF vector (vx, vy) into left/right PWM commands.
    """
    
    vel_mag = math.sqrt(apf_vel_x**2 + apf_vel_y**2)

    if vel_mag == 0:
        return 0, 0

    heading_desired_deg = math.degrees(math.atan2(apf_vel_y, apf_vel_x))

    steering_error = heading_desired_deg - current_theta_deg
    
    while steering_error > 180:
        steering_error -= 360
    while steering_error < -180:
        steering_error += 360

    steering_adjustment = (steering_error * WHEELBASE_MM * STEERING_GAIN) / 200.0
    
    vel_left = vel_mag - steering_adjustment
    vel_right = vel_mag + steering_adjustment

    vel_left = max(-ZUMO_MAX_VELOCITY_MMS, min(ZUMO_MAX_VELOCITY_MMS, vel_left))
    vel_right = max(-ZUMO_MAX_VELOCITY_MMS, min(ZUMO_MAX_VELOCITY_MMS, vel_right))

    pwm_left = velocity_to_pwm(vel_left)
    pwm_right = velocity_to_pwm(vel_right)
    
    return pwm_left, pwm_right

# --- Example Simulation (from your code) ---

print("--- Simulation 1: No Steering Error ---")
current_theta = 45  # Robot is facing 45 degrees
apf_vel_x = 250
apf_vel_y = 250
print(f"Robot State: (x=0, y=0, theta={current_theta} deg)")
print(f"APF Vector: (vx={apf_vel_x}, vy={apf_vel_y}) mm/s")
pwm_l, pwm_r = apf_to_motor(apf_vel_x, apf_vel_y, current_theta)
print(f"Resulting PWM: Left={pwm_l}, Right={pwm_r}\n")


print("--- Simulation 2: Steering Correction ---")
current_theta = 0 # Robot is facing straight (0 deg)
print(f"Robot State: (x=0, y=0, theta={current_theta} deg)")
print(f"APF Vector: (vx={apf_vel_x}, vy={apf_vel_y}) mm/s (Desired: 45 deg)")
pwm_l, pwm_r = apf_to_motor(apf_vel_x, apf_vel_y, current_theta)
print(f"Resulting PWM: Left={pwm_l}, Right={pwm_r}\n")


# --- Plot 1: velocity_to_pwm response curve ---
print("--- Generating Plot 1: velocity_to_pwm Response ---")
velocities = np.linspace(-ZUMO_MAX_VELOCITY_MMS * 1.5, ZUMO_MAX_VELOCITY_MMS * 1.5, 400)
pwms = [velocity_to_pwm(v) for v in velocities]

plt.figure(figsize=(10, 6))
plt.plot(velocities, pwms, label='PWM Output')
plt.axhline(y=MAX_PWM, color='r', linestyle='--', label=f'MAX_PWM ({MAX_PWM})')
plt.axhline(y=-MAX_PWM, color='r', linestyle='--')
plt.axhline(y=PWM_DEADZONE, color='g', linestyle='--', label=f'PWM_DEADZONE ({PWM_DEADZONE})')
plt.axhline(y=-PWM_DEADZONE, color='g', linestyle='--')
plt.title('`velocity_to_pwm` Response Curve')
plt.xlabel('Input Velocity (mm/s)')
plt.ylabel('Output PWM')
plt.legend()
plt.grid(True)
plt.savefig('pwm_response_curve.png')
print("Saved 'pwm_response_curve.png'\n")


# --- Plot 2: Steering response ---
print("--- Generating Plot 2: Steering Response ---")
# Test conditions
apf_vel_x_test = 250
apf_vel_y_test = 250
target_heading = math.degrees(math.atan2(apf_vel_y_test, apf_vel_x_test))

# Sweep the robot's current heading from -180 to 180
theta_range = np.linspace(-180, 180, 360)
pwm_left_list = []
pwm_right_list = []

for theta in theta_range:
    l, r = apf_to_motor(apf_vel_x_test, apf_vel_y_test, theta)
    pwm_left_list.append(l)
    pwm_right_list.append(r)

plt.figure(figsize=(12, 7))
plt.plot(theta_range, pwm_left_list, label='Left Wheel PWM')
plt.plot(theta_range, pwm_right_list, label='Right Wheel PWM')
plt.axvline(x=target_heading, color='r', linestyle='--', label=f'Target Heading ({target_heading:.1f} deg)')
plt.title('Controller Steering Response')
plt.xlabel('Robot\'s Current Heading (degrees)')
plt.ylabel('Output PWM')
plt.xticks(np.arange(-180, 181, 45))
plt.legend()
plt.grid(True)
plt.savefig('steering_response.png')
print("Saved 'steering_response.png'\n")