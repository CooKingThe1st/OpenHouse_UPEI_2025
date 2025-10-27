"""
Debug script to analyze curvature and waypoint selection.
"""

from path_optimizer import PathInterpolator, WaypointOptimizer, CoordinateConverter
import numpy as np
import math

# Create components
converter = CoordinateConverter(800, 800, 2000.0, 2000.0)
optimizer = WaypointOptimizer(min_distance_mm=100.0, max_waypoints=20)

# Create a straight line with jitter
straight_path = [(100, 100)]
for i in range(1, 50):
    t = i / 49
    x = 100 + 600 * t
    y = 100 + 600 * t + 15 * math.sin(i * 0.5)
    straight_path.append((x, y))
straight_path.append((700, 700))

print("="*70)
print("CURVATURE ANALYSIS DEBUG")
print("="*70)

# Test with smoothing
interpolator = PathInterpolator(smoothness=200.0)
interpolated = interpolator.interpolate_path(straight_path, num_samples=500)
real_path = converter.path_canvas_to_real(interpolated)

print(f"\nPath length: {len(real_path)} points")

# Calculate curvature
curvatures = optimizer._calculate_curvature(real_path)
print(f"Curvature values calculated: {len(curvatures)}")

# Normalize
if len(curvatures) > 0 and max(curvatures) > 0:
    max_curv = max(curvatures)
    normalized_curv = curvatures / max_curv
    
    print(f"\nCurvature statistics:")
    print(f"  Min: {min(curvatures):.6f}")
    print(f"  Max: {max(curvatures):.6f}")
    print(f"  Mean: {np.mean(curvatures):.6f}")
    print(f"  Median: {np.median(curvatures):.6f}")
    print(f"  90th percentile: {np.percentile(curvatures, 90):.6f}")
    
    # Apply threshold
    threshold = 0.2
    thresholded = np.where(normalized_curv < threshold, 0, normalized_curv)
    num_above_threshold = np.sum(thresholded > 0)
    
    print(f"\nAfter 20% threshold:")
    print(f"  Points above threshold: {num_above_threshold} / {len(thresholded)}")
    print(f"  Percentage: {100*num_above_threshold/len(thresholded):.1f}%")
    
    # Show sample of curvature values along path
    print(f"\nSample curvature values (every 50th point):")
    for i in range(0, len(curvatures), 50):
        normalized = normalized_curv[i]
        after_thresh = thresholded[i]
        print(f"  Point {i:3d}: raw={curvatures[i]:.6f}, norm={normalized:.3f}, thresh={after_thresh:.3f}")

# Manually trace waypoint selection
print("\n" + "="*70)
print("WAYPOINT SELECTION TRACE")
print("="*70)

waypoints_manual = [real_path[0]]
last_wp = real_path[0]

# Recalculate with threshold
curvatures_norm = curvatures / max(curvatures) if max(curvatures) > 0 else curvatures
curvatures_thresh = np.where(curvatures_norm < 0.2, 0, curvatures_norm)

selected_indices = [0]
rejected_count = {'distance': 0, 'threshold': 0}

for i in range(1, len(real_path) - 1):
    point = real_path[i]
    distance = math.sqrt((point[0] - last_wp[0])**2 + (point[1] - last_wp[1])**2)
    
    if distance < optimizer.min_distance_mm:
        rejected_count['distance'] += 1
        continue
    
    curvature = curvatures_thresh[i] if i < len(curvatures_thresh) else 0
    
    if curvature < 0.1:
        threshold_dist = optimizer.min_distance_mm * 3.0
    else:
        threshold_dist = optimizer.min_distance_mm * (1.5 - curvature)
    
    if distance >= threshold_dist and len(waypoints_manual) < 19:
        selected_indices.append(i)
        waypoints_manual.append(point)
        last_wp = point
    else:
        rejected_count['threshold'] += 1

selected_indices.append(len(real_path) - 1)
waypoints_manual.append(real_path[-1])

print(f"Selected {len(waypoints_manual)} waypoints")
print(f"Rejected: {rejected_count['distance']} too close, {rejected_count['threshold']} below threshold")
print(f"\nSelected indices: {selected_indices[:10]}...")

print("\n" + "="*70)
print("CONCLUSION")
print("="*70)
print(f"For a nearly-straight smoothed path:")
print(f"  • Even with smoothing, small curvature variations exist")
print(f"  • Need more aggressive thresholding or higher min_distance")
print("="*70)
