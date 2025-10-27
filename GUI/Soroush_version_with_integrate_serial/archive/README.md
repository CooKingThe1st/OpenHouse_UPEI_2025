# Archive Directory

This directory contains legacy files and development history that are not part of the main production codebase but are kept for reference.

## Contents

### Legacy Application
- **`OpenDay_MRS.py`**: Original monolithic application (~5300 lines)
  - Legacy system before modular refactoring
  - Contains camera integration, OptiTrack visualization, and highscore features
  - Kept for reference and historical purposes

### Development Documentation
- **`PROJECT_SUMMARY.md`**: Complete development journey documentation
- **`MIGRATION_GUIDE.md`**: Guide for transitioning from old to new system
- **`UI_UX_IMPROVEMENTS.md`**: Detailed UI/UX design decisions and changes
- **`README_NEW_GUI.md`**: Original comprehensive technical documentation

### Legacy Utilities
- **`demo_pipeline.py`**: Pipeline demonstration script (replaced by tests)
- **`coordinate_transformer.py`**: Old calibration-based coordinate transformer
  - Replaced by simpler `CoordinateConverter` class in `path_optimizer.py`
  - Kept for reference to original calibration approach

## Why These Files Are Archived

These files are moved to the archive because they:
1. Are no longer actively used in the production system
2. Represent previous iterations of the codebase
3. Contain useful historical context and design decisions
4. May be referenced for understanding project evolution

## Current Production Files

For the active codebase, see the main project directory:
- `robot_path_planner.py` - Main application
- `mission_config.py` - Mission configurations
- `path_optimizer.py` - Path optimization logic
- `path_validator.py` - Validation logic
- `docs/` - Current documentation
- `tests/` - Test suite

## Restoration

If you need to reference or restore any of these files:

```bash
# Copy a file back to root (example)
cp archive/OpenDay_MRS.py ../OpenDay_MRS.py

# View legacy documentation
cat archive/PROJECT_SUMMARY.md
```

## Notes

- These files are kept in version control for historical purposes
- They are not maintained or updated
- Do not modify files in this directory
- For any questions about archived files, see the git history or contact maintainers

---

**Last Updated**: October 24, 2025
