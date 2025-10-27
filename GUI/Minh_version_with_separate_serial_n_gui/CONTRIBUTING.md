# Contributing to Multi-Robot Path Planning System

Thank you for considering contributing to this educational robotics project! This guide will help you get started.

## 🎯 Project Goals

This project aims to:
- Provide an intuitive educational tool for teaching path planning
- Maintain production-level code quality
- Support students learning robotics concepts
- Remain accessible and easy to understand

## 🚀 Getting Started

### Development Setup

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/8zism8/StudentShowcaseOct25.git
   cd StudentShowcaseOct25
   ```

2. **Create a virtual environment**
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run tests to verify setup**
   ```bash
   python -m pytest tests/
   ```

## 📝 How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:
- A clear, descriptive title
- Steps to reproduce the problem
- Expected vs actual behavior
- Your environment (OS, Python version, dependencies)
- Screenshots if applicable

### Suggesting Enhancements

We welcome feature suggestions! Please open an issue with:
- A clear description of the enhancement
- Why it would be useful for students/educators
- Potential implementation approach (optional)

### Pull Requests

1. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow the existing code style
   - Add tests for new functionality
   - Update documentation as needed
   - Keep commits focused and atomic

3. **Test your changes**
   ```bash
   # Run all tests
   python -m pytest tests/
   
   # Run specific test
   python tests/test_your_feature.py
   
   # Manual testing
   python robot_path_planner.py
   ```

4. **Submit a pull request**
   - Provide a clear description of changes
   - Reference any related issues
   - Ensure all tests pass

## 🎨 Code Style

### Python Style Guide

- Follow [PEP 8](https://pep8.org/) style guidelines
- Use type hints for function parameters and return values
- Write docstrings for classes and functions
- Keep functions focused and under 50 lines when possible

**Example:**
```python
def optimize_waypoints(self, path: List[Tuple[float, float]]) -> List[Tuple[float, float]]:
    """
    Optimize path waypoints based on curvature analysis.
    
    Args:
        path: List of (x, y) coordinates along the path
        
    Returns:
        List of optimized waypoints (always exactly 20 points)
    """
    # Implementation here
    pass
```

### Code Organization

- Keep modules focused on single responsibilities
- Separate GUI logic from business logic
- Use meaningful variable and function names
- Add comments for complex algorithms

### Testing

- Write tests for all new features
- Maintain test coverage above 80%
- Include both unit tests and integration tests
- Test edge cases and error conditions

## 📚 Documentation

### Code Documentation

- Add docstrings to all public functions and classes
- Use clear, concise comments for complex logic
- Update existing documentation when changing behavior

### User Documentation

When adding features that affect users:
- Update README.md with new functionality
- Add examples to docs/QUICKSTART.md if appropriate
- Update docs/ARCHITECTURE.md for structural changes

## 🧪 Testing Guidelines

### Running Tests

```bash
# Run all tests
python -m pytest tests/

# Run with coverage
python -m pytest tests/ --cov=. --cov-report=html

# Run specific test file
python tests/test_integration.py
```

### Writing Tests

Create test files in the `tests/` directory:

```python
import pytest
from path_optimizer import WaypointOptimizer

def test_waypoint_optimization():
    """Test that waypoints are optimized correctly."""
    optimizer = WaypointOptimizer(min_distance_mm=100.0)
    
    # Create test path
    path = [(0, 0), (100, 100), (200, 200)]
    
    # Optimize
    waypoints = optimizer.optimize_waypoints(path)
    
    # Verify
    assert len(waypoints) == 20
    assert waypoints[0] == path[0]
    assert waypoints[-1] == path[-1]
```

## 🐛 Debugging

### Common Issues

**Import errors:**
```bash
# Ensure you're in the project root
cd /path/to/robot-path-planner

# Activate virtual environment
source .venv/bin/activate
```

**GUI doesn't display:**
- Check PyQt5 installation: `pip install --upgrade PyQt5`
- Verify Python version: `python --version` (need 3.7+)

**Tests failing:**
- Run with verbose output: `python -m pytest tests/ -v`
- Check for dependency issues: `pip list`

## 🌟 Areas for Contribution

We especially welcome contributions in these areas:

### High Priority
- [ ] Collision detection between robot paths
- [ ] Undo/redo functionality
- [ ] Save/load mission progress
- [ ] Animation preview of robot movement

### Medium Priority
- [ ] Path efficiency metrics and scoring
- [ ] Tutorial mode for first-time users
- [ ] Additional validation rules
- [ ] Performance optimizations

### Documentation
- [ ] Video tutorials
- [ ] More code examples
- [ ] API reference documentation
- [ ] Troubleshooting guide

### Testing
- [ ] Increase test coverage
- [ ] Add performance benchmarks
- [ ] Create automated UI tests
- [ ] Add stress tests

## 📋 Code Review Process

All pull requests go through code review:

1. **Automated checks** (if configured)
   - Tests must pass
   - Code style checks
   - Coverage requirements

2. **Manual review**
   - Code quality and maintainability
   - Adherence to project goals
   - Documentation completeness
   - Test coverage

3. **Feedback and iteration**
   - Reviewers may request changes
   - Discussion and collaboration
   - Final approval and merge

## 🤔 Questions?

If you have questions about contributing:
- Open an issue with the "question" label
- Check existing issues for similar questions
- Review the documentation in the `docs/` folder

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of background or experience level.

### Expected Behavior

- Be respectful and considerate
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Accept criticism gracefully
- Prioritize educational value

### Unacceptable Behavior

- Harassment or discriminatory language
- Personal attacks
- Trolling or inflammatory comments
- Publishing private information
- Other unprofessional conduct

## 🎓 Educational Focus

Remember that this project is designed for education:
- Keep explanations clear and accessible
- Prioritize learning value over complex optimization
- Include educational comments in code
- Consider how changes affect students learning robotics

## 🙏 Thank You!

Your contributions help improve robotics education. We appreciate your time and effort!

---

**Happy coding! 🤖**
