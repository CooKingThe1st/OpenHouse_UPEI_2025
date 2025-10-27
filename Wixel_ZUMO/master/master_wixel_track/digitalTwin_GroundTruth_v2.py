# digitalTwinSim_v2.py
"""
Digital Twin v2 - single robot APF -> motor -> calibrated physical model simulation.

Features:
- Simple attractive APF to a fixed goal.
- C-like apf2motor logic (approximation / integer-like behavior).
- Controller-side velocity->PWM mapping (with safe MAX_PWM cap).
- Calibration-based PWM -> true wheel linear speeds (from your RANSAC fits).
- Kinematic integration using the true motion (v_true, w_true).
- Stopping: success when within GOAL_THRESHOLD_MM (default 100 mm).
- Side-by-side plot: controller-expected linear velocity vs true calibrated linear velocity.
- Saves: digital_twin_v2_log.csv, digital_twin_v2_trajectory.png,
         digital_twin_v2_pwms.png, digital_twin_v2_velocities_compare.png
"""

import math
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# ------------------------ TUNING PARAMETERS (edit these) ------------------------
WHEELBASE_MM = 100.0           # track width between wheels
STEERING_GAIN = 2.0            # steering proportional gain used in apf2motor
APF_MAX_VELOCITY = 400.0       # mm/s, cap on APF desired forward speed
GOAL_THRESHOLD_MM = 20.0      # mm; success when within 10 cm (user request)
MAX_PWM = 120                  # software PWM ceiling (safety)
PWM_DEADZONE = 30              # PWM deadzone (approximate)
ZUMO_MAX_VELOCITY_PWM = 150.0  # mapping constant used by controller (for scaling)
ZUMO_MAX_VELOCITY_MMS = 700.0  # controller assumes this mm/s corresponds to ZUMO_MAX_VELOCITY_PWM
DT = 0.05                      # simulation timestep (s)
MAX_SIM_TIME = 60.0            # seconds
TARGET_X_MM = 0.0           # goal x (mm)
TARGET_Y_MM = 1000.0           # goal y (mm)

# ------------------------ Calibration parameters (from your RANSAC fits) ----------
# These map PWM -> measured motion when you commanded PWM directly
CAL = {
    'linear_fwd_slope': 2.4055,    # mm/s per PWM (forward)
    'linear_fwd_intercept': -77.2917,
    'linear_bwd_slope': -2.4496,   # negative slope for backward mapping (see usage below)
    'linear_bwd_intercept': -82.6115,
    'angular_cw_slope': -3.0424,   # deg/s per PWM (CW)
    'angular_cw_intercept': 156.9508,
    'angular_ccw_slope': 2.9553,
    'angular_ccw_intercept': -147.5931
}

# ------------------------ Utility functions -----------------------------------
def clamp(a, lo, hi):
    return max(lo, min(hi, a))

def normalize_angle_deg(a):
    """Normalize angle to [-180, 180)."""
    return ((a + 180) % 360) - 180

def isqrt_safe(n):
    return int(math.isqrt(max(0, int(n))))

# ------------------------ Controller mapping: velocity -> PWM ------------------
def velocity_to_pwm_controller(velocity_mms):
    """
    Controller's velocityToPWM mapping (integer-ish). Maps mm/s -> PWM.
    This mimics the integer scaling used in the firmware prototypes.
    """
    if int(velocity_mms) == 0:
        return 0
    intermediate = int(velocity_mms) * int(ZUMO_MAX_VELOCITY_PWM)
    pwm = intermediate // int(ZUMO_MAX_VELOCITY_MMS)
    # enforce software limit
    pwm = clamp(pwm, -MAX_PWM, MAX_PWM)
    # apply deadzone bump (firmware often bumps small non-zero to deadzone)
    if 0 < pwm < PWM_DEADZONE:
        pwm = PWM_DEADZONE
    if -PWM_DEADZONE < pwm < 0:
        pwm = -PWM_DEADZONE
    return int(pwm)

