# rotation_test.py
"""
Pure Rotation Test - Simple P-controller to rotate robot toward goal heading

Goal: Robot rotates in place until facing target position, then stops.
No forward motion, just rotation.
"""

import math
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# ------------------------ TUNING PARAMETERS ------------------------
WHEELBASE_MM = 100.0           # track width between wheels
MAX_PWM = 120                  # software PWM cap
PWM_DEADZONE = 30              # PWM deadzone

# Rotation P-controller parameters
ROTATION_KP = 1.5              # Proportional gain for rotation
MAX_ROTATION_PWM = 80          # Max PWM for rotation (moderate speed)
MIN_ROTATION_PWM = 40          # Min PWM to overcome friction
HEADING_THRESHOLD = 5.0        # degrees - stop when within this

DT = 0.05                      # simulation timestep (s)
MAX_SIM_TIME = 30.0

# Test targets
TARGET_X_MM = -300.0
TARGET_Y_MM = -300.0

# ------------------------ Calibration Parameters -------------------
CAL = {
    'angular_cw_slope': -3.0424,
    'angular_cw_intercept': 156.9508,
    'angular_ccw_slope': 2.9553,
    'angular_ccw_intercept': -147.5931
}

# ------------------------ Utility Functions ------------------------
def clamp(a, lo, hi): return max(lo, min(hi, a))
def normalize_angle_deg(a): return ((a + 180) % 360) - 180

# ------------------------ PWM to Angular Velocity ------------------
def pwm_to_angular_velocity(pwm_left, pwm_right):
    """
    Calculate angular velocity from differential PWM
    Using calibrated angular model
    """
    if pwm_left == 0 and pwm_right == 0:
        return 0.0
    
    # Pure rotation: left = -pwm, right = +pwm (or vice versa)
    if pwm_left < 0 and pwm_right > 0:
        # Counter-clockwise rotation
        avg_pwm = (abs(pwm_left) + abs(pwm_right)) / 2.0
        w_deg_s = CAL['angular_ccw_slope'] * avg_pwm + CAL['angular_ccw_intercept']
        return w_deg_s
    elif pwm_left > 0 and pwm_right < 0:
        # Clockwise rotation
        avg_pwm = (abs(pwm_left) + abs(pwm_right)) / 2.0
        w_deg_s = CAL['angular_cw_slope'] * avg_pwm + CAL['angular_cw_intercept']
        return w_deg_s
    else:
        # Not pure rotation, fallback to simple differential
        # (This shouldn't happen in pure rotation test)
        return 0.0

# ------------------------ Rotation P-Controller --------------------
def rotation_controller(current_heading, target_heading):
    """
    Simple P-controller for rotation
    Returns: pwm_left, pwm_right
    """
    # Calculate heading error
    error = normalize_angle_deg(target_heading - current_heading)
    
    # Within threshold → stop
    if abs(error) < HEADING_THRESHOLD:
        return 0, 0
    
    # P-controller: PWM proportional to error
    pwm = error * ROTATION_KP
    
    # Clamp to limits
    pwm = clamp(pwm, -MAX_ROTATION_PWM, MAX_ROTATION_PWM)
    
    # Apply minimum PWM to overcome friction
    if 0 < pwm < MIN_ROTATION_PWM:
        pwm = MIN_ROTATION_PWM
    elif -MIN_ROTATION_PWM < pwm < 0:
        pwm = -MIN_ROTATION_PWM
    
    # Convert to differential drive
    if pwm > 0:
        # Turn counter-clockwise (left)
        pwm_left = -int(pwm)
        pwm_right = int(pwm)
    else:
        # Turn clockwise (right)
        pwm_left = int(-pwm)
        pwm_right = int(pwm)
    
    return pwm_left, pwm_right

# ------------------------ Calculate Target Heading -----------------
def calculate_target_heading(x, y, target_x, target_y):
    """Calculate heading angle from current position to target"""
    dx = target_x - x
    dy = target_y - y
    return math.degrees(math.atan2(dy, dx))

