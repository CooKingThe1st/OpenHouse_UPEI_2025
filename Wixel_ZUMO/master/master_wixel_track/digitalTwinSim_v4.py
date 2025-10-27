# digitalTwinSim_v4.py
"""
Digital Twin v4 – single robot APF→motor→calibrated physical model simulation
Now using calibrated inverse for velocity→PWM mapping.

Changes from v3:
- velocity_to_pwm_controller() replaced with calibration-based inverse.
- Controller and physical models now use the same slope/intercept pair.
- Keeps min-velocity floor logic and all other behavior identical.
"""

import math
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# ------------------------ TUNING PARAMETERS ------------------------
WHEELBASE_MM = 100.0
STEERING_GAIN = 4.0
APF_MAX_VELOCITY = 200.0       # mm/s cap
GOAL_THRESHOLD_MM = 80.0       # goal success radius
APPROACH_RADIUS_MM = 120.0     # distance where min-velocity floor starts
MIN_APPROACH_VELOCITY = 50.0   # mm/s floor near goal
MAX_PWM = 120
PWM_DEADZONE = 33
DT = 0.05
MAX_SIM_TIME = 60.0
TARGET_X_MM = -500.0
TARGET_Y_MM = -500.0

# ------------------------ Calibration Parameters -------------------
CAL = {
    'linear_fwd_slope': 2.4055,
    'linear_fwd_intercept': -77.2917,
    'linear_bwd_slope': -2.4496,
    'linear_bwd_intercept': -82.6115,
    'angular_cw_slope': -3.0424,
    'angular_cw_intercept': 156.9508,
    'angular_ccw_slope': 2.9553,
    'angular_ccw_intercept': -147.5931
}

# ------------------------ Utility Functions ------------------------
def clamp(a, lo, hi): return max(lo, min(hi, a))
def normalize_angle_deg(a): return ((a + 180) % 360) - 180
def isqrt_safe(n): return int(math.isqrt(max(0, int(n))))

# ------------------------ Calibrated velocity→PWM ------------------
def velocity_to_pwm_controller_calibrated(vel_mms):
    """
    Convert desired wheel velocity (mm/s) to PWM using the inverse of
    experimentally fitted calibration lines.
    """
    if abs(vel_mms) < 1e-3:
        return 0

    if vel_mms > 0:
        # --- FORWARD ---
        # v = m*p + c  =>  p = (v - c) / m
        pwm = (vel_mms - CAL['linear_fwd_intercept']) / CAL['linear_fwd_slope']
    
    else:
        # --- BACKWARD ---
        # v = m*mag + c  =>  mag = (v - c) / m
        # (where mag = -pwm)
        
        # This is the correct inverse formula
        mag = (vel_mms - CAL['linear_bwd_intercept']) / CAL['linear_bwd_slope']
        
        # If mag is negative, the requested velocity is in the deadband 
        # (e.g., asking for -50mm/s when min is -156mm/s).
        if mag < 0:
            pwm = 0
        else:
            pwm = -mag

    pwm = int(round(pwm))
    pwm = clamp(pwm, -MAX_PWM, MAX_PWM)

    # Apply deadzone bump
    if 0 < pwm < PWM_DEADZONE:
        pwm = PWM_DEADZONE
    if -PWM_DEADZONE < pwm < 0:
        pwm = -PWM_DEADZONE
        
    return pwm

def pwm_to_velocity_controller_expected(pwm):
    """
    What controller *expects* (based on the same calibration).
    """
    if pwm >= 0:
        return CAL['linear_fwd_slope'] * pwm + CAL['linear_fwd_intercept']
    else:
        mag = -pwm
        return CAL['linear_bwd_slope'] * mag + CAL['linear_bwd_intercept']

