# Integrated digital twin simulation for single robot heading to a fixed goal.
# This code implements:
# - APF attractive force (C-like logic)
# - apf2motor (approximation as provided) => computes left/right wheel velocities (mm/s)
# - velocity_to_pwm (controller-side conversion)
# - pwm_to_true_velocity (uses calibration model you provided)
# - kinematic integration using pwm->true motion to update pose
# - plotting: trajectory, PWM over time, true velocities over time
#
# Outputs saved to files: 'digital_twin_trajectory.png', 'digital_twin_pwms.png', 'digital_twin_velocities.png'

import math
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from dataclasses import dataclass

# -------------------- Calibration parameters (from your RANSAC fits) --------------------
# These map PWM -> measured motion when you commanded PWM directly
CAL = {
    'linear_fwd_slope': 2.4055,    # mm/s per PWM (forward)
    'linear_fwd_intercept': -77.2917,
    'linear_bwd_slope': -2.4496,   # negative because mapping used in analysis; we'll use piecewise
    'linear_bwd_intercept': -82.6115,
    'angular_cw_slope': -3.0424,   # deg/s per PWM (CW)
    'angular_cw_intercept': 156.9508,
    'angular_ccw_slope': 2.9553,
    'angular_ccw_intercept': -147.5931
}

# -------------------- Robot / controller constants --------------------
WHEELBASE_MM = 100.0
STEERING_GAIN = 2.0
ZUMO_MAX_VELOCITY_MMS = 700.0   # controller assumed max linear velocity (mm/s)
ZUMO_MAX_VELOCITY_PWM = 150.0   # controller mapping
PWM_DEADZONE = 30
MAX_PWM = 120
APF_GOAL_THRESHOLD = 30.0       # mm
APF_MAX_VELOCITY = 400.0        # mm/s cap for APF desired velocity (choose reasonable)

# -------------------- helper functions that mimic integer casts (approx) --------------------
def cast_int16(x):
    # emulate C (int16) wrapping
    x = int(x)
    if x > 32767:
        x = ((x + 32768) % 65536) - 32768
    if x < -32768:
        x = ((x - 32768) % 65536) + 32768
    return int(x)

def clamp(x, a, b):
    return max(a, min(b, x))

# -------------------- Controller-side: velocity -> PWM --------------------
def velocity_to_pwm_controller(velocity_mms):
    """
    Controller's velocityToPWM (integer-ish) used in firmware draft.
    This maps desired mm/s -> PWM using assumed linear scaling.
    """
    if velocity_mms == 0:
        return 0
    # emulate intermediate int32 multiplication
    intermediate = int(velocity_mms) * int(ZUMO_MAX_VELOCITY_PWM)
    pwm = intermediate // int(ZUMO_MAX_VELOCITY_MMS)
    # clamp
    if pwm > MAX_PWM:
        pwm = MAX_PWM
    if pwm < -MAX_PWM:
        pwm = -MAX_PWM
    # apply deadzone bump
    if 0 < pwm < PWM_DEADZONE:
        pwm = PWM_DEADZONE
    if -PWM_DEADZONE < pwm < 0:
        pwm = -PWM_DEADZONE
    return int(pwm)

# -------------------- Physical-side: PWM -> true motion (from calibration) --------------------
def pwm_to_velocity_one_wheel_true(pwm):
    """
    Use the calibration lines to convert a commanded PWM into the measured wheel linear speed (mm/s).
    We assume the calibration test used symmetric both-wheels same PWM for linear tests, and spin tests for angular.
    For single wheel mapping we'll use linear_fwd/linear_bwd fits.
    """
    if pwm == 0:
        return 0.0
    if pwm > 0:
        return CAL['linear_fwd_slope'] * pwm + CAL['linear_fwd_intercept']
    else:
        # pwm negative: use backward mapping; careful with sign
        # The fit given for linear_bwd was y = -2.4496 * x + -82.6115 where x was PWM (positive?)
        # In our interpretation, if pwm is negative, mapping depends on magnitude. We'll use:
        return CAL['linear_bwd_slope'] * (-pwm) + CAL['linear_bwd_intercept']  # returns positive speed magnitude for negative pwm? adjust sign
        # The above returns a negative number if slope negative; to keep consistent, we want wheel linear velocity signed:
        # But here linear_bwd_slope is negative; plugging -pwm (positive) gives negative magnitude; that's appropriate.
    
