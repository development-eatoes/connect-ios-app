import Foundation
import SwiftUI
import HTTPServer

// Start the Replit HTTP server to serve the SwiftUI app
print("Starting Connect app server...")

class AppServer {
    func start() {
        print("Connect app is now running on port 5000")
        print("Visit: http://localhost:5000")
        
        // Keep the application running
        RunLoop.main.run()
    }
}

// Initialize and start the HTTP server
let server = AppServer()
let httpServer = HTTPServer()

// Configure routes with descriptions for native app fallback
httpServer.registerRoute(method: .GET, path: "/") { request in
    return HTTPResponse(statusCode: 200, body: renderAppFallbackPage(title: "Connect App", message: "This is a native Swift/SwiftUI app. Please run the app on an iOS device or simulator."))
}

// Start the server
do {
    try httpServer.start(port: 5000)
    server.start()
} catch {
    print("Error starting server: \(error)")
}

// Helper function to render a simple HTML page for fallback
func renderAppFallbackPage(title: String, message: String) -> String {
    return """
    <!DOCTYPE html>
    <html>
    <head>
        <title>\(title)</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                background-color: #000;
                color: #fff;
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                text-align: center;
            }
            .container {
                width: 100%;
                max-width: 480px;
                padding: 24px;
            }
            h1 {
                font-size: 28px;
                font-weight: bold;
                margin-bottom: 16px;
            }
            p {
                font-size: 16px;
                line-height: 1.5;
                margin-bottom: 24px;
            }
            .app-icon {
                width: 120px;
                height: 120px;
                background-color: #007aff;
                border-radius: 24px;
                margin: 0 auto 24px;
                display: flex;
                justify-content: center;
                align-items: center;
                font-size: 48px;
                font-weight: bold;
                color: white;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="app-icon">C</div>
            <h1>\(title)</h1>
            <p>\(message)</p>
            <p>The digital menu demonstrates a clean, intuitive interface with category views and detailed item pages.</p>
        </div>
    </body>
    </html>
    """
}