# ------------------------ Calibrated Physical Model ----------------
def pwm_to_true_wheel_velocity(pwm):
    if pwm == 0: return 0.0
    if pwm > 0:
        return CAL['linear_fwd_slope'] * pwm + CAL['linear_fwd_intercept']
    else:
        mag = -pwm
        return CAL['linear_bwd_slope'] * mag + CAL['linear_bwd_intercept']

def pwm_pair_to_true_motion(pwm_l, pwm_r):
    v_l = pwm_to_true_wheel_velocity(pwm_l)
    v_r = pwm_to_true_wheel_velocity(pwm_r)
    v_linear = 0.5 * (v_l + v_r)
    w_rad_s = (v_r - v_l) / WHEELBASE_MM
    w_deg_s = math.degrees(w_rad_s)
    return v_linear, w_deg_s, v_l, v_r

# ------------------------ Attractive Force (with floor) ------------
def compute_attractive_forces_go_to(cur_x, cur_y, target_x, target_y):
    dx = int(target_x - cur_x)
    dy = int(target_y - cur_y)
    dist_sq = dx*dx + dy*dy
    if dist_sq == 0:
        return 0.0, 0.0
    dist = isqrt_safe(dist_sq)
    if dist <= GOAL_THRESHOLD_MM:
        return 0.0, 0.0

    velMag = dist if dist <= APF_MAX_VELOCITY else APF_MAX_VELOCITY
    if dist < APPROACH_RADIUS_MM and velMag < MIN_APPROACH_VELOCITY:
        velMag = MIN_APPROACH_VELOCITY

    apf_vx = (dx * velMag) / dist
    apf_vy = (dy * velMag) / dist
    return float(apf_vx), float(apf_vy)

# ------------------------ apf2motor (C-style) -----------------------
def heading_approximation_deg(vx, vy):
    """
    Fixed quadrant-aware heading approximation
    Returns angle in degrees [-180, 180]
    """
    if vx == 0:
        return 90.0 if vy > 0 else -90.0
    
    absX, absY = abs(vx), abs(vy)
    
    # Compute angle in first quadrant [0, 90]
    if absX > absY:
        angle = (absY * 45.0) / absX  # 0 to 45 deg
    else:
        angle = 90.0 - (absX * 45.0) / absY  # 45 to 90 deg
    
    # Map to correct quadrant based on signs
    if vx >= 0 and vy >= 0:
        return angle           # Q1: [0, 90]
    elif vx < 0 and vy >= 0:
        return 180.0 - angle   # Q2: [90, 180]
    elif vx < 0 and vy < 0:
        return -180.0 + angle  # Q3: [-180, -90]
    else:  # vx >= 0 and vy < 0
        return -angle          # Q4: [-90, 0]

def apf2motor_c_style(apf_vx, apf_vy, theta_deg):
    vel_sq = int(apf_vx*apf_vx + apf_vy*apf_vy)
    if vel_sq <= 0: return 0, 0, 0.0, 0.0
    velMag = 46340 if vel_sq > 2147483647 else isqrt_safe(vel_sq)
    heading_desired = heading_approximation_deg(apf_vx, apf_vy)
    steer_err = normalize_angle_deg(int(heading_desired) - int(theta_deg))
    steer_adj = (steer_err * WHEELBASE_MM * STEERING_GAIN) / 200.0
    vel_l = clamp(velMag - steer_adj, -1000.0, 1000.0)
    vel_r = clamp(velMag + steer_adj, -1000.0, 1000.0)
    pwm_l = velocity_to_pwm_controller_calibrated(vel_l)
    pwm_r = velocity_to_pwm_controller_calibrated(vel_r)
    return int(pwm_l), int(pwm_r), vel_l, vel_r

# ------------------------ Pose Integration -------------------------
def update_pose(x, y, theta_deg, v_mm_s, w_deg_s, dt):
    theta_rad = math.radians(theta_deg)
    x += v_mm_s * math.cos(theta_rad) * dt
    y += v_mm_s * math.sin(theta_rad) * dt
    theta_deg = normalize_angle_deg(theta_deg + w_deg_s * dt)
    return x, y, theta_deg

