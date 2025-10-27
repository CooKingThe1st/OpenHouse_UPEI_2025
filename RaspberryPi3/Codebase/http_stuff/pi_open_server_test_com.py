"""
Raspberry Pi Communication Test Server
- Test OptiTrack connection
- View live robot data
- Monitor communication status
- All via web interface
"""

from http.server import SimpleHTTPRequestHandler, HTTPServer
import socket
import threading
import json
import time

# Configuration
SERVER_PORT = 8001
OPTITRACK_SERVER_IP = "192.168.0.100"
OPTITRACK_PORT = 5400
BUFFER_SIZE = 8192

class OptiTrackMonitor:
    """Monitors OptiTrack connection and data"""
    def __init__(self):
        self.sock = None
        self.connected = False
        self.running = False
        self.thread = None
        
        # Statistics
        self.stats = {
            'connected': False,
            'total_frames': 0,
            'fps': 0.0,
            'last_update': 0,
            'robots': [],
            'raw_data': '',
            'error': None,
            'start_time': None
        }
        
        self.frame_count = 0
        self.start_time = None
        
    def connect(self):
        """Connect to OptiTrack server"""
        try:
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.sock.settimeout(5.0)
            
            self.sock.connect((OPTITRACK_SERVER_IP, OPTITRACK_PORT))
            
            self.connected = True
            self.sock.settimeout(0.5)  # ← Changed from 0.1 to 0.5 (same as client_rasp_opti)
            self.stats['connected'] = True
            self.stats['error'] = None
            self.stats['start_time'] = time.time()
            
            return {'success': True, 'message': f'Connected to {OPTITRACK_SERVER_IP}:{OPTITRACK_PORT}'}
            
        except Exception as e:
            self.stats['error'] = str(e)
            return {'success': False, 'message': f'Connection failed: {e}'}
    
    def disconnect(self):
        """Disconnect from OptiTrack server"""
        self.running = False
        if self.sock:
            try:
                self.sock.close()
            except:
                pass
        self.connected = False
        self.stats['connected'] = False
        return {'success': True, 'message': 'Disconnected'}
    
    def start_monitoring(self):
        """Start monitoring thread"""
        if self.running:
            return {'success': False, 'message': 'Already monitoring'}
        
        if not self.connected:
            result = self.connect()
            if not result['success']:
                return result
        
        self.running = True
        self.frame_count = 0
        self.start_time = time.time()
        
        self.thread = threading.Thread(target=self._monitor_loop, daemon=True)
        self.thread.start()
        
        return {'success': True, 'message': 'Monitoring started'}
    
    def stop_monitoring(self):
        """Stop monitoring thread"""
        self.running = False
        if self.thread:
            self.thread.join(timeout=1)
        return {'success': True, 'message': 'Monitoring stopped'}
    
    def _monitor_loop(self):
        """Main monitoring loop - adapted from client_rasp_opti.py"""
        while self.running:
            try:
                # Receive data
                data = self.sock.recv(BUFFER_SIZE)
                
                if not data:
                    self.stats['error'] = 'Server disconnected'
                    self.connected = False
                    self.stats['connected'] = False
                    break
                
                # Decode and clean data (same as client_rasp_opti)
                decoded = data.decode('utf-8', errors='ignore')
                cleaned = decoded.replace('\x00', '').strip()
                
                # Update stats
                self.frame_count += 1
                current_time = time.time()
                elapsed = current_time - self.start_time
                
                self.stats['total_frames'] = self.frame_count
                self.stats['fps'] = self.frame_count / elapsed if elapsed > 0 else 0
                self.stats['last_update'] = current_time
                self.stats['raw_data'] = cleaned[:500]  # First 500 chars
                
                # Parse robot data (same parsing as client_rasp_opti)
                robots = self._parse_data(cleaned)
                self.stats['robots'] = robots
                
            except socket.timeout:
                # Normal timeout, continue
                continue
            except Exception as e:
                self.stats['error'] = str(e)
                break
        
        self.running = False
    
    def _parse_data(self, raw_data):
        """
        Parse robot data - EXACTLY like client_rasp_opti.py
        Format: "id,x,y,z,rotation;id,x,y,z,rotation;..."
        Example: "1,0.6730,-0.0890,0.0040,-80.6900;2,0.6410,0.5440,0.2130,148.7700;"
        """
        if not raw_data or len(raw_data) < 5:
            return []
        
        try:
            # Split by semicolon - each part is one robot
            parts = raw_data.split(';')
            
            robots = []
            seen_robot_ids = set()  # ← Track unique robot IDs to avoid duplicates
            
            # Process each semicolon-separated part (each is one robot)
            for part in parts:
                part = part.strip()
                if not part:
                    continue
                
                # Split by comma to get values
                values = [v.strip() for v in part.split(',')]
                
                try:
                    # New format: id, x, y, z, rotation (5 values)
                    if len(values) == 5:
                        robot_id = int(values[0])
                        x = float(values[1])
                        y = float(values[2])
                        z = float(values[3])
                        rotation = float(values[4])
                        
                        # ← Skip if we've already seen this robot ID (prevents duplicates!)
                        if robot_id in seen_robot_ids:
                            continue
                        
                        # ← Skip if any value is NaN or invalid
                        if any(v != v for v in [x, y, z, rotation]):  # NaN check
                            continue
                        
                        seen_robot_ids.add(robot_id)
                        
                        robot = {
                            'id': robot_id,
                            'type': 'robot',
                            'x': x,
                            'y': y,
                            'z': z,
                            'rotation': rotation
                        }
                        robots.append(robot)
                    
                except (ValueError, IndexError):
                    # Skip invalid data
                    continue
            
            # Sort robots by ID for consistent display
            robots.sort(key=lambda r: r['id'])
            
            return robots
            
        except Exception as e:
            return []
    
    def get_status(self):
        """Get current status"""
        return self.stats

