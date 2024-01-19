# Save this as server.py

from http.server import SimpleHTTPRequestHandler
from socketserver import TCPServer
from http import HTTPStatus

class RedirectHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        # Redirect all GET requests to the Slido link
        self.send_response(HTTPStatus.FOUND)
        self.send_header("Location", "https://app.sli.do/event/ai2YkxtEj12HosChouNHod")
        self.end_headers()

# Define the port for the Python server
PORT = 8000

# Create an HTTP server with the custom RedirectHandler
with TCPServer(("", PORT), RedirectHandler) as httpd:
    print(f"Serving at http://localhost:{PORT}")

    # Start the server
    httpd.serve_forever()
