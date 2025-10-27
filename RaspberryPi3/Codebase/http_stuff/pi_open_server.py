"""
Raspberry Pi Control Server
- Start/stop the demo
- Monitor robot status
- All controlled via web interface
"""

from http.server import SimpleHTTPRequestHandler, HTTPServer
import os
import subprocess
import threading
import json
import time
import serial

# Configuration
SERVER_PORT = 8000
DEMO_SCRIPT = "lil_demo_path_tracking.py"
PID_FILE = "/tmp/demo.pid"

# Motor control (to stop motors when demo stops)
SERIAL_PORT = "/dev/serial0"
SERIAL_BAUD = 115200

class MotorStopper:
    """Emergency motor stop - independent of demo process"""
    @staticmethod
    def stop_motors():
        """Send stop command directly to motors"""
        try:
            ser = serial.Serial(
                port=SERIAL_PORT,
                baudrate=SERIAL_BAUD,
                bytesize=serial.EIGHTBITS,
                parity=serial.PARITY_NONE,
                stopbits=serial.STOPBITS_ONE,
                timeout=1,
                xonxoff=False,
                rtscts=False,
                dsrdtr=False
            )
            
            time.sleep(0.1)
            
            # Send stop command - exact format from lil_demo_path_tracking.py
            stop_cmd = "s,0,0,0,0,0\n"
            ser.write(stop_cmd.encode('utf-8'))
            ser.flush()
            
            time.sleep(0.1)
            ser.close()
            
            return True
        except Exception as e:
            print(f"Warning: Could not stop motors: {e}")
            return False

class DemoProcess:
    """Manages the demo script process"""
    def __init__(self):
        self.process = None
        self.running = False
        self.status = {
            'running': False,
            'pid': None,
            'start_time': None,
            'error': None,
            'last_output': None
        }
        
    def start(self):
        """Start the demo script"""
        if self.running:
            return {'success': False, 'message': 'Demo already running'}
        
        try:
            # Check if demo script exists
            if not os.path.exists(DEMO_SCRIPT):
                return {'success': False, 'message': f'Script not found: {DEMO_SCRIPT}'}
            
            # Start the demo script as a subprocess
            self.process = subprocess.Popen(
                ['python3', DEMO_SCRIPT],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                bufsize=1  # Line buffered
            )
            
            self.running = True
            self.status = {
                'running': True,
                'pid': self.process.pid,
                'start_time': time.time(),
                'error': None,
                'last_output': None
            }
            
            # Save PID to file
            with open(PID_FILE, 'w') as f:
                f.write(str(self.process.pid))
            
            # Start output monitoring thread
            threading.Thread(target=self._monitor_output, daemon=True).start()
            
            return {'success': True, 'message': f'Demo started (PID: {self.process.pid})'}
            
        except Exception as e:
            self.status['error'] = str(e)
            return {'success': False, 'message': f'Failed to start: {e}'}
    
    def stop(self):
        """Stop the demo script AND motors"""
        if not self.running:
            # Even if not running, try to stop motors anyway (safety)
            MotorStopper.stop_motors()
            return {'success': False, 'message': 'Demo not running (motors stopped anyway)'}
        
        try:
            # 1. Terminate the Python process
            if self.process:
                self.process.terminate()
                try:
                    self.process.wait(timeout=2)
                except subprocess.TimeoutExpired:
                    # Force kill if doesn't stop gracefully
                    self.process.kill()
                    self.process.wait(timeout=1)
            
            # 2. Stop the motors directly (critical!)
            motor_stopped = MotorStopper.stop_motors()
            
            self.running = False
            self.status = {
                'running': False,
                'pid': None,
                'start_time': None,
                'error': None,
                'last_output': None
            }
            
            # Remove PID file
            if os.path.exists(PID_FILE):
                os.remove(PID_FILE)
            
            if motor_stopped:
                return {'success': True, 'message': 'Demo stopped and motors halted'}
            else:
                return {'success': True, 'message': 'Demo stopped (motor stop warning - check manually)'}
            
        except Exception as e:
            # Even on error, try to stop motors
            MotorStopper.stop_motors()
            return {'success': False, 'message': f'Stop error: {e} (motors stopped)'}
    
    def get_status(self):
        """Get current demo status"""
        # Check if process is still alive
        if self.running and self.process:
            poll = self.process.poll()
            if poll is not None:
                # Process has terminated
                self.running = False
                self.status['running'] = False
                self.status['error'] = f'Process exited with code {poll}'
                # Stop motors if process died
                MotorStopper.stop_motors()
        
        # Update running time if active
        if self.running and self.status['start_time']:
            self.status['uptime'] = time.time() - self.status['start_time']
        else:
            self.status['uptime'] = 0
        
        return self.status
    
    def _monitor_output(self):
        """Monitor subprocess output"""
        if not self.process:
            return
        
        try:
            for line in self.process.stdout:
                line = line.strip()
                if line:
                    self.status['last_output'] = line
                    
                    # Parse robot position if in the output
                    if "Pos:" in line or "Frame" in line:
                        self.status['last_line'] = line
        except Exception as e:
            self.status['error'] = f'Monitor error: {e}'