# Global monitor instance
monitor = OptiTrackMonitor()

class CommTestHandler(SimpleHTTPRequestHandler):
    """HTTP request handler for communication test"""
    
    def do_GET(self):
        """Handle GET requests"""
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(self.get_html().encode())
            
        elif self.path == '/status':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            status = monitor.get_status()
            self.wfile.write(json.dumps(status).encode())
            
        else:
            self.send_error(404)
    
    def do_POST(self):
        """Handle POST requests"""
        if self.path == '/connect':
            result = monitor.connect()
            self.send_json_response(result)
            
        elif self.path == '/disconnect':
            result = monitor.disconnect()
            self.send_json_response(result)
            
        elif self.path == '/start':
            result = monitor.start_monitoring()
            self.send_json_response(result)
            
        elif self.path == '/stop':
            result = monitor.stop_monitoring()
            self.send_json_response(result)
            
        else:
            self.send_error(404)
    
    def send_json_response(self, data):
        """Send JSON response"""
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())
    
    def get_html(self):
        """Generate HTML interface"""
        return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>🌐 OptiTrack Communication Test</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
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
        .status-connected {
            background: #4CAF50;
            color: white;
        }
        .status-disconnected {
            background: #f44336;
            color: white;
        }
        .btn-group {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
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
        .btn-connect { background: #4CAF50; color: white; }
        .btn-connect:hover { background: #45a049; }
        .btn-disconnect { background: #f44336; color: white; }
        .btn-disconnect:hover { background: #da190b; }
        .btn-start { background: #2196F3; color: white; }
        .btn-start:hover { background: #0b7dda; }
        .btn-stop { background: #FF9800; color: white; }
        .btn-stop:hover { background: #e68900; }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        .stat-box {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }
        .stat-label {
            color: #666;
            font-size: 12px;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        .stat-value {
            color: #333;
            font-size: 24px;
            font-weight: bold;
        }
        .robot-list {
            max-height: 400px;
            overflow-y: auto;
        }
        .robot-card {
            background: #f9f9f9;
            border-left: 4px solid #2196F3;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 4px;
        }
        .robot-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .robot-data {
            font-family: 'Courier New', monospace;
            font-size: 13px;
            color: #555;
        }
        .raw-data {
            background: #1e1e1e;
            color: #d4d4d4;
            padding: 15px;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            overflow-x: auto;
            max-height: 200px;
            overflow-y: auto;
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
        <div class="panel">
            <h1>🌐 OptiTrack Communication Test</h1>
            <div id="statusBadge" class="status-badge status-disconnected">● DISCONNECTED</div>
            
            <h2>🎮 Connection Controls</h2>
            <div class="btn-group">
                <button class="btn-connect" onclick="connectOptiTrack()">🔌 CONNECT</button>
                <button class="btn-disconnect" onclick="disconnectOptiTrack()">🔌 DISCONNECT</button>
                <button class="btn-start" onclick="startMonitoring()">▶ START MONITORING</button>
                <button class="btn-stop" onclick="stopMonitoring()">⏹ STOP MONITORING</button>
            </div>
            
            <div id="message" class="message"></div>
            
            <h2>📊 Statistics</h2>
            <div class="stats-grid">
                <div class="stat-box">
                    <div class="stat-label">Total Frames</div>
                    <div class="stat-value" id="totalFrames">0</div>
                </div>
                <div class="stat-box">
                    <div class="stat-label">FPS</div>
                    <div class="stat-value" id="fps">0.0</div>
                </div>
                <div class="stat-box">
                    <div class="stat-label">Robots Detected</div>
                    <div class="stat-value" id="robotCount">0</div>
                </div>
                <div class="stat-box">
                    <div class="stat-label">Uptime</div>
                    <div class="stat-value" id="uptime">0s</div>
                </div>
            </div>
        </div>
        
        <div class="panel">
            <h2>🤖 Detected Robots (Format: id,x,y,z,rotation)</h2>
            <div id="robotList" class="robot-list">
                <p style="color: #999; text-align: center; padding: 20px;">
                    No robots detected. Start monitoring to see live data.
                </p>
            </div>
        </div>
        
        <div class="panel">
            <h2>📡 Raw Data Stream</h2>
            <div id="rawData" class="raw-data">
                Waiting for data...
            </div>
        </div>
    </div>

    <script>
        setInterval(updateStatus, 200);  // Update 5 times per second
        updateStatus();

        async function connectOptiTrack() {
            try {
                const response = await fetch('/connect', { method: 'POST' });
                const result = await response.json();
                showMessage(result.message, result.success);
            } catch (err) {
                showMessage('Connection failed: ' + err, false);
            }
        }

        async function disconnectOptiTrack() {
            try {
                const response = await fetch('/disconnect', { method: 'POST' });
                const result = await response.json();
                showMessage(result.message, result.success);
            } catch (err) {
                showMessage('Disconnect failed: ' + err, false);
            }
        }

        async function startMonitoring() {
            try {
                const response = await fetch('/start', { method: 'POST' });
                const result = await response.json();
                showMessage(result.message, result.success);
            } catch (err) {
                showMessage('Start failed: ' + err, false);
            }
        }

        async function stopMonitoring() {
            try {
                const response = await fetch('/stop', { method: 'POST' });
                const result = await response.json();
                showMessage(result.message, result.success);
            } catch (err) {
                showMessage('Stop failed: ' + err, false);
            }
        }

        async function updateStatus() {
            try {
                const response = await fetch('/status');
                const status = await response.json();
                
                // Update badge
                const badge = document.getElementById('statusBadge');
                if (status.connected) {
                    badge.className = 'status-badge status-connected';
                    badge.innerHTML = '<span class="live-indicator"></span>CONNECTED';
                } else {
                    badge.className = 'status-badge status-disconnected';
                    badge.innerHTML = '● DISCONNECTED';
                }
                
                // Update stats
                document.getElementById('totalFrames').textContent = status.total_frames || 0;
                document.getElementById('fps').textContent = (status.fps || 0).toFixed(1);
                document.getElementById('robotCount').textContent = status.robots ? status.robots.length : 0;
                
                // Update uptime
                if (status.start_time) {
                    const uptime = Date.now()/1000 - status.start_time;
                    document.getElementById('uptime').textContent = formatUptime(uptime);
                } else {
                    document.getElementById('uptime').textContent = '0s';
                }
                
                // Update robot list
                updateRobotList(status.robots || []);
                
                // Update raw data
                if (status.raw_data) {
                    document.getElementById('rawData').textContent = status.raw_data;
                }
                
                // Show error if any
                if (status.error) {
                    showMessage('Error: ' + status.error, false);
                }
                
            } catch (err) {
                console.error('Status update failed:', err);
            }
        }

        function updateRobotList(robots) {
            const listEl = document.getElementById('robotList');
            
            if (robots.length === 0) {
                listEl.innerHTML = '<p style="color: #999; text-align: center; padding: 20px;">No robots detected</p>';
                return;
            }
            
            let html = '';
            robots.forEach(robot => {
                html += `
                    <div class="robot-card">
                        <div class="robot-header">
                            <strong>🤖 Robot ID ${robot.id}</strong>
                            <span style="color: #4CAF50;">● ACTIVE</span>
                        </div>
                        <div class="robot-data">
                            <strong>Position:</strong> (${robot.x.toFixed(4)}, ${robot.y.toFixed(4)}, ${robot.z.toFixed(4)})<br>
                            <strong>Rotation:</strong> ${robot.rotation.toFixed(2)}°
                        </div>
                    </div>
                `;
            });
            
            listEl.innerHTML = html;
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
            if (h > 0) return `${h}h ${m}m ${s}s`;
            if (m > 0) return `${m}m ${s}s`;
            return `${s}s`;
        }
    </script>
</body>
</html>
        '''

def main():
    print("\n" + "="*60)
    print("🌐 OptiTrack Communication Test Server")
    print("="*60)
    print(f"Server running on port {SERVER_PORT}")
    print(f"OptiTrack server: {OPTITRACK_SERVER_IP}:{OPTITRACK_PORT}")
    print(f"\nDATA FORMAT: id,x,y,z,rotation;id,x,y,z,rotation;...")
    print(f"\nAccess from browser:")
    print(f"  http://raspberrypi.local:{SERVER_PORT}")
    print(f"  http://192.168.0.X:{SERVER_PORT}")
    print("\nPress Ctrl+C to stop server")
    print("="*60 + "\n")
    
    server = HTTPServer(('0.0.0.0', SERVER_PORT), CommTestHandler)
    
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n\n✓ Stopping server...")
        if monitor.running:
            monitor.stop_monitoring()
        if monitor.connected:
            monitor.disconnect()
    finally:
        server.server_close()
        print("✓ Server stopped")

if __name__ == '__main__':
    main()