# For plotting / comparison: inverse of controller mapping (approx)
def pwm_to_velocity_controller_expected(pwm):
    """Given PWM, what the controller expects as wheel velocity (mm/s)."""
    # Avoid division by zero; simple linear inverse: v = pwm * (ZUMO_MAX_VELOCITY_MMS / ZUMO_MAX_VELOCITY_PWM)
    return pwm * (ZUMO_MAX_VELOCITY_MMS / ZUMO_MAX_VELOCITY_PWM)

# ------------------------ Calibration-based physical model: PWM -> true wheel v ---
def pwm_to_true_wheel_velocity(pwm):
    """
    Convert commanded PWM (signed) to the measured wheel linear speed (signed, mm/s),
    using the calibration fits. For positive PWM we'll use 'linear_fwd' fit;
    for negative PWM we'll use the backward fit.
    """
    if pwm == 0:
        return 0.0
    if pwm > 0:
        # forward fit: v = slope * pwm + intercept
        return CAL['linear_fwd_slope'] * pwm + CAL['linear_fwd_intercept']
    else:
        # negative pwm: treat magnitude and apply backward fit which had negative slope
        mag = -pwm
        return CAL['linear_bwd_slope'] * mag + CAL['linear_bwd_intercept']
        # Note: linear_bwd_slope is negative, producing a negative wheel velocity for negative pwm.

def pwm_pair_to_true_motion(pwm_l, pwm_r):
    """
    Given left/right PWM, return:
      - v_linear_true (mm/s)
      - w_angular_true (deg/s)
      - v_l_true, v_r_true (each wheel signed mm/s)
    """
    v_l = pwm_to_true_wheel_velocity(pwm_l)
    v_r = pwm_to_true_wheel_velocity(pwm_r)
    v_linear = 0.5 * (v_l + v_r)
    # angular velocity in rad/s = (v_r - v_l) / wheelbase (mm)  => deg/s via degrees()
    w_rad_s = (v_r - v_l) / WHEELBASE_MM
    w_deg_s = math.degrees(w_rad_s)
    return v_linear, w_deg_s, v_l, v_r

# ------------------------ APF attractive force (C-like) -------------------------
def compute_attractive_forces_go_to(cur_x, cur_y, target_x, target_y):
    """
    C-style attractive APF:
    - apfVel magnitude proportional to distance, capped at APF_MAX_VELOCITY
    - returns (apfVelX, apfVelY) in mm/s
    """
    dx = int(target_x - cur_x)
    dy = int(target_y - cur_y)
    dist_sq = dx*dx + dy*dy
    if dist_sq == 0:
        return 0.0, 0.0
    dist = isqrt_safe(dist_sq)
    if dist <= GOAL_THRESHOLD_MM:
        return 0.0, 0.0
    velMag = dist if dist <= APF_MAX_VELOCITY else APF_MAX_VELOCITY
    apf_vx = (dx * velMag) / dist if dist != 0 else 0.0
    apf_vy = (dy * velMag) / dist if dist != 0 else 0.0
    return float(apf_vx), float(apf_vy)

# heading approximation as in your updated C code (quadrant-based)
def heading_approximation_deg(apf_vx, apf_vy):
    if apf_vx == 0:
        return 90.0 if apf_vy > 0 else -90.0
    absX = abs(apf_vx)
    absY = abs(apf_vy)
    if absX > absY:
        # angle ≈ (y / x) * 45
        return (apf_vy * 45.0) / apf_vx
    else:
        if apf_vy > 0:
            return 90.0 - (apf_vx * 45.0) / apf_vy
        else:
            return -90.0 - (apf_vx * 45.0) / apf_vy

