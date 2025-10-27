"""
Simple Pi Power Control
- Shutdown button
- Reboot button
"""

from http.server import SimpleHTTPRequestHandler, HTTPServer
import os
import json
import subprocess
import threading

# Configuration
SERVER_PORT = 8069  #

def log_suppression(self, format, *args):
    """Suppress HTTP request logging"""
    pass

class PowerControlHandler(SimpleHTTPRequestHandler):
    log_message = log_suppression
    
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(self.get_html().encode())
        else:
            self.send_error(404)
    
    def do_POST(self):
        if self.path == '/shutdown':
            self.send_json_response({'success': True, 'message': 'Shutting down...'})
            # Execute shutdown with subprocess
            def execute_shutdown():
                try:
                    subprocess.run(['shutdown'], check=True)
                except Exception as e:
                    print(f"Shutdown error: {e}")
            threading.Timer(1.0, execute_shutdown).start()
            
        elif self.path == '/reboot':
            self.send_json_response({'success': True, 'message': 'Rebooting...'})
            # Execute reboot with subprocess
            def execute_reboot():
                try:
                    subprocess.run(['reboot'], check=True)
                except Exception as e:
                    print(f"Reboot error: {e}")
            threading.Timer(1.0, execute_reboot).start()
            
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
    <title>🔴 Pi Power Control</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .panel {
            background: white;
            border-radius: 20px;
            padding: 50px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            text-align: center;
            max-width: 500px;
            width: 100%;
        }
        h1 {
            color: #333;
            margin-bottom: 15px;
            font-size: 32px;
        }
        .warning {
            background: #fff3cd;
            border: 2px solid #ffc107;
            color: #856404;
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
            font-weight: bold;
        }
        .btn-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 30px;
        }
        button {
            padding: 30px 20px;
            border: none;
            border-radius: 15px;
            font-size: 20px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            text-transform: uppercase;
        }
        button:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
        }
        button:active {
            transform: translateY(-2px);
        }
        .btn-shutdown {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            color: white;
        }
        .btn-shutdown:hover {
            box-shadow: 0 10px 25px rgba(231,76,60,0.5);
        }
        .btn-reboot {
            background: linear-gradient(135deg, #f39c12 0%, #e67e22 100%);
            color: white;
        }
        .btn-reboot:hover {
            box-shadow: 0 10px 25px rgba(243,156,18,0.5);
        }
        .message {
            margin-top: 20px;
            padding: 15px;
            border-radius: 10px;
            display: none;
            font-weight: bold;
        }
        .message.success {
            background: #d4edda;
            color: #155724;
            border: 2px solid #c3e6cb;
        }
        .icon {
            font-size: 60px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="panel">
        <div class="icon">🔴</div>
        <h1>Pi Power Control</h1>
        
        <div class="warning">
            ⚠️ WARNING: These actions will immediately affect the Raspberry Pi!
        </div>
        
        <div class="btn-group">
            <button class="btn-shutdown" onclick="shutdown()">
                🔌<br>SHUTDOWN
            </button>
            <button class="btn-reboot" onclick="reboot()">
                🔄<br>REBOOT
            </button>
        </div>
        
        <div id="message" class="message"></div>
    </div>

    <script>
        async function shutdown() {
            if (!confirm('⚠️ SHUTDOWN the Raspberry Pi?\n\nThis will turn off the system!')) {
                return;
            }
            
            if (!confirm('Are you REALLY sure? This cannot be undone!')) {
                return;
            }
            
            try {
                const response = await fetch('/shutdown', { method: 'POST' });
                const result = await response.json();
                showMessage(result.message + ' See you later! 👋');
                
                // Disable buttons
                document.querySelectorAll('button').forEach(btn => btn.disabled = true);
                
            } catch (err) {
                showMessage('Shutdown command sent (connection may be lost)');
            }
        }

        async function reboot() {
            if (!confirm('⚠️ REBOOT the Raspberry Pi?\n\nThis will restart the system!')) {
                return;
            }
            
            try {
                const response = await fetch('/reboot', { method: 'POST' });
                const result = await response.json();
                showMessage(result.message + ' Back in ~30 seconds! 🔄');
                
                // Disable buttons
                document.querySelectorAll('button').forEach(btn => btn.disabled = true);
                
                // Start countdown
                let seconds = 30;
                const countdown = setInterval(() => {
                    seconds--;
                    if (seconds <= 0) {
                        clearInterval(countdown);
                        showMessage('Reboot should be complete. Try refreshing!');
                    } else {
                        showMessage(`Rebooting... (~${seconds}s remaining)`);
                    }
                }, 1000);
                
            } catch (err) {
                showMessage('Reboot command sent (connection may be lost)');
            }
        }

        function showMessage(msg) {
            const el = document.getElementById('message');
            el.textContent = msg;
            el.className = 'message success';
            el.style.display = 'block';
        }
    </script>
</body>
</html>
        '''

def main():
    print("\n" + "="*60)
    print("🔴 Pi Power Control Server")
    print("="*60)
    print(f"Server running on port {SERVER_PORT}")
    print(f"\nAccess from browser:")
    print(f"  http://raspberrypi.local:{SERVER_PORT}")
    print(f"  http://192.168.0.X:{SERVER_PORT}")
    print("\n⚠️  WARNING: This server allows shutdown/reboot!")
    print("Press Ctrl+C to stop server")
    print("="*60 + "\n")
    
    server = HTTPServer(('0.0.0.0', SERVER_PORT), PowerControlHandler)
    
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n\n✓ Stopping server...")
    finally:
        server.server_close()
        print("✓ Server stopped")

if __name__ == '__main__':
    main()