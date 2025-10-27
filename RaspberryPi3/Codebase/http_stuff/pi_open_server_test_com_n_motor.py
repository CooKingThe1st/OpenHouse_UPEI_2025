"""
Raspberry Pi Control Server
- Start/stop the demo with mode selection
- Send commands via TCP to running demo
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
import socket

# Configuration
SERVER_PORT = 8000
DEMO_SCRIPT = "lil_demo_path_tracking.py"
PID_FILE = "/tmp/demo.pid"
STATUS_FILE = "/tmp/demo_status.json"

# Motor control
SERIAL_PORT = "/dev/serial0"
SERIAL_BAUD = 115200

# TCP command client (to talk to demo's backdoor)
TCP_COMMAND_PORT = 5500


def log_suppression(self, format, *args):
    """Suppress HTTP request logging"""
    pass


class MotorStopper:
    """Emergency motor stop - independent of demo process"""
    @staticmethod
    def stop_motors():
        try:
            ser = serial.Serial(
                port=SERIAL_PORT, baudrate=SERIAL_BAUD,
                bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE,
                stopbits=serial.STOPBITS_ONE, timeout=1,
                xonxoff=False, rtscts=False, dsrdtr=False
            )
            time.sleep(0.1)
            ser.write("s,0,0,0,0,0\n".encode('utf-8'))
            ser.flush()
            time.sleep(0.1)
            ser.close()
            return True
        except Exception as e:
            print(f"Warning: Could not stop motors: {e}")
            return False


class TCPCommandClient:
    """Client to send commands to demo's TCP backdoor"""
    
    @staticmethod
    def send_command(command_dict, timeout=5.0):
        """
        Send command to running demo via TCP
        Returns: response dict or None on failure
        """
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(timeout)
            sock.connect(('127.0.0.1', TCP_COMMAND_PORT))
            
            # Send command as JSON
            command_json = json.dumps(command_dict)
            sock.sendall(command_json.encode('utf-8'))
            
            # Receive response
            response_data = sock.recv(4096)
            response = json.loads(response_data.decode('utf-8'))
            
            sock.close()
            return response
            
        except Exception as e:
            return {'success': False, 'error': f'TCP command failed: {e}'}


class DemoProcess:
    """Manages the demo script process"""
    
    def __init__(self):
        self.process = None
        self.running = False
        self.monitor_thread = None
        self.output_lines = []
        self.max_output_lines = 100
    
    def start(self):
        """Start the demo script"""
        if self.running:
            return {'success': False, 'message': 'Demo already running'}
        
        try:
            self.process = subprocess.Popen(
                ['python3', DEMO_SCRIPT],
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                universal_newlines=True,
                bufsize=1
            )
            
            with open(PID_FILE, 'w') as f:
                f.write(str(self.process.pid))
            
            self.running = True
            self.output_lines = []
            
            self.monitor_thread = threading.Thread(target=self._monitor_output, daemon=True)
            self.monitor_thread.start()
            
            # Wait a moment for demo to start
            time.sleep(1)
            
            return {'success': True, 'message': f'Demo started (PID: {self.process.pid})'}
            
        except Exception as e:
            return {'success': False, 'message': f'Failed to start: {e}'}
    
    def stop(self):
        """Stop the demo script"""
        if not self.running:
            return {'success': False, 'message': 'Demo not running'}
        
        try:
            MotorStopper.stop_motors()
            
            if self.process:
                self.process.terminate()
                try:
                    self.process.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    self.process.kill()
                    self.process.wait()
            
            self.running = False
            
            if os.path.exists(PID_FILE):
                os.remove(PID_FILE)
            if os.path.exists(STATUS_FILE):
                os.remove(STATUS_FILE)
            
            return {'success': True, 'message': 'Demo stopped'}
            
        except Exception as e:
            return {'success': False, 'message': f'Failed to stop: {e}'}
    
    def send_mode_command(self, mode, params=None):
        """
        Send mode command to running demo via TCP
        Modes: test_motor, goal_reaching, path_tracking
        """
        if not self.running:
            return {'success': False, 'message': 'Demo not running. Start it first.'}
        
        # Build command
        command = {'command': mode}
        if params:
            command.update(params)
        
        # Send via TCP
        response = TCPCommandClient.send_command(command)
        return response
    
    def _monitor_output(self):
        if not self.process:
            return
        
        try:
            for line in self.process.stdout:
                self.output_lines.append(line.strip())
                if len(self.output_lines) > self.max_output_lines:
                    self.output_lines.pop(0)
        except:
            pass
        
        self.running = False
    
    def get_status(self):
        status = {
            'running': self.running,
            'pid': self.process.pid if self.process else None,
            'output': self.output_lines[-20:] if self.output_lines else [],
            'demo_data': None
        }
        
        if self.running and os.path.exists(STATUS_FILE):
            try:
                with open(STATUS_FILE, 'r') as f:
                    demo_data = json.load(f)
                    if time.time() - demo_data.get('timestamp', 0) < 2.0:
                        status['demo_data'] = demo_data
            except:
                pass
        
        return status


