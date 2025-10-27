# 🚀 Quick Start - Robot Communication System

**Get your robots moving in 3 minutes!**

## Step 1: Install Dependencies (30 seconds)

```powershell
pip install -r requirements.txt
```

This installs:
- `pyserial` - For robot communication
- `PyQt5` - For GUI (if not already installed)
- Other existing dependencies

## Step 2: Find Your Serial Port (30 seconds)

**Windows:**
1. Open Device Manager
2. Expand "Ports (COM & LPT)"
3. Find your USB device (e.g., "COM5")

**Linux:**
```bash
ls /dev/ttyUSB*
# or
ls /dev/ttyACM*
```

**macOS:**
```bash
ls /dev/tty.usbserial-*
```

## Step 3: Choose Your Path (2 minutes)

### Option A: Full GUI (Easiest)

```powershell
python gui_with_robots.py
```

Then:
1. Click **"Connect to Robots"** button
2. Enter your port (e.g., `COM5`)
3. Draw paths as usual
4. Click **"Set Waypoints"** - automatically sends to robots!
5. Click **"Execute Mission"** to start

**That's it!** 🎉

---

### Option B: Simple Python Script

```powershell
python simple_robot_example.py
```

Edit the port in the file first (line ~17):
```python
bridge = create_bridge(
    port="COM5",  # ← Change this to your port
    ...
)
```

This runs a pre-programmed demo with 2 robots.

---

### Option C: Custom Code (Most Flexible)

Create `my_robot_script.py`:

```python
from gui_robot_bridge import create_bridge

# Connect
bridge = create_bridge(port="COM5", auto_connect=True)

# Define waypoints (20 per robot, in millimeters)
waypoints_red = [(-500, -500), (-500, 500), (500, 500), (500, -500)]
waypoints_red.extend([waypoints_red[-1]] * 16)  # Pad to 20

robot_commands = {
    'red': waypoints_red
}

# Send and run
result = bridge.send_mission_waypoints(robot_commands)
if result.success:
    bridge.run_all_loaded_robots()

# Later: stop
bridge.stop_all_robots()
bridge.disconnect()
```

Run:
```powershell
python my_robot_script.py
```

## 🧪 Test the Connection

Before running with real waypoints, test the connection:

```powershell
python robot_controller.py
```

This sends a test rectangle path to robot 1 (red). You should see:
- ✓ Connection success message
- Packets being sent (logged to `robot_controller_sent.log`)
- Robot receiving waypoints

**If this works, everything is set up correctly!**

## ⚠️ Troubleshooting (1 minute)

### "Failed to connect"
- Check port name is correct
- Close other programs using the port
- Unplug/replug USB cable

### "Port not found"
- Device not connected
- Wrong port name
- Driver not installed

### "Permission denied" (Linux/macOS)
```bash
sudo chmod 666 /dev/ttyUSB0
# or add yourself to dialout group:
sudo usermod -a -G dialout $USER
# then logout/login
```

## 📚 Next Steps

1. **Read Quick Reference**
   ```
   QUICK_REFERENCE.md
   ```
   Copy-paste code snippets

2. **Read Main README**
   ```
   ROBOT_COMMUNICATION_README.md
   ```
   Complete system overview

3. **Deep Dive**
   ```
   ROBOT_INTEGRATION_GUIDE.md
   ```
   Comprehensive documentation

## 💡 Tips

- **Always check connection first:**
  ```python
  if bridge.is_connected():
      # send waypoints
  ```

- **Handle errors:**
  ```python
  result = bridge.send_mission_waypoints(...)
  if not result.success:
      print(f"Error: {result.message}")
  ```

- **Emergency stop always available:**
  ```python
  bridge.stop_all_robots()
  ```

- **Check logs if something goes wrong:**
  - `robot_controller_sent.log`
  - `robot_controller_received.log`

## 🎯 What Each File Does

| File | Use It For |
|------|------------|
| `gui_with_robots.py` | Full GUI with robot control |
| `simple_robot_example.py` | Quick test/demo |
| `robot_controller.py` | Low-level testing |
| `gui_robot_bridge.py` | Building custom scripts |

## 🆘 Get Help

1. Check `QUICK_REFERENCE.md` for common patterns
2. Check `IMPLEMENTATION_SUMMARY.md` for overview
3. Check log files for detailed errors
4. Review troubleshooting in `ROBOT_COMMUNICATION_README.md`

---

**You're ready to control robots!** 🤖✨

Start with Option A (full GUI) for the easiest experience!
