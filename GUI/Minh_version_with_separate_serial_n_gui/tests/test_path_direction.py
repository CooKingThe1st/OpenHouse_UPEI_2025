"""
Test script to verify path direction normalization.
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

print("=== Testing Path Direction Normalization ===\n")

# Test 1: Path drawn in correct direction (start to end)
print("Test 1: Path drawn correctly (start → end)")
forward_path = [(100, 100), (200, 200), (300, 300), (400, 400), (500, 500), (600, 600), (700, 700)]
result = validator.validate_path(forward_path, test_robot)
print(f"Validation: {result}")
normalized = validator.normalize_path_direction(forward_path, test_robot)
print(f"Path unchanged: {normalized == forward_path}")
print(f"First point: {normalized[0]}, Last point: {normalized[-1]}\n")

# Test 2: Path drawn in reverse direction (end to start)
print("Test 2: Path drawn backwards (end → start)")
backward_path = [(700, 700), (600, 600), (500, 500), (400, 400), (300, 300), (200, 200), (100, 100)]
result = validator.validate_path(backward_path, test_robot)
print(f"Validation: {result}")
normalized = validator.normalize_path_direction(backward_path, test_robot)
print(f"Path was reversed: {normalized != backward_path}")
print(f"First point: {normalized[0]}, Last point: {normalized[-1]}")
print(f"Now starts near START: {normalized[0] == (100, 100)}")
print(f"Now ends near END: {normalized[-1] == (700, 700)}\n")

# Test 3: Path drawn backwards with slight offset
print("Test 3: Path drawn backwards with slight mouse offset")
backward_offset = [(705, 695), (600, 600), (500, 500), (400, 400), (300, 300), (200, 200), (95, 105)]
result = validator.validate_path(backward_offset, test_robot)
print(f"Validation: {result}")
normalized = validator.normalize_path_direction(backward_offset, test_robot)
print(f"Path was reversed: {normalized != backward_offset}")
print(f"First point: {normalized[0]}, Last point: {normalized[-1]}")
print(f"Now starts near START (95, 105): {normalized[0] == (95, 105)}")
print(f"Now ends near END (705, 695): {normalized[-1] == (705, 695)}\n")

# Test 4: Path that doesn't connect properly (should fail)
print("Test 4: Invalid path (doesn't connect start and end)")
invalid_path = [(200, 200), (300, 300), (400, 400), (500, 500)]
result = validator.validate_path(invalid_path, test_robot)
print(f"Validation: {result}\n")

print("=== Test Complete ===")