demo = DemoProcess()


class ControlHandler(SimpleHTTPRequestHandler):
    log_message = log_suppression
    
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(self.get_html().encode())
            
        elif self.path == '/status':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            status = demo.get_status()
            self.wfile.write(json.dumps(status).encode())
            
        else:
            self.send_error(404)
    
    def do_POST(self):
        content_length = int(self.headers.get('Content-Length', 0))
        post_data = self.rfile.read(content_length).decode('utf-8') if content_length > 0 else '{}'
        
        try:
            params = json.loads(post_data) if post_data else {}
        except:
            params = {}
        
        if self.path == '/start':
            result = demo.start()
            self.send_json_response(result)
            
        elif self.path == '/stop':
            result = demo.stop()
            self.send_json_response(result)
            
        elif self.path == '/emergency_stop':
            MotorStopper.stop_motors()
            self.send_json_response({'success': True, 'message': 'Emergency stop executed'})
            
        elif self.path == '/mode/manual_velocity':
            vL = params.get('vL', 0.0)
            vR = params.get('vR', 0.0)
            result = demo.send_mode_command('manual_velocity', {'vL': vL, 'vR': vR})
            self.send_json_response(result)

        elif self.path == '/mode/test_motor':
            result = demo.send_mode_command('test_motor')
            self.send_json_response(result)
            
        elif self.path == '/mode/goal_reaching':
            goal_x = params.get('goal_x', 0.5)
            goal_y = params.get('goal_y', 0.5)
            result = demo.send_mode_command('goal_reaching', {'goal_x': goal_x, 'goal_y': goal_y})
            self.send_json_response(result)
            
        elif self.path == '/mode/path_tracking':
            waypoints = params.get('waypoints', [[0.5, 0.5]])
            result = demo.send_mode_command('path_tracking', {'waypoints': waypoints})
            self.send_json_response(result)
            
        else:
            self.send_error(404)
    
    def send_json_response(self, data):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())
    
    def get_html(self):
        return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>🤖 Robot Control Panel</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1400px;
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
        .status-running { background: #4CAF50; color: white; }
        .status-stopped { background: #f44336; color: white; }
        
        .btn-group {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-bottom: 20px;
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
        button:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }
        .btn-start { background: #4CAF50; color: white; }
        .btn-start:hover:not(:disabled) { background: #45a049; }
        .btn-stop { background: #f44336; color: white; }
        .btn-stop:hover:not(:disabled) { background: #da190b; }
        .btn-emergency { background: #FF5722; color: white; }
        .btn-emergency:hover:not(:disabled) { background: #E64A19; }
        .btn-mode { background: #2196F3; color: white; }
        .btn-mode:hover:not(:disabled) { background: #0b7dda; }
        
        .mode-panel {
            background: #f9f9f9;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
        }
        .mode-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        .mode-description {
            color: #666;
            margin-bottom: 15px;
            font-size: 14px;
        }
        .input-group {
            display: grid;
            grid-template-columns: auto 1fr auto;
            gap: 10px;
            align-items: center;
            margin-bottom: 10px;
        }
        .input-group label {
            font-weight: bold;
            color: #555;
        }
        input[type="number"], input[type="text"] {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .waypoint-list {
            background: white;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 10px;
            max-height: 150px;
            overflow-y: auto;
            margin-bottom: 10px;
        }
        .waypoint-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 5px;
            border-bottom: 1px solid #eee;
        }
        .waypoint-item:last-child {
            border-bottom: none;
        }
        .btn-small {
            padding: 5px 10px;
            font-size: 12px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            background: #f44336;
            color: white;
        }
        .btn-small:hover {
            background: #da190b;
        }
        
        .data-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin: 20px 0;
        }
        .data-box {
            background: #f5f5f5;
            padding: 20px;
            border-radius: 8px;
        }
        .data-label {
            color: #666;
            font-size: 12px;
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        .data-value {
            color: #333;
            font-size: 20px;
            font-weight: bold;
            font-family: 'Courier New', monospace;
        }
        .motor-indicator {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
        }
        .motor-bar {
            flex: 1;
            height: 30px;
            background: #e0e0e0;
            border-radius: 4px;
            position: relative;
            overflow: hidden;
        }
        .motor-fill {
            height: 100%;
            transition: all 0.3s;
            position: absolute;
        }
        
        .console {
            background: #1e1e1e;
            color: #d4d4d4;
            padding: 15px;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            max-height: 300px;
            overflow-y: auto;
        }
        .console-line {
            margin-bottom: 4px;
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
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }
        .live-indicator {
            display: inline-block;
            width: 10px;
            height: 10px;
            background: #4CAF50;
            border-radius: 50%;
            margin-right: 8px;
            animation: pulse 1s infinite;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- System Control Panel -->
        <div class="panel">
            <h1>🤖 Robot Control Panel</h1>
            <div id="statusBadge" class="status-badge status-stopped">● SYSTEM STOPPED</div>
            <div id="modeBadge" style="display: none; margin-left: 10px;" class="status-badge">MODE: idle</div>
            
            <div class="btn-group">
                <button id="btnStart" class="btn-start" onclick="startDemo()">▶ START SYSTEM</button>
                <button id="btnStop" class="btn-stop" onclick="stopDemo()" disabled>⏹ STOP SYSTEM</button>
                <button class="btn-emergency" onclick="emergencyStop()">🚨 EMERGENCY STOP</button>
            </div>
            
            <div id="message" class="message"></div>
        </div>
        
        <!-- Mode Selection Panel -->
        <div class="panel" id="modePanel" style="display: none;">
            <h2>🎮 Control Modes</h2>

            <!-- Mode 0: Manual Velocity Test -->
            <div class="mode-panel">
                <div class="mode-title">0️⃣ Manual Velocity Test</div>
                <div class="mode-description">Directly control motor velocities (3 second test)</div>
                <div class="input-group">
                    <label>Left Velocity:</label>
                    <input type="number" id="manualVL" value="0" step="5" min="-60" max="60">
                    <span>(-60 to +60)</span>
                </div>
                <div class="input-group">
                    <label>Right Velocity:</label>
                    <input type="number" id="manualVR" value="0" step="5" min="-60" max="60">
                    <span>(-60 to +60)</span>
                </div>
                <button class="btn-mode" onclick="runManualVelocity()">⚡ SEND (3s)</button>
            </div>

            <!-- Mode 1: Motor Test -->
            <div class="mode-panel">
                <div class="mode-title">1️⃣ Motor Test</div>
                <div class="mode-description">Test all motor movements (rotation, forward, backward)</div>
                <button class="btn-mode" onclick="runMotorTest()">🔧 RUN TEST</button>
            </div>
            
            <!-- Mode 2: Goal Reaching -->
            <div class="mode-panel">
                <div class="mode-title">2️⃣ Goal Reaching</div>
                <div class="mode-description">Navigate to a single target position (x, y)</div>
                <div class="input-group">
                    <label>Goal X:</label>
                    <input type="number" id="goalX" value="0.5" step="0.1">
                    <span>m</span>
                </div>
                <div class="input-group">
                    <label>Goal Y:</label>
                    <input type="number" id="goalY" value="0.5" step="0.1">
                    <span>m</span>
                </div>
                <button class="btn-mode" onclick="runGoalReaching()">🎯 START</button>
            </div>
            
            <!-- Mode 3: Path Tracking -->
            <div class="mode-panel">
                <div class="mode-title">3️⃣ Path Tracking</div>
                <div class="mode-description">Follow multiple waypoints in sequence</div>
                
                <div class="input-group">
                    <label>Waypoint X:</label>
                    <input type="number" id="waypointX" value="0.5" step="0.1">
                    <span>m</span>
                </div>
                <div class="input-group">
                    <label>Waypoint Y:</label>
                    <input type="number" id="waypointY" value="0.5" step="0.1">
                    <span>m</span>
                </div>
                <button class="btn-mode" onclick="addWaypoint()" style="margin-bottom: 10px;">➕ ADD WAYPOINT</button>
                
                <div class="waypoint-list" id="waypointList">
                    <div style="color: #999; text-align: center;">No waypoints added</div>
                </div>
                
                <button class="btn-mode" onclick="runPathTracking()">🛤️ START PATH</button>
            </div>
        </div>
        
        <!-- Live Data Panel -->
        <div class="panel" id="liveDataPanel" style="display: none;">
            <h2><span class="live-indicator"></span>Live Robot Data</h2>
            
            <div class="data-grid">
                <div class="data-box">
                    <div class="data-label">Robot Position (X, Y)</div>
                    <div class="data-value" id="robotPos">---, ---</div>
                </div>
                <div class="data-box">
                    <div class="data-label">Robot Rotation</div>
                    <div class="data-value" id="robotRot">---°</div>
                </div>
                <div class="data-box">
                    <div class="data-label">Control Info</div>
                    <div class="data-value" id="controlInfo" style="font-size: 14px;">---</div>
                </div>
                <div class="data-box">
                    <div class="data-label">Status</div>
                    <div class="data-value" id="statusInfo" style="font-size: 14px;">---</div>
                </div>
            </div>
            
            <h2 style="margin-top: 30px;">⚙️ Motor Velocities</h2>
            <div class="motor-indicator">
                <strong style="width: 80px;">Left:</strong>
                <div class="motor-bar">
                    <div class="motor-fill" id="motorLeftBar" style="width: 50%; background: #2196F3;"></div>
                </div>
                <span id="motorLeftValue" style="width: 80px; text-align: right; font-family: monospace;">0.0</span>
            </div>
            <div class="motor-indicator">
                <strong style="width: 80px;">Right:</strong>
                <div class="motor-bar">
                    <div class="motor-fill" id="motorRightBar" style="width: 50%; background: #FF9800;"></div>
                </div>
                <span id="motorRightValue" style="width: 80px; text-align: right; font-family: monospace;">0.0</span>
            </div>
            
            <div style="margin-top: 20px; font-size: 14px; color: #666;">
                <strong>Mode:</strong> <span id="currentMode">idle</span> | 
                <strong>FPS:</strong> <span id="demoFps">0</span> | 
                <strong>Frames:</strong> <span id="demoFrames">0</span>
            </div>
        </div>
        
        <!-- Console Panel -->
        <div class="panel">
            <h2>📋 Console Output</h2>
            <div id="console" class="console">
                <div class="console-line">System ready. Start the system to begin.</div>
            </div>
        </div>
    </div>

    <script>
        let waypoints = [];
        
        setInterval(updateStatus, 200);
        updateStatus();

        async function startDemo() {
            try {
                const response = await fetch('/start', { method: 'POST' });
                const result = await response.json();
                showMessage(result.message, result.success);
                
                if (result.success) {
                    document.getElementById('btnStart').disabled = true;
                    document.getElementById('btnStop').disabled = false;
                    document.getElementById('modePanel').style.display = 'block';
                }
            } catch (err) {
                showMessage('Start failed: ' + err, false);
            }
        }

        async function stopDemo() {
            try {
                const response = await fetch('/stop', { method: 'POST' });
                const result = await response.json();
                showMessage(result.message, result.success);
                
                if (result.success) {
                    document.getElementById('btnStart').disabled = false;
                    document.getElementById('btnStop').disabled = true;
                    document.getElementById('modePanel').style.display = 'none';
                    document.getElementById('liveDataPanel').style.display = 'none';
                }
            } catch (err) {
                showMessage('Stop failed: ' + err, false);
            }
        }

        async function emergencyStop() {
            try {
                const response = await fetch('/emergency_stop', { method: 'POST' });
                const result = await response.json();
                showMessage(result.message, result.success);
            } catch (err) {
                showMessage('Emergency stop failed: ' + err, false);
            }
        }

        async function runMotorTest() {
            try {
                const response = await fetch('/mode/test_motor', { method: 'POST' });
                const result = await response.json();
                showMessage(result.message || 'Motor test started', result.success);
            } catch (err) {
                showMessage('Motor test failed: ' + err, false);
            }
        }

        async function runGoalReaching() {
            const goalX = parseFloat(document.getElementById('goalX').value);
            const goalY = parseFloat(document.getElementById('goalY').value);
            
            try {
                const response = await fetch('/mode/goal_reaching', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({ goal_x: goalX, goal_y: goalY })
                });
                const result = await response.json();
                showMessage(result.message || `Goal reaching started: (${goalX}, ${goalY})`, result.success);
            } catch (err) {
                showMessage('Goal reaching failed: ' + err, false);
            }
        }

        function addWaypoint() {
            const x = parseFloat(document.getElementById('waypointX').value);
            const y = parseFloat(document.getElementById('waypointY').value);
            waypoints.push([x, y]);
            updateWaypointList();
        }

        function removeWaypoint(index) {
            waypoints.splice(index, 1);
            updateWaypointList();
        }

        function updateWaypointList() {
            const list = document.getElementById('waypointList');
            if (waypoints.length === 0) {
                list.innerHTML = '<div style="color: #999; text-align: center;">No waypoints added</div>';
            } else {
                list.innerHTML = waypoints.map((wp, i) => `
                    <div class="waypoint-item">
                        <span>${i + 1}. (${wp[0].toFixed(2)}, ${wp[1].toFixed(2)})</span>
                        <button class="btn-small" onclick="removeWaypoint(${i})">✖</button>
                    </div>
                `).join('');
            }
        }

        async function runPathTracking() {
            if (waypoints.length === 0) {
                showMessage('Please add at least one waypoint', false);
                return;
            }
            
            try {
                const response = await fetch('/mode/path_tracking', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({ waypoints: waypoints })
                });
                const result = await response.json();
                showMessage(result.message || `Path tracking started with ${waypoints.length} waypoints`, result.success);
            } catch (err) {
                showMessage('Path tracking failed: ' + err, false);
            }
        }

        async function runManualVelocity() {
            const vL = parseFloat(document.getElementById('manualVL').value);
            const vR = parseFloat(document.getElementById('manualVR').value);
            
            try {
                const response = await fetch('/mode/manual_velocity', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({ vL: vL, vR: vR })
                });
                const result = await response.json();
                showMessage(result.message || `Velocity test: L=${vL}, R=${vR} (3s)`, result.success);
            } catch (err) {
                showMessage('Velocity test failed: ' + err, false);
            }
        }

        async function updateStatus() {
            try {
                const response = await fetch('/status');
                const status = await response.json();
                
                // Update system badge
                const badge = document.getElementById('statusBadge');
                const btnStart = document.getElementById('btnStart');
                const btnStop = document.getElementById('btnStop');
                
                if (status.running) {
                    badge.className = 'status-badge status-running';
                    badge.innerHTML = '<span class="live-indicator"></span>SYSTEM RUNNING';
                    btnStart.disabled = true;
                    btnStop.disabled = false;
                    document.getElementById('modePanel').style.display = 'block';
                } else {
                    badge.className = 'status-badge status-stopped';
                    badge.innerHTML = '● SYSTEM STOPPED';
                    btnStart.disabled = false;
                    btnStop.disabled = true;
                    document.getElementById('modePanel').style.display = 'none';
                    document.getElementById('liveDataPanel').style.display = 'none';
                }
                
                // Update mode badge
                if (status.demo_data) {
                    const modeBadge = document.getElementById('modeBadge');
                    modeBadge.style.display = 'inline-block';
                    modeBadge.textContent = 'MODE: ' + status.demo_data.mode;
                }
                
                // Update console
                const consoleEl = document.getElementById('console');
                if (status.output && status.output.length > 0) {
                    consoleEl.innerHTML = status.output.map(line => 
                        `<div class="console-line">${escapeHtml(line)}</div>`
                    ).join('');
                    consoleEl.scrollTop = consoleEl.scrollHeight;
                }
                
                // Update live data
                if (status.demo_data) {
                    document.getElementById('liveDataPanel').style.display = 'block';
                    updateLiveData(status.demo_data);
                }
                
            } catch (err) {
                console.error('Status update failed:', err);
            }
        }

        function updateLiveData(data) {
            // Robot position
            if (data.robot) {
                document.getElementById('robotPos').textContent = 
                    `${data.robot.x.toFixed(3)}, ${data.robot.y.toFixed(3)}`;
                document.getElementById('robotRot').textContent = 
                    `${data.robot.rotation.toFixed(1)}°`;
            }
            
            // Control data
            if (data.control) {
                const wL = data.control.wL || 0;
                const wR = data.control.wR || 0;
                
                document.getElementById('motorLeftValue').textContent = wL.toFixed(1);
                document.getElementById('motorRightValue').textContent = wR.toFixed(1);
                
                // Update motor bars
                const leftPercent = ((wL + 60) / 120) * 100;
                const rightPercent = ((wR + 60) / 120) * 100;
                
                const leftBar = document.getElementById('motorLeftBar');
                const rightBar = document.getElementById('motorRightBar');
                
                leftBar.style.width = `${leftPercent}%`;
                rightBar.style.width = `${rightPercent}%`;
                
                leftBar.style.background = wL < 0 ? '#f44336' : '#2196F3';
                rightBar.style.background = wR < 0 ? '#f44336' : '#FF9800';
                
                // Control info
                let controlText = '';
                if (data.control.distance !== undefined) {
                    controlText = `Distance: ${data.control.distance.toFixed(3)} m`;
                }
                if (data.control.heading_error_deg !== undefined) {
                    controlText += ` | Heading: ${data.control.heading_error_deg.toFixed(1)}°`;
                }
                document.getElementById('controlInfo').textContent = controlText || '---';
                
                // Status info
                let statusText = '';
                if (data.control.reached) statusText = '✓ Goal Reached!';
                else if (data.control.waypoint) statusText = `Waypoint: ${data.control.waypoint}`;
                else if (data.control.status) statusText = data.control.status;
                document.getElementById('statusInfo').textContent = statusText || 'Running...';
            }
            
            // Mode and stats
            document.getElementById('currentMode').textContent = data.mode || 'idle';
            document.getElementById('demoFps').textContent = (data.fps || 0).toFixed(1);
            document.getElementById('demoFrames').textContent = data.frame_count || 0;
        }

        function showMessage(msg, success) {
            const el = document.getElementById('message');
            el.textContent = msg;
            el.className = 'message ' + (success ? 'success' : 'error');
            el.style.display = 'block';
            setTimeout(() => el.style.display = 'none', 5000);
        }

        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
    </script>
</body>
</html>
        '''


def main():
    print("\n" + "="*60)
    print("🤖 Robot Control Server (with TCP backdoor support)")
    print("="*60)
    print(f"Web server: port {SERVER_PORT}")
    print(f"Demo script: {DEMO_SCRIPT}")
    print(f"TCP backdoor: port {TCP_COMMAND_PORT}")
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
            demo.stop()
    finally:
        server.server_close()
        print("✓ Server stopped")


if __name__ == '__main__':
    main()