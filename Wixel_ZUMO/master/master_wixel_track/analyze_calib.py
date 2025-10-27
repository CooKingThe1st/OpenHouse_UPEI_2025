import pandas as pd
import numpy as np
import glob
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression, RANSACRegressor
import sys

# --- Configuration ---
# List of all calibration files to process
# We list them explicitly since the names are varied
CALIBRATION_FILES = [
    "calibration_log_outlier_5.csv",
    "calibration_log_outlier_4.csv",
    "calibration_log_advance_outlier_3.csv",
    "calibration_log_ADVANCE_still_has_outlier_2.csv",
    "calibration_log_ADVANCE_buthas_outlier.csv"
]

# PWM value at or below which data is considered part of the "deadzone"
DEADZONE_PWM = 40

# The four test types we need to analyze
TEST_TYPES = ['linear_fwd', 'linear_bwd', 'angular_cw', 'angular_ccw']

# Dictionary to store final model parameters
final_models = {}

print(f"Starting analysis on {len(CALIBRATION_FILES)} files...")

# --- Step 1: Load and Combine All CSV Files ---
all_dfs = []
for file in CALIBRATION_FILES:
    try:
        df = pd.read_csv(file)
        # Clean up any whitespace in column names
        df.columns = df.columns.str.strip()
        # Add a column to know which file the data came from
        df['source_file'] = file
        all_dfs.append(df)
        print(f"✓ Loaded {file} ({len(df)} rows)")
    except FileNotFoundError:
        print(f"✗ WARNING: File not found: {file}. Skipping.")
    except Exception as e:
        print(f"✗ ERROR loading {file}: {e}. Skipping.")

if not all_dfs:
    print("CRITICAL ERROR: No data files were successfully loaded. Exiting.")
    sys.exit()

# Combine all data into one large DataFrame
combined_df = pd.concat(all_dfs, ignore_index=True)

# Ensure numeric types are correct, coercing errors to NaN
key_numeric_cols = ['pwm_left', 'pwm_right', 'vel_linear_mm_s', 'vel_angular_deg_s']
cols_to_convert = [col for col in key_numeric_cols if col in combined_df.columns]

for col in cols_to_convert:
    combined_df[col] = pd.to_numeric(combined_df[col], errors='coerce')
        
print(f"\nTotal combined rows: {len(combined_df)}")

# --- Step 2: Setup Plotting ---
fig, axes = plt.subplots(2, 2, figsize=(16, 12))
axes = axes.flatten() # Flatten the 2x2 grid into a 1D array
fig.suptitle('Robot Calibration: PWM vs. Velocity (RANSAC Fit)', fontsize=18)