def pwm_pair_to_true_motion(pwm_l, pwm_r):
    """
    Convert left/right PWM into the true forward linear velocity (mm/s) and angular velocity (deg/s)
    using the calibration fits. We'll compute per-wheel signed linear speeds and derive v and w.
    """
    # left wheel linear velocity (signed)
    v_l = pwm_to_velocity_one_wheel_true(pwm_l)
    v_r = pwm_to_velocity_one_wheel_true(pwm_r)
    
    # v_l and v_r currently reflect the fits; ensure the sign matches PWM sign:
    # If pwm is negative, the linear_bwd mapping above produces a negative value (because slope negative), so v_l already signed.
    # For pwm positive, linear_fwd slope positive so v positive.
    
    # forward linear speed: average of wheel linear velocities
    v_linear = 0.5 * (v_l + v_r)
    
    # angular velocity: (v_r - v_l) / wheelbase  [rad/s], convert to deg/s
    w_rad_s = (v_r - v_l) / WHEELBASE_MM
    w_deg_s = math.degrees(w_rad_s)
    return v_linear, w_deg_s, v_l, v_r

# -------------------- APF controller logic (C-like) --------------------
def isqrt(n):
    return int(math.isqrt(max(0, int(n))))

def compute_attractive_forces_go_to(filteredX, filteredY, targetX, targetY):
    """
    Mimics computeAttractiveForcesGoTo from C code.
    Inputs and outputs in mm and mm/s (apfVelX, apfVelY).
    """
    dx = int(targetX - filteredX)
    dy = int(targetY - filteredY)
    dist_sq = dx*dx + dy*dy
    
    if dist_sq == 0:
        return 0.0, 0.0
    
    # threshold check
    if math.hypot(dx, dy) <= APF_GOAL_THRESHOLD:
        return 0.0, 0.0
    
    dist = isqrt(dist_sq)
    velMag = dist if dist <= APF_MAX_VELOCITY else APF_MAX_VELOCITY
    
    apfVelX = (dx * velMag) / dist if dist != 0 else 0.0
    apfVelY = (dy * velMag) / dist if dist != 0 else 0.0
    return float(apfVelX), float(apfVelY)

def heading_approximation(apfVelX, apfVelY):
    """
    Use the integer/quadrant based approximation from your C code to compute heading_desired (deg).
    """
    if apfVelX == 0:
        return 90.0 if apfVelY > 0 else -90.0
    absX = abs(apfVelX)
    absY = abs(apfVelY)
    if absX > absY:
        # angle ≈ (y / x) * 45  (note: C casts will truncate)
        # protect division by zero
        return (apfVelY * 45.0) / apfVelX
    else:
        if apfVelY > 0:
            return 90.0 - (apfVelX * 45.0) / apfVelY
        else:
            return -90.0 - (apfVelX * 45.0) / apfVelY

def normalize_angle_deg(angle):
    a = ((angle + 180) % 360) - 180
    return a

def apf2motor_c_style(apfVelX, apfVelY, filteredTheta):
    """
    Convert APF vector to PWM commands mimicking the provided C code logic.
    filteredTheta is current heading in degrees (int-like).
    """
    # magnitude
    velMagSquared = int(apfVelX*apfVelX + apfVelY*apfVelY)
    if velMagSquared <= 0:
        return 0, 0, 0, 0  # pwm left, pwm right, vel_left, vel_right
    
    # isqrt with capping as in C code
    if velMagSquared > 2147483647:
        velMag = 46340
    else:
        velMag = isqrt(velMagSquared)
    if velMag == 0:
        return 0, 0, 0, 0
    
    # heading desired approx
    heading_desired = heading_approximation(apfVelX, apfVelY)
    steering_error = int(heading_desired) - int(filteredTheta)
    # normalize
    steering_error = normalize_angle_deg(steering_error)
    
    # differential kinematics (C uses steering_error * WHEELBASE * STEERING_GAIN / 200)
    steering_adjust = (steering_error * WHEELBASE_MM * STEERING_GAIN) / 200.0
    vel_left = velMag - steering_adjust
    vel_right = velMag + steering_adjust
    
    # clamp to max velocity
    vel_left = clamp(vel_left, -ZUMO_MAX_VELOCITY_MMS, ZUMO_MAX_VELOCITY_MMS)
    vel_right = clamp(vel_right, -ZUMO_MAX_VELOCITY_MMS, ZUMO_MAX_VELOCITY_MMS)
    
    # convert to PWM using controller's mapping
    pwm_left = velocity_to_pwm_controller(vel_left)
    pwm_right = velocity_to_pwm_controller(vel_right)
    return int(pwm_left), int(pwm_right), vel_left, vel_right

