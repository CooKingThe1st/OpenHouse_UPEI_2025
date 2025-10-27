# digitalTwinSim_v3.py
"""
Digital Twin v3 - single robot APF -> motor -> calibrated physical model simulation
with MINIMUM APPROACH VELOCITY floor (to overcome deadzone near goal).

Features:
- Simple attractive APF to fixed goal.
- Adds MIN_APPROACH_VELOCITY active floor between APPROACH_RADIUS and GOAL_THRESHOLD_MM.
- Same calibration & controller logic as v2.
- Software PWM cap (MAX_PWM = 120).
- Goal success radius = 100 mm (default).
- Side-by-side velocity comparison plot.
"""

import math
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# ------------------------ TUNING PARAMETERS ------------------------
WHEELBASE_MM = 100.0           # track width between wheels
STEERING_GAIN = 4.0            # steering proportional gain
APF_MAX_VELOCITY = 400.0       # mm/s, cap on APF desired forward speed
GOAL_THRESHOLD_MM = 50.0      # goal success radius (mm)
APPROACH_RADIUS_MM = 120.0     # distance where min-velocity floor starts

MIN_APPROACH_VELOCITY = 70.0   # mm/s, gentle push near goal (≈ PWM 50)
MAX_PWM = 120                  # software PWM cap
PWM_DEADZONE = 30              # PWM deadzone
ZUMO_MAX_VELOCITY_PWM = 150.0  # controller mapping reference
ZUMO_MAX_VELOCITY_MMS = 700.0
DT = 0.05                      # simulation timestep (s)
MAX_SIM_TIME = 60.0
TARGET_X_MM = -300.0
TARGET_Y_MM = -300.0

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

# ------------------------ Controller Mapping -----------------------
def velocity_to_pwm_controller(v_mms):
    if int(v_mms) == 0:
        return 0
    intermediate = int(v_mms) * int(ZUMO_MAX_VELOCITY_PWM)
    pwm = intermediate // int(ZUMO_MAX_VELOCITY_MMS)
    pwm = clamp(pwm, -MAX_PWM, MAX_PWM)
    if 0 < pwm < PWM_DEADZONE: pwm = PWM_DEADZONE
    if -PWM_DEADZONE < pwm < 0: pwm = -PWM_DEADZONE
    return int(pwm)

def pwm_to_velocity_controller_expected(pwm):
    return pwm * (ZUMO_MAX_VELOCITY_MMS / ZUMO_MAX_VELOCITY_PWM)

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

    # Within success zone → stop
    if dist <= GOAL_THRESHOLD_MM:
        return 0.0, 0.0

    # Normal APF proportional magnitude
    velMag = dist if dist <= APF_MAX_VELOCITY else APF_MAX_VELOCITY

    # Apply minimum velocity floor if inside approach zone
    if dist < APPROACH_RADIUS_MM and velMag < MIN_APPROACH_VELOCITY:
        velMag = MIN_APPROACH_VELOCITY

    apf_vx = (dx * velMag) / dist
    apf_vy = (dy * velMag) / dist
    return float(apf_vx), float(apf_vy)

# ------------------------ apf2motor (C-style) -----------------------
# ------------------------ FIXED HEADING APPROXIMATION ---------------
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
    vel_l = clamp(velMag - steer_adj, -ZUMO_MAX_VELOCITY_MMS, ZUMO_MAX_VELOCITY_MMS)
    vel_r = clamp(velMag + steer_adj, -ZUMO_MAX_VELOCITY_MMS, ZUMO_MAX_VELOCITY_MMS)
    pwm_l = clamp(velocity_to_pwm_controller(vel_l), -MAX_PWM, MAX_PWM)
    pwm_r = clamp(velocity_to_pwm_controller(vel_r), -MAX_PWM, MAX_PWM)
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

        v_exp_l = pwm_to_velocity_controller_expected(pwm_l)
        v_exp_r = pwm_to_velocity_controller_expected(pwm_r)
        v_exp = 0.5 * (v_exp_l + v_exp_r)

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
    print("Running Digital Twin v3 (with min-velocity floor)...")
    df, goal = run_sim(verbose=True)
    df.to_csv('digital_twin_v3_log.csv', index=False)

    # Trajectory
    plt.figure(figsize=(7,7))
    plt.plot(df['x'], df['y'], label='Trajectory')
    plt.scatter([goal[0]], [goal[1]], color='red', marker='x', label='Goal')
    plt.title('Trajectory with Minimum Velocity Floor')
    plt.xlabel('X (mm)')
    plt.ylabel('Y (mm)')
    plt.axis('equal')
    plt.legend(); plt.grid(True)
    plt.savefig('digital_twin_v3_trajectory.png')

    # PWM plot
    plt.figure(figsize=(10,4))
    plt.plot(df['t'], df['pwm_l'], label='PWM Left')
    plt.plot(df['t'], df['pwm_r'], label='PWM Right')
    plt.axhline(y=MAX_PWM, color='r', ls='--', lw=1)
    plt.axhline(y=-MAX_PWM, color='r', ls='--', lw=1)
    plt.title('PWM vs Time'); plt.xlabel('Time (s)'); plt.ylabel('PWM')
    plt.legend(); plt.grid(True)
    plt.savefig('digital_twin_v3_pwms.png')

    # Expected vs True velocity
    plt.figure(figsize=(10,4))
    plt.plot(df['t'], df['v_exp'], label='Controller-expected linear v')
    plt.plot(df['t'], df['v_true'], label='True linear v (calibrated)')
    plt.title('Expected vs True Linear Velocity')
    plt.xlabel('Time (s)'); plt.ylabel('Velocity (mm/s)')
    plt.legend(); plt.grid(True)
    plt.savefig('digital_twin_v3_velocity_compare.png')

    print("✓ Logs + plots saved: trajectory, PWM, velocity comparison.")