# --- Step 3: Analyze Each Test Type ---
for i, test_type in enumerate(TEST_TYPES):
    ax = axes[i]
    print("\n" + "="*50)
    print(f"--- Analyzing: {test_type} ---")
    print("="*50)
    
    # 1. Select the correct data for this test
    data = combined_df[combined_df['test_type'] == test_type].copy()
    
    if data.empty:
        print(f"No data found for {test_type}. Skipping.")
        ax.set_title(f"{test_type} (No Data)")
        continue

    # 2. Determine which columns to use for X (PWM) and y (Velocity)
    if test_type in ['linear_fwd', 'linear_bwd', 'angular_cw']:
        X_col = 'pwm_left'
    else: # angular_ccw
        X_col = 'pwm_right'
        
    if test_type in ['linear_fwd', 'linear_bwd']:
        y_col = 'vel_linear_mm_s'
    else: # angular_cw, angular_ccw
        y_col = 'vel_angular_deg_s'
    
    if X_col not in data.columns or y_col not in data.columns:
        print(f"Error: Missing required columns '{X_col}' or '{y_col}'. Skipping.")
        continue
        
    # 3. Drop rows where *these specific columns* have NaN values
    data.dropna(subset=[X_col, y_col], inplace=True)
    if data.empty:
        print(f"No valid data after dropping NaNs. Skipping.")
        continue

    # 4. Filter out the deadzone
    data_to_fit = data[data[X_col].abs() > DEADZONE_PWM].copy()
    data_deadzone = data[data[X_col].abs() <= DEADZONE_PWM].copy()
    
    print(f"Total valid data points: {len(data)}")
    print(f"Deadzone points (PWM <= {DEADZONE_PWM}): {len(data_deadzone)}")
    print(f"Data points to fit: {len(data_to_fit)}")

    if data_to_fit.empty:
        print("No data left after filtering deadzone. Cannot fit model.")
        ax.scatter(data_deadzone[X_col], data_deadzone[y_col], color='gray', marker='s', label=f'Deadzone (PWM <= {DEADZONE_PWM})')
        ax.set_title(f"{test_type} (Only Deadzone Data)")
        ax.legend()
        ax.grid(True)
        continue
        
    # 5. Prepare data for scikit-learn
    X = data_to_fit[X_col].values.reshape(-1, 1)
    y = data_to_fit[y_col].values

    # 6. Fit RANSAC Regressor
    ransac = RANSACRegressor(
        estimator=LinearRegression(), # Use a standard linear model
        min_samples=2,                # Minimum 2 points to define a line
        max_trials=100,               # Number of RANSAC iterations
        residual_threshold=None,      # Auto-estimate threshold using MAD
        random_state=42
    )
    
    ransac.fit(X, y)
    
    inlier_mask = ransac.inlier_mask_
    outlier_mask = ~inlier_mask

    # 7. Get the final fitted model and parameters
    model = ransac.estimator_
    slope = model.coef_[0]
    intercept = model.intercept_
    
    final_models[test_type] = {'slope': slope, 'intercept': intercept}
    
    print(f"\n--- RANSAC Results for {test_type} ---")
    print(f"Inliers: {np.sum(inlier_mask)} | Outliers: {np.sum(outlier_mask)}")
    print(f"Fitted Model: y = {slope:.4f} * x + {intercept:.4f}")

    # 8. Plot the results
    
    # Plot Inliers (data RANSAC used)
    ax.scatter(X[inlier_mask], y[inlier_mask],
               color='blue', marker='o', label='Inliers')
    
    # Plot Outliers (data RANSAC ignored)
    ax.scatter(X[outlier_mask], y[outlier_mask],
               color='red', marker='x', label='Outliers (ignored)')
    
    # Plot Deadzone (data we excluded)
    ax.scatter(data_deadzone[X_col], data_deadzone[y_col],
               color='gray', marker='s', label=f'Deadzone (PWM <= {DEADZONE_PWM})')
    
    # Plot the fitted line
    X_all = data[X_col].values
    X_min, X_max = np.min(X_all), np.max(X_all)
    if X_max < X_min: X_min, X_max = X_max, X_min
    if X_min > 0: X_min = 0
    if X_max < 0: X_max = 0
        
    line_X = np.linspace(X_min, X_max, 100).reshape(-1, 1)
    line_y = model.predict(line_X)
    
    ax.plot(line_X, line_y, color='green', linestyle='--', linewidth=2,
            label=f'Fit: y = {slope:.3f}x + {intercept:.3f}')
    
    ax.set_title(f'Analysis for: {test_type}', fontsize=12)
    ax.set_xlabel(f'Input PWM ({X_col})', fontsize=10)
    ax.set_ylabel(f'Measured Velocity ({y_col})', fontsize=10)
    ax.legend()
    ax.grid(True, which='both', linestyle='--', alpha=0.7)

# --- Step 4: Finalize and Save ---
plt.tight_layout(rect=[0, 0.03, 1, 0.96])
plt.savefig('calibration_analysis.png', dpi=150)

print("\n" + "="*60)
print("✓✓✓ CALIBRATION ANALYSIS COMPLETE ✓✓✓")
print("="*60)
print("Final Fitted Model Parameters (Features):")
print("-----------------------------------------")
for test_type, params in final_models.items():
    print(f"  {test_type:12}: slope = {params['slope']:>10.4f} | intercept = {params['intercept']:>10.4f}")
print("-----------------------------------------")
print(f"\nAnalysis plot saved to: calibration_analysis.png")