# apf2motor (C-style logic) -> returns (pwm_left, pwm_right, vel_left_cmd, vel_right_cmd)
def apf2motor_c_style(apf_vx, apf_vy, filtered_theta_deg):
    vel_sq = int(apf_vx*apf_vx + apf_vy*apf_vy)
    if vel_sq <= 0:
        return 0, 0, 0.0, 0.0
    if vel_sq > 2147483647:
        velMag = 46340
    else:
        velMag = isqrt_safe(vel_sq)
    heading_desired = heading_approximation_deg(apf_vx, apf_vy)
    steering_error = int(heading_desired) - int(filtered_theta_deg)
    steering_error = normalize_angle_deg(steering_error)
    steering_adjust = (steering_error * WHEELBASE_MM * STEERING_GAIN) / 200.0
    vel_left = velMag - steering_adjust
    vel_right = velMag + steering_adjust
    # clamp commanded wheel velocities (controller's assumed max)
    vel_left = clamp(vel_left, -ZUMO_MAX_VELOCITY_MMS, ZUMO_MAX_VELOCITY_MMS)
    vel_right = clamp(vel_right, -ZUMO_MAX_VELOCITY_MMS, ZUMO_MAX_VELOCITY_MMS)
    # convert to PWM (controller-side mapping)
    pwm_l = velocity_to_pwm_controller(vel_left)
    pwm_r = velocity_to_pwm_controller(vel_right)
    # ensure safety MAX_PWM
    pwm_l = int(clamp(pwm_l, -MAX_PWM, MAX_PWM))
    pwm_r = int(clamp(pwm_r, -MAX_PWM, MAX_PWM))
    return pwm_l, pwm_r, vel_left, vel_right

# ------------------------ Pose integration using true motion --------------------
def update_pose(x, y, theta_deg, v_mm_s, w_deg_s, dt):
    theta_rad = math.radians(theta_deg)
    x_new = x + v_mm_s * math.cos(theta_rad) * dt
    y_new = y + v_mm_s * math.sin(theta_rad) * dt
    theta_new = normalize_angle_deg(theta_deg + w_deg_s * dt)
    return x_new, y_new, theta_new

# ------------------------ Simulation loop -------------------------------------
def run_simulation(dt=DT, max_time=MAX_SIM_TIME, verbose=False):
    x, y, theta = 0.0, 0.0, 0.0  # initial pose (mm, mm, deg)
    target_x, target_y = TARGET_X_MM, TARGET_Y_MM
    t = 0.0
    logs = []
    while t < max_time:
        # 1) controller: APF -> desired velocities
        apf_vx, apf_vy = compute_attractive_forces_go_to(x, y, target_x, target_y)
        # 2) controller: apf -> pwm (C-like)
        pwm_l, pwm_r, vel_left_cmd, vel_right_cmd = apf2motor_c_style(apf_vx, apf_vy, theta)
        # 3) physical: pwm -> true motion
        v_true, w_true, v_l_true, v_r_true = pwm_pair_to_true_motion(pwm_l, pwm_r)
        # 4) integrate pose using calibrated true motion
        x, y, theta = update_pose(x, y, theta, v_true, w_true, dt)
        # 5) expected controller-predicted linear velocity (for comparison)
        v_expected_l = pwm_to_velocity_controller_expected(pwm_l)
        v_expected_r = pwm_to_velocity_controller_expected(pwm_r)
        v_expected_linear = 0.5 * (v_expected_l + v_expected_r)
        # 6) record
        logs.append({
            't': t,
            'x': x, 'y': y, 'theta': theta,
            'apf_vx': apf_vx, 'apf_vy': apf_vy,
            'pwm_l': pwm_l, 'pwm_r': pwm_r,
            'vel_left_cmd': vel_left_cmd, 'vel_right_cmd': vel_right_cmd,
            'v_l_true': v_l_true, 'v_r_true': v_r_true,
            'v_true': v_true, 'w_true': w_true,
            'v_expected_linear': v_expected_linear
        })
        # 7) stopping logic: must reach within GOAL_THRESHOLD_MM (10 cm)
        dist_to_goal = math.hypot(target_x - x, target_y - y)
        # If within threshold -> success (we accept landing in deadzone as success only if within threshold)
        if dist_to_goal <= GOAL_THRESHOLD_MM:
            if verbose:
                print(f"Goal reached at t={t:.2f}s dist={dist_to_goal:.1f}mm; pwms=({pwm_l},{pwm_r})")
            break
        # If not within threshold, continue even if PWMs are inside deadzone (prevents early stop)
        # (No additional special-case needed)
        if verbose and int(t/dt) % int(1.0/dt) == 0:
            print(f"t={t:.2f}s pos=({x:.1f},{y:.1f}) theta={theta:.1f} pwmL={pwm_l} pwmR={pwm_r} v_true={v_true:.1f}")
        t += dt
    df = pd.DataFrame(logs)
    return df, (target_x, target_y)