# -------------------- Kinematic update using true velocities --------------------
def update_pose(x, y, theta_deg, v_mm_s, w_deg_s, dt):
    theta_rad = math.radians(theta_deg)
    # integrate in mm space
    x_new = x + v_mm_s * math.cos(theta_rad) * dt
    y_new = y + v_mm_s * math.sin(theta_rad) * dt
    theta_new = theta_deg + w_deg_s * dt
    theta_new = normalize_angle_deg(theta_new)
    return x_new, y_new, theta_new

# -------------------- Simulation loop --------------------
def run_simulation(dt=0.05, max_time=60.0, verbose=False):
    # initial state (mm, deg)
    x, y, theta = 0.0, 0.0, 0.0
    # goal in mm
    targetX, targetY = 1000.0, 1000.0  # 1m, 1m
    t = 0.0
    logs = []
    
    while t < max_time:
        apf_vx, apf_vy = compute_attractive_forces_go_to(x, y, targetX, targetY)
        pwm_l, pwm_r, vel_left_cmd, vel_right_cmd = apf2motor_c_style(apf_vx, apf_vy, theta)
        
        # Get true motion from calibration mapping
        v_true, w_true, v_l_true, v_r_true = pwm_pair_to_true_motion(pwm_l, pwm_r)
        
        # integrate pose using true motion (v_true in mm/s, w_true in deg/s)
        x, y, theta = update_pose(x, y, theta, v_true, w_true, dt)
        
        # record
        logs.append({
            't': t, 'x': x, 'y': y, 'theta': theta,
            'apf_vx': apf_vx, 'apf_vy': apf_vy,
            'pwm_l': pwm_l, 'pwm_r': pwm_r,
            'vel_left_cmd': vel_left_cmd, 'vel_right_cmd': vel_right_cmd,
            'v_l_true': v_l_true, 'v_r_true': v_r_true,
            'v_true': v_true, 'w_true': w_true
        })
        
        if verbose and int(t/dt) % int(1.0/dt) == 0:
            print(f"t={t:.2f}s x={x:.1f} y={y:.1f} theta={theta:.1f} pwmL={pwm_l} pwmR={pwm_r} v={v_true:.1f}")
        
        # stop if within threshold
        if math.hypot(targetX - x, targetY - y) <= APF_GOAL_THRESHOLD:
            if verbose:
                print(f"Goal reached at t={t:.2f}s -> pos=({x:.1f},{y:.1f})")
            break
        
        t += dt
    df = pd.DataFrame(logs)
    return df, (targetX, targetY)

# run
df, goal = run_simulation(dt=0.05, max_time=60.0, verbose=True)

# -------------------- Plots --------------------
plt.figure(figsize=(7,7))
plt.plot(df['x'], df['y'], label='Trajectory')
plt.scatter([goal[0]], [goal[1]], marker='x', label='Goal')
plt.title('Digital Twin Trajectory (mm)')
plt.xlabel('X (mm)')
plt.ylabel('Y (mm)')
plt.axis('equal')
plt.grid(True)
plt.legend()
plt.savefig('digital_twin_trajectory.png')

plt.figure(figsize=(10,5))
plt.plot(df['t'], df['pwm_l'], label='PWM Left')
plt.plot(df['t'], df['pwm_r'], label='PWM Right')
plt.title('PWM Outputs Over Time')
plt.xlabel('Time (s)')
plt.ylabel('PWM')
plt.grid(True)
plt.legend()
plt.savefig('digital_twin_pwms.png')

plt.figure(figsize=(10,5))
plt.plot(df['t'], df['v_true'], label='True linear v (mm/s)')
plt.plot(df['t'], df['w_true'], label='True angular w (deg/s)')
plt.title('True Velocities Over Time (from calibration)')
plt.xlabel('Time (s)')
plt.ylabel('Value')
plt.grid(True)
plt.legend()
plt.savefig('digital_twin_velocities.png')

# Display small summary and save csv
df.to_csv('digital_twin_log.csv', index=False)
print("Saved: digital_twin_trajectory.png, digital_twin_pwms.png, digital_twin_velocities.png, digital_twin_log.csv")

# Show the plots inline (matplotlib figures will be rendered in the notebook)
plt.show()

# Also present the last few rows of the trajectory
# import caas_jupyter_tools as cjt
# cjt.display_dataframe_to_user("Digital Twin Log (tail)", df.tail(20))