# Global demo process manager
demo = DemoProcess()

class ControlHandler(SimpleHTTPRequestHandler):
    """HTTP request handler for control panel"""
    
    def do_GET(self):
        """Handle GET requests"""
        if self.path == '/':
            # Serve the main control panel HTML
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(self.get_html().encode())
            
        elif self.path == '/status':
            # Return current status as JSON
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            status = demo.get_status()
            self.wfile.write(json.dumps(status).encode())
            
        else:
            self.send_error(404)
    
    def do_POST(self):
        """Handle POST requests"""
        if self.path == '/start':
            # Start the demo
            result = demo.start()
            self.send_json_response(result)
            
        elif self.path == '/stop':
            # Stop the demo (and motors!)
            result = demo.stop()
            self.send_json_response(result)
            
        elif self.path == '/emergency_stop':
            # Emergency stop motors only
            result = MotorStopper.stop_motors()
            self.send_json_response({
                'success': result,
                'message': 'Emergency motor stop sent' if result else 'Emergency stop failed'
            })
            
        else:
            self.send_error(404)
    
    def send_json_response(self, data):
        """Send JSON response"""
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())
    
    def get_html(self):
        """Generate control panel HTML"""
        return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>🤖 Raspberry Pi Demo Control</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
        }
        .panel {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 28px;
        }
        h2 {
            color: #555;
            margin-bottom: 15px;
            font-size: 20px;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }
        .status-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 14px;
            margin-bottom: 15px;
        }
        .status-running {
            background: #4CAF50;
            color: white;
        }
        .status-stopped {
            background: #f44336;
            color: white;
        }
        .btn-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }
        .btn-emergency {
            grid-column: 1 / -1;
        }
        button {
            padding: 15px 25px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }
        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .btn-start {
            background: #4CAF50;
            color: white;
        }
        .btn-start:hover { background: #45a049; }
        .btn-stop {
            background: #f44336;
            color: white;
        }
        .btn-stop:hover { background: #da190b; }
        .btn-emergency {
            background: #FF5722;
            color: white;
            font-size: 18px;
        }
        .btn-emergency:hover { 
            background: #E64A19;
            box-shadow: 0 5px 20px rgba(255,87,34,0.5);
        }
        .status-info {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
            max-height: 300px;
            overflow-y: auto;
        }
        .status-info div {
            margin: 5px 0;
        }
        .message {
            padding: 12px;
            border-radius: 6px;
            margin-top: 10px;
            display: none;
        }
        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .footer {
            text-align: center;
            color: white;
            margin-top: 20px;
            opacity: 0.8;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }
        .running-indicator {
            display: inline-block;
            width: 10px;
            height: 10px;
            background: #4CAF50;
            border-radius: 50%;
            margin-right: 8px;
            animation: pulse 2s infinite;
        }
        .error-text {
            color: #f44336;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="panel">
            <h1>🤖 Raspberry Pi Demo Control</h1>
            <div id="statusBadge" class="status-badge status-stopped">● STOPPED</div>
            
            <h2>🎮 Controls</h2>
            <div class="btn-group">
                <button class="btn-start" onclick="startDemo()">▶ START DEMO</button>
                <button class="btn-stop" onclick="stopDemo()">⏹ STOP DEMO</button>
                <button class="btn-emergency btn-emergency" onclick="emergencyStop()">🚨 EMERGENCY MOTOR STOP</button>
            </div>
            
            <div id="message" class="message"></div>
            
            <h2>📊 Status</h2>
            <div id="statusInfo" class="status-info">
                <div><strong>State:</strong> <span id="state">Stopped</span></div>
                <div><strong>PID:</strong> <span id="pid">-</span></div>
                <div><strong>Uptime:</strong> <span id="uptime">-</span></div>
                <div id="errorDiv" style="display:none;"><strong>Error:</strong> <span id="error" class="error-text"></span></div>
                <div style="margin-top:10px; padding-top:10px; border-top:1px solid #ddd;">
                    <strong>Last Output:</strong><br>
                    <span id="output" style="color:#666;">-</span>
                </div>
            </div>
        </div>
        
        <div class="footer">
            <p>🎯 Circular Path Tracking Demo</p>
            <p style="font-size:12px; margin-top:5px;">Script: lil_demo_path_tracking.py</p>
        </div>
    </div>

    <script>
        // Auto-refresh status every 1 second
        setInterval(updateStatus, 1000);
        updateStatus();

        async function startDemo() {
            try {
                const response = await fetch('/start', { method: 'POST' });
                const result = await response.json();
                showMessage(result.message, result.success);
                updateStatus();
            } catch (err) {
                showMessage('Failed to start demo: ' + err, false);
            }
        }

        async function stopDemo() {
            try {
                const response = await fetch('/stop', { method: 'POST' });
                const result = await response.json();
                showMessage(result.message, result.success);
                updateStatus();
            } catch (err) {
                showMessage('Failed to stop demo: ' + err, false);
            }
        }

        async function emergencyStop() {
            if (!confirm('Send EMERGENCY STOP to motors?')) return;
            
            try {
                const response = await fetch('/emergency_stop', { method: 'POST' });
                const result = await response.json();
                showMessage(result.message, result.success);
            } catch (err) {
                showMessage('Emergency stop failed: ' + err, false);
            }
        }

        async function updateStatus() {
            try {
                const response = await fetch('/status');
                const status = await response.json();
                
                // Update badge
                const badge = document.getElementById('statusBadge');
                if (status.running) {
                    badge.className = 'status-badge status-running';
                    badge.innerHTML = '<span class="running-indicator"></span>RUNNING';
                } else {
                    badge.className = 'status-badge status-stopped';
                    badge.innerHTML = '● STOPPED';
                }
                
                // Update status info
                document.getElementById('state').textContent = status.running ? 'Running' : 'Stopped';
                document.getElementById('pid').textContent = status.pid || '-';
                document.getElementById('uptime').textContent = status.uptime 
                    ? formatUptime(status.uptime) : '-';
                
                // Show error if any
                const errorDiv = document.getElementById('errorDiv');
                if (status.error) {
                    errorDiv.style.display = 'block';
                    document.getElementById('error').textContent = status.error;
                } else {
                    errorDiv.style.display = 'none';
                }
                
                // Update output
                const outputEl = document.getElementById('output');
                if (status.last_line || status.last_output) {
                    outputEl.textContent = status.last_line || status.last_output;
                    outputEl.style.color = '#333';
                } else {
                    outputEl.textContent = '-';
                    outputEl.style.color = '#666';
                }
                
            } catch (err) {
                console.error('Status update failed:', err);
            }
        }

        function showMessage(msg, success) {
            const el = document.getElementById('message');
            el.textContent = msg;
            el.className = 'message ' + (success ? 'success' : 'error');
            el.style.display = 'block';
            setTimeout(() => el.style.display = 'none', 5000);
        }

        function formatUptime(seconds) {
            const h = Math.floor(seconds / 3600);
            const m = Math.floor((seconds % 3600) / 60);
            const s = Math.floor(seconds % 60);
            return `${h}h ${m}m ${s}s`;
        }
    </script>
</body>
</html>
        '''

def main():
    print("\n" + "="*60)
    print("🌐 Raspberry Pi Control Server")
    print("="*60)
    print(f"Server running on port {SERVER_PORT}")
    print(f"Controlled script: {DEMO_SCRIPT}")
    print(f"Motor control: {SERIAL_PORT} @ {SERIAL_BAUD}")
    print(f"\nAccess from browser:")
    print(f"  http://raspberrypi.local:{SERVER_PORT}")
    print(f"  http://192.168.0.X:{SERVER_PORT}")
    print("\nPress Ctrl+C to stop server")
    print("="*60 + "\n")
    
    server = HTTPServer(('0.0.0.0', SERVER_PORT), ControlHandler)
    
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n\n✓ Stopping server...")
        if demo.running:
            print("Stopping demo and motors...")
            demo.stop()
    finally:
        # Final safety: stop motors on server shutdown
        MotorStopper.stop_motors()
        server.server_close()
        print("✓ Server stopped, motors halted")

if __name__ == '__main__':
    main()