# ------------------------ Run & Plot ------------------------------------------
if __name__ == "__main__":
    print("Digital Twin v2 starting with parameters:")
    print(f"  GOAL_THRESHOLD_MM = {GOAL_THRESHOLD_MM} mm")
    print(f"  MAX_PWM = {MAX_PWM}, PWM_DEADZONE = {PWM_DEADZONE}")
    print(f"  APF_MAX_VELOCITY = {APF_MAX_VELOCITY} mm/s, STEERING_GAIN = {STEERING_GAIN}")
    print(f"  WHEELBASE_MM = {WHEELBASE_MM}")
    print("Running simulation... (verbose prints every 1s)")

    df, goal = run_simulation(dt=DT, max_time=MAX_SIM_TIME, verbose=True)
    # Save CSV
    df.to_csv('digital_twin_v2_log.csv', index=False)
    print("Saved log: digital_twin_v2_log.csv ({} rows)".format(len(df)))

    # Plot trajectory
    plt.figure(figsize=(7,7))
    plt.plot(df['x'], df['y'], label='Trajectory')
    plt.scatter([goal[0]], [goal[1]], marker='x', color='red', label='Goal')
    plt.title('Digital Twin v2 Trajectory (mm)')
    plt.xlabel('X (mm)')
    plt.ylabel('Y (mm)')
    plt.axis('equal')
    plt.grid(True)
    plt.legend()
    plt.savefig('digital_twin_v2_trajectory.png')
    print("Saved: digital_twin_v2_trajectory.png")

    # Plot PWM over time
    plt.figure(figsize=(10,4))
    plt.plot(df['t'], df['pwm_l'], label='PWM Left')
    plt.plot(df['t'], df['pwm_r'], label='PWM Right')
    plt.axhline(y=MAX_PWM, color='r', linestyle='--', label=f'MAX_PWM ({MAX_PWM})')
    plt.axhline(y=-MAX_PWM, color='r', linestyle='--')
    plt.title('PWM Outputs Over Time')
    plt.xlabel('Time (s)')
    plt.ylabel('PWM')
    plt.grid(True)
    plt.legend()
    plt.savefig('digital_twin_v2_pwms.png')
    print("Saved: digital_twin_v2_pwms.png")

    # Side-by-side compare: controller-expected linear velocity vs true linear velocity
    plt.figure(figsize=(10,4))
    plt.plot(df['t'], df['v_expected_linear'], label='Controller-expected linear v (mm/s)')
    plt.plot(df['t'], df['v_true'], label='True linear v (mm/s) from calibration')
    plt.title('Expected vs True Linear Velocity')
    plt.xlabel('Time (s)')
    plt.ylabel('Linear Velocity (mm/s)')
    plt.grid(True)
    plt.legend()
    plt.savefig('digital_twin_v2_velocities_compare.png')
    print("Saved: digital_twin_v2_velocities_compare.png")

    print("Done. Inspect the PNGs and the CSV for tuning insights.")
