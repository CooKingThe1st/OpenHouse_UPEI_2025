"""
Simple Robot Control Example
============================

Minimal example showing how to send waypoints to robots
from Python code (without GUI).

This demonstrates the core integration pattern that can be
used in any Python application.

Author: Production System
Date: 2025-10-25
"""

from gui_robot_bridge import create_bridge
import time


def main():
    """Simple waypoint transmission example."""
    
    print("="*60)
    print("Simple Robot Control Example")
    print("="*60)
    
    # Step 1: Connect to robots
    print("\n[1/4] Connecting to robots on COM5...")
    
    def status_callback(msg):
        print(f"  → {msg}")
    
    bridge = create_bridge(
        port="COM5",
        baud_rate=9600,
        status_callback=status_callback,
        auto_connect=True
    )
    
    if not bridge:
        print("✗ Failed to connect. Exiting.")
        return
    
    print("✓ Connected!")
    
    try:
        # Step 2: Define waypoints (in millimeters)
        print("\n[2/4] Preparing waypoints...")
        
        # Red robot: Simple square path
        waypoints_red = [
            (-500.0, -500.0),  # Start: bottom-left
            (-500.0, 500.0),   # Top-left
            (500.0, 500.0),    # Top-right
            (500.0, -500.0),   # Bottom-right
            (-500.0, -500.0),  # Back to start
        ]
        
        # Pad to 20 waypoints
        last_wp = waypoints_red[-1]
        while len(waypoints_red) < 20:
            waypoints_red.append(last_wp)
        
        # Green robot: Diagonal path
        waypoints_green = [
            (500.0, -500.0),   # Start: bottom-right
            (0.0, 0.0),        # Center
            (-500.0, 500.0),   # Top-left
        ]
        
        # Pad to 20 waypoints
        last_wp = waypoints_green[-1]
        while len(waypoints_green) < 20:
            waypoints_green.append(last_wp)
        
        # Combine into robot_commands dict
        robot_commands = {
            'red': waypoints_red,
            'green': waypoints_green
        }
        
        print(f"✓ Prepared waypoints for {len(robot_commands)} robots")
        print(f"  - Red: {len(waypoints_red)} waypoints")
        print(f"  - Green: {len(waypoints_green)} waypoints")
        
        # Step 3: Send waypoints to robots
        print("\n[3/4] Sending waypoints to robots...")
        
        result = bridge.send_mission_waypoints(
            robot_commands,
            run_after_send=False  # We'll run manually
        )
        
        if not result.success:
            print(f"✗ Failed: {result.message}")
            for error in result.errors:
                print(f"  - {error}")
            return
        
        print(f"✓ Waypoints sent to {result.robots_processed} robot(s)")
        
        # Step 4: Execute mission
        print("\n[4/4] Executing mission...")
        print("Press Ctrl+C to stop early, or wait 15 seconds...")
        
        time.sleep(1)  # Brief pause
        
        run_result = bridge.run_all_loaded_robots()
        
        if not run_result.success:
            print(f"✗ Failed to start mission: {run_result.message}")
            return
        
        print(f"✓ Mission started for {run_result.robots_processed} robot(s)")
        print("\nRobots are now executing their paths...")
        
        # Let mission run for 15 seconds
        try:
            for i in range(15, 0, -1):
                print(f"  Running... {i} seconds remaining", end='\r')
                time.sleep(1)
            print("\n")
        except KeyboardInterrupt:
            print("\n\nInterrupted by user")
        
        # Stop robots
        print("Stopping robots...")
        stop_result = bridge.stop_all_robots()
        print(f"✓ {stop_result.message}")
        
        print("\n" + "="*60)
        print("Mission Complete!")
        print("="*60)
    
    finally:
        # Always disconnect
        print("\nDisconnecting from robots...")
        bridge.disconnect()
        print("✓ Done")


if __name__ == "__main__":
    main()
