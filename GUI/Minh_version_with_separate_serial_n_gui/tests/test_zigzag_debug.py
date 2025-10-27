"""
Debug script to understand angle calculations.
"""

from path_validator import PathValidator
from mission_config import RobotConfig, RobotColor
import math

# Create validator
validator = PathValidator(tolerance_pixels=30.0)

# Create test robot
test_robot = RobotConfig(
    color=RobotColor.RED,
    start_pos=(100, 100),
    end_pos=(700, 700),
    display_name="Red Robot",
    hex_color="#FF0000"
)

print("=== Debugging Angle Calculations ===\n")

# Test with simple smooth path
print("Test: Simple smooth diagonal path")
smooth_path = [(100, 100), (200, 200), (300, 300), (400, 400), (500, 500), (600, 600), (700, 700)]

# Sample the path like the validator does
sampled = validator._sample_path_for_validation(smooth_path, 30.0)
print(f"Original points: {len(smooth_path)}")
print(f"Sampled points: {len(sampled)}")
print(f"Sampled path: {sampled}\n")

# Calculate angles
print("Angles at each point:")
for i in range(len(sampled) - 2):
    angle = validator._calculate_angle(sampled[i], sampled[i + 1], sampled[i + 2])
    print(f"  Point {i+1}: angle = {angle:.1f}°")

print("\n" + "="*50 + "\n")

# Test with actual zigzag
print("Test: Extreme zigzag pattern")
zigzag_path = [(100, 100)]
for i in range(1, 20):
    if i % 2 == 0:
        zigzag_path.append((100 + i * 30, 100 + i * 30))
    else:
        zigzag_path.append((100 + i * 30, 100 + (i - 1) * 30))
zigzag_path.append((700, 700))

sampled = validator._sample_path_for_validation(zigzag_path, 30.0)
print(f"Original points: {len(zigzag_path)}")
print(f"Sampled points: {len(sampled)}")
print(f"Sampled path (first 10): {sampled[:10]}\n")

print("Angles at each point:")
sharp_count = 0
for i in range(len(sampled) - 2):
    angle = validator._calculate_angle(sampled[i], sampled[i + 1], sampled[i + 2])
    if angle > 160:
        sharp_count += 1
    print(f"  Point {i+1}: angle = {angle:.1f}° {'<-- SHARP!' if angle > 160 else ''}")

print(f"\nSharp reversals: {sharp_count} / {len(sampled)-2}")
print(f"Ratio: {sharp_count / (len(sampled)-2) if len(sampled) > 2 else 0:.2%}")
