"""
Test script to verify the zigzag detection fix.
"""

from path_validator import PathValidator
from mission_config import RobotConfig, RobotColor

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

print("=== Testing Zigzag Detection Fix ===\n")

# Test 1: Simple smooth path (should pass)
print("Test 1: Simple smooth diagonal path")
smooth_path = [(100, 100), (200, 200), (300, 300), (400, 400), (500, 500), (600, 600), (700, 700)]
result = validator.validate_path(smooth_path, test_robot)
print(f"Result: {result}\n")

# Test 2: Dense path simulating mouse movement (should pass now)
print("Test 2: Dense path with many points (simulating mouse drawing)")
dense_path = [(100, 100)]
for i in range(1, 100):
    x = 100 + (600 * i / 100)
    y = 100 + (600 * i / 100) + (5 * (i % 2))  # Tiny zigzag due to mouse jitter
    dense_path.append((x, y))
dense_path.append((700, 700))
result = validator.validate_path(dense_path, test_robot)
print(f"Result: {result}")
print(f"Path has {len(dense_path)} points\n")

# Test 3: Curved path with many points (should pass)
print("Test 3: Curved path with many points")
import math
curved_path = [(100, 100)]
for i in range(1, 50):
    t = i / 50
    x = 100 + 600 * t
    y = 100 + 600 * t + 100 * math.sin(t * math.pi * 2)
    curved_path.append((x, y))
curved_path.append((700, 700))
result = validator.validate_path(curved_path, test_robot)
print(f"Result: {result}")
print(f"Path has {len(curved_path)} points\n")

# Test 4: Actual extreme zigzag (should fail)
print("Test 4: Actual extreme zigzag pattern (should fail)")
zigzag_path = [(100, 100)]
for i in range(20):
    if i % 2 == 0:
        zigzag_path.append((100 + i * 30, 100 + i * 30))
    else:
        zigzag_path.append((100 + i * 30, 100 + (i - 1) * 30))
zigzag_path.append((700, 700))
result = validator.validate_path(zigzag_path, test_robot)
print(f"Result: {result}\n")

print("=== Testing Complete ===")