# ------------------------ Simulation Loop --------------------------
def run_sim(dt=DT, max_time=MAX_SIM_TIME, verbose=False):
    x, y, theta = 0.0, 0.0, 0.0
    goal = (TARGET_X_MM, TARGET_Y_MM)
    t = 0.0
    logs = []

    while t < max_time:
        apf_vx, apf_vy = compute_attractive_forces_go_to(x, y, *goal)
        pwm_l, pwm_r, v_cmd_l, v_cmd_r = apf2motor_c_style(apf_vx, apf_vy, theta)
        v_true, w_true, v_l_true, v_r_true = pwm_pair_to_true_motion(pwm_l, pwm_r)
        x, y, theta = update_pose(x, y, theta, v_true, w_true, dt)

        v_exp = 0.5 * (
            pwm_to_velocity_controller_expected(pwm_l) +
            pwm_to_velocity_controller_expected(pwm_r)
        )

        logs.append({
            't': t, 'x': x, 'y': y, 'theta': theta,
            'pwm_l': pwm_l, 'pwm_r': pwm_r,
            'v_true': v_true, 'v_exp': v_exp,
            'apf_vx': apf_vx, 'apf_vy': apf_vy
        })

        dist = math.hypot(goal[0] - x, goal[1] - y)
        if dist <= GOAL_THRESHOLD_MM:
            if verbose:
                print(f"Goal reached at t={t:.2f}s, dist={dist:.1f}mm, PWM=({pwm_l},{pwm_r})")
            break

        if verbose and int(t/dt) % int(1.0/dt) == 0:
            print(f"t={t:.2f}s pos=({x:.1f},{y:.1f}) d={dist:.1f} pwmL={pwm_l} pwmR={pwm_r}")

        t += dt

    return pd.DataFrame(logs), goal

# ------------------------ Run + Plot ------------------------------------------
if __name__ == "__main__":
    print("Running Digital Twin v4 (calibrated inverse)...")
    df, goal = run_sim(verbose=True)
    df.to_csv('digital_twin_v4_log.csv', index=False)

    # Trajectory
    plt.figure(figsize=(7,7))
    plt.plot(df['x'], df['y'], label='Trajectory')
    plt.scatter([goal[0]], [goal[1]], color='red', marker='x', label='Goal')
    plt.title('Trajectory – Calibrated Inverse Mapping')
    plt.xlabel('X (mm)'); plt.ylabel('Y (mm)')
    plt.axis('equal'); plt.legend(); plt.grid(True)
    plt.savefig('digital_twin_v4_trajectory.png')

    # PWM over time
    plt.figure(figsize=(10,4))
    plt.plot(df['t'], df['pwm_l'], label='PWM Left')
    plt.plot(df['t'], df['pwm_r'], label='PWM Right')
    plt.axhline(y=MAX_PWM, color='r', ls='--', lw=1)
    plt.axhline(y=-MAX_PWM, color='r', ls='--', lw=1)
    plt.title('PWM vs Time'); plt.xlabel('Time (s)'); plt.ylabel('PWM')
    plt.legend(); plt.grid(True)
    plt.savefig('digital_twin_v4_pwms.png')

    # Expected vs True velocity
    plt.figure(figsize=(10,4))
    plt.plot(df['t'], df['v_exp'], label='Expected velocity (controller)')
    plt.plot(df['t'], df['v_true'], label='True velocity (calibration)')
    plt.title('Expected vs True Linear Velocity – Calibrated Inverse')
    plt.xlabel('Time (s)'); plt.ylabel('Velocity (mm/s)')
    plt.legend(); plt.grid(True)
    plt.savefig('digital_twin_v4_velocity_compare.png')

    print("✓ Saved: digital_twin_v4_log.csv + PNG plots.")