# ------------------------ Simulation Loop --------------------------
def run_rotation_test(start_heading=0.0, verbose=True):
    """
    Test: Robot starts at origin with given heading, rotates to face target
    """
    x, y = 0.0, 0.0
    theta = start_heading
    goal = (TARGET_X_MM, TARGET_Y_MM)
    
    # Calculate target heading (fixed, doesn't change since position fixed)
    target_heading = calculate_target_heading(x, y, *goal)
    
    t = 0.0
    logs = []
    
    if verbose:
        print(f"Starting rotation test:")
        print(f"  Start heading: {theta:.1f}°")
        print(f"  Target heading: {target_heading:.1f}°")
        print(f"  Initial error: {normalize_angle_deg(target_heading - theta):.1f}°")
        print()
    
    while t < MAX_SIM_TIME:
        # Run rotation controller
        pwm_l, pwm_r = rotation_controller(theta, target_heading)
        
        # Calculate angular velocity from PWM (using calibrated model)
        w_deg_s = pwm_to_angular_velocity(pwm_l, pwm_r)
        
        # Update heading
        theta = normalize_angle_deg(theta + w_deg_s * DT)
        
        # Calculate error
        error = normalize_angle_deg(target_heading - theta)
        
        logs.append({
            't': t,
            'theta': theta,
            'target_heading': target_heading,
            'error': error,
            'pwm_l': pwm_l,
            'pwm_r': pwm_r,
            'w_deg_s': w_deg_s
        })
        
        # Check if aligned
        if abs(error) < HEADING_THRESHOLD:
            if verbose:
                print(f"✓ Aligned at t={t:.2f}s")
                print(f"  Final heading: {theta:.1f}°")
                print(f"  Final error: {error:.2f}°")
            break
        
        if verbose and int(t/DT) % int(1.0/DT) == 0:
            print(f"t={t:.2f}s θ={theta:.1f}° error={error:.1f}° pwm=({pwm_l},{pwm_r}) ω={w_deg_s:.1f}°/s")
        
        t += DT
    
    return pd.DataFrame(logs), target_heading

# ------------------------ Run Tests --------------------------------
if __name__ == "__main__":
    print("="*60)
    print("ROTATION TEST - P-Controller")
    print("="*60)
    
    # Test multiple starting headings
    test_cases = [
        ("Aligned (0°)", 0.0),
        ("Right side (90°)", 90.0),
        ("Opposite (-180°)", -180.0),
        ("Left side (-90°)", -90.0),
        ("Slight offset (30°)", 30.0),
    ]
    
    all_results = []
    
    for name, start_heading in test_cases:
        print(f"\n{'='*60}")
        print(f"Test: {name}")
        print(f"{'='*60}")
        df, target = run_rotation_test(start_heading=start_heading, verbose=True)
        df['test_name'] = name
        all_results.append(df)
    
    # Combine all results
    df_all = pd.concat(all_results, ignore_index=True)
    df_all.to_csv('rotation_test_results.csv', index=False)
    
    # Plot results
    fig, axes = plt.subplots(2, 2, figsize=(14, 10))
    
    # Plot each test case
    for name, start_heading in test_cases:
        df_case = df_all[df_all['test_name'] == name]
        
        # Heading vs time
        axes[0, 0].plot(df_case['t'], df_case['theta'], label=name, linewidth=2)
        
        # Error vs time
        axes[0, 1].plot(df_case['t'], df_case['error'], label=name, linewidth=2)
        
        # PWM vs time
        axes[1, 0].plot(df_case['t'], df_case['pwm_l'], label=f'{name} (L)', alpha=0.7)
        axes[1, 0].plot(df_case['t'], df_case['pwm_r'], label=f'{name} (R)', alpha=0.7, linestyle='--')
        
        # Angular velocity vs time
        axes[1, 1].plot(df_case['t'], df_case['w_deg_s'], label=name, linewidth=2)
    
    # Format plots
    axes[0, 0].set_title('Heading vs Time')
    axes[0, 0].set_xlabel('Time (s)')
    axes[0, 0].set_ylabel('Heading (deg)')
    axes[0, 0].axhline(y=df_all['target_heading'].iloc[0], color='r', ls='--', label='Target')
    axes[0, 0].legend(fontsize=8)
    axes[0, 0].grid(True)
    
    axes[0, 1].set_title('Heading Error vs Time')
    axes[0, 1].set_xlabel('Time (s)')
    axes[0, 1].set_ylabel('Error (deg)')
    axes[0, 1].axhline(y=HEADING_THRESHOLD, color='r', ls='--', alpha=0.5)
    axes[0, 1].axhline(y=-HEADING_THRESHOLD, color='r', ls='--', alpha=0.5)
    axes[0, 1].legend(fontsize=8)
    axes[0, 1].grid(True)
    
    axes[1, 0].set_title('PWM Commands vs Time')
    axes[1, 0].set_xlabel('Time (s)')
    axes[1, 0].set_ylabel('PWM')
    axes[1, 0].axhline(y=MAX_ROTATION_PWM, color='r', ls='--', alpha=0.3)
    axes[1, 0].axhline(y=-MAX_ROTATION_PWM, color='r', ls='--', alpha=0.3)
    axes[1, 0].legend(fontsize=6, ncol=2)
    axes[1, 0].grid(True)
    
    axes[1, 1].set_title('Angular Velocity vs Time')
    axes[1, 1].set_xlabel('Time (s)')
    axes[1, 1].set_ylabel('ω (deg/s)')
    axes[1, 1].legend(fontsize=8)
    axes[1, 1].grid(True)
    
    plt.tight_layout()
    plt.savefig('rotation_test_analysis.png', dpi=150)
    
    print(f"\n{'='*60}")
    print("✓ All tests complete! Results saved.")
    print(f"{'='*60}")