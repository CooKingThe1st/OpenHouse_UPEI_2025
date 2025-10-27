from http.server import SimpleHTTPRequestHandler, HTTPServer
import cgi, os

class UploadHandler(SimpleHTTPRequestHandler):
    def do_POST(self):
        form = cgi.FieldStorage(
            fp=self.rfile,
            headers=self.headers,
            environ={'REQUEST_METHOD': 'POST',
                     'CONTENT_TYPE': self.headers['Content-Type']})
        for field in form.keys():
            field_item = form[field]
            if field_item.filename:
                filename = os.path.basename(field_item.filename)
                with open(filename, 'wb') as f:
                    f.write(field_item.file.read())
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b'File uploaded successfully')
                return

if __name__ == '__main__':
    server = HTTPServer(('', 8000), UploadHandler)
    print("Serving at port 8000...")
    server.serve_forever()
