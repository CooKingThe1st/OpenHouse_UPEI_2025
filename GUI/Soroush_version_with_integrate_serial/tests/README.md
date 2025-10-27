# Tests Directory

This directory contains the test suite for the Multi-Robot Path Planning System.

## Running Tests

### Run All Tests
```bash
python -m pytest tests/
```

### Run Specific Test
```bash
python tests/test_integration.py
```

### Run with Coverage
```bash
python -m pytest tests/ --cov=. --cov-report=html
```

## Test Files

### Integration Tests
- **`test_integration.py`**: End-to-end workflow testing
  - Tests complete pipeline from path drawing to waypoint output
  - Validates mission loading and robot configurations

### Waypoint Optimization Tests
- **`test_waypoint_optimization.py`**: Waypoint distribution testing
  - Verifies intelligent waypoint placement
  - Tests straight vs curved path handling
  - Validates distance scaling and adaptive thresholding

- **`test_curvature_debug.py`**: Curvature analysis debugging
  - Detailed curvature calculations
  - Waypoint placement visualization
  - Helps diagnose optimization issues

### Path Validation Tests
- **`test_path_direction.py`**: Path direction auto-correction
  - Tests forward and backward path validation
  - Verifies automatic path normalization
  - Validates error messages

### Bug Fix Verification Tests
- **`test_zigzag_fix.py`**: Zigzag detection verification
  - Ensures false positives are eliminated
  - Tests that smooth paths are accepted

- **`test_zigzag_debug.py`**: Zigzag detection debugging
  - Analyzes angle calculations
  - Helps understand zigzag algorithm behavior

### Other Tests
- **`test_rdp_waypoints.py`**: Ramer-Douglas-Peucker algorithm testing
- **`test_all_fixes.py`**: Comprehensive bug fix verification

## Writing New Tests

### Test Structure

```python
import pytest
from your_module import YourClass

def test_feature_name():
    """Test description explaining what is being tested."""
    # Arrange
    obj = YourClass()
    
    # Act
    result = obj.method()
    
    # Assert
    assert result == expected_value
```

### Best Practices

1. **Name tests clearly**: Use descriptive names like `test_waypoint_optimization_on_straight_path`
2. **Test one thing**: Each test should verify a single behavior
3. **Use assertions**: Clear assert statements with helpful messages
4. **Include edge cases**: Test boundary conditions and error cases
5. **Document tests**: Add docstrings explaining what is being tested

### Example Test

```python
def test_path_normalization():
    """Test that paths drawn backwards are automatically reversed."""
    validator = PathValidator()
    robot = RobotConfig(
        color=RobotColor.RED,
        start_pos=(100, 100),
        end_pos=(700, 700)
    )
    
    # Path drawn from END to START (backwards)
    backward_path = [(700, 700), (500, 500), (100, 100)]
    
    # Normalize the path
    normalized = validator.normalize_path_direction(backward_path, robot)
    
    # Should be reversed to go from START to END
    assert normalized[0] == (100, 100)
    assert normalized[-1] == (700, 700)
```

## Test Coverage Goals

- **Overall**: Maintain >80% code coverage
- **Core modules**: Aim for >90% coverage
  - `path_optimizer.py`
  - `path_validator.py`
  - `mission_config.py`
- **GUI module**: >60% coverage (harder to test)
  - `robot_path_planner.py`

## Continuous Integration

Tests are automatically run on:
- Every push to main branch
- Every pull request
- Scheduled nightly builds

## Debugging Failed Tests

### Common Issues

**Import errors:**
```bash
# Run from project root
cd /path/to/robot-path-planner
python tests/test_file.py
```

**Missing dependencies:**
```bash
pip install -r requirements.txt
```

**GUI tests failing:**
```bash
# Some GUI tests require display
# On Linux servers, use Xvfb
xvfb-run python tests/test_integration.py
```

### Verbose Output

```bash
# See detailed test output
python -m pytest tests/ -v -s

# Show print statements
python -m pytest tests/ --capture=no
```

## Contributing Tests

When adding new features:
1. Write tests before implementing (TDD)
2. Ensure tests pass locally
3. Run full test suite before submitting PR
4. Add test documentation to this README

## Test Data

Test files may use:
- Predefined path coordinates
- Mission configurations from `mission_config.py`
- Sample robot configurations
- Mock GUI events (for integration tests)

## Performance Tests

Currently not implemented, but would include:
- Path interpolation speed
- Waypoint optimization performance
- GUI responsiveness under load

## Future Test Enhancements

- [ ] Automated UI testing with pytest-qt
- [ ] Performance benchmarks
- [ ] Stress tests with many paths
- [ ] Visual regression testing
- [ ] Property-based testing with Hypothesis

---

**Last Updated**: October 24, 2025
