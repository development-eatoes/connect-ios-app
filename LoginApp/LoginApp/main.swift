import Foundation
import HTTPServer

// This file serves as the entry point for our LoginApp.
// In a real iOS app, this would be replaced by the AppDelegate.swift
// and SceneDelegate.swift files.

print("Starting LoginApp server...")

// Simple HTTP server to serve the app interface
class SimpleHTTPServer {
    func start() {
        print("LoginApp is now running on port 5000")
        print("Visit: http://localhost:5000")
        
        // Keep the application running
        RunLoop.main.run()
    }
    
    func renderLoginPage() -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <title>LoginApp - Login</title>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                    background-color: #f9f9f9;
                    margin: 0;
                    padding: 0;
                    display: flex;
                    justify-content: center;
                    min-height: 100vh;
                }
                .container {
                    width: 100%;
                    max-width: 480px;
                    padding: 24px;
                }
                .header {
                    text-align: center;
                    margin-bottom: 32px;
                    margin-top: 40px;
                }
                .header h1 {
                    font-size: 28px;
                    font-weight: bold;
                    margin-bottom: 8px;
                }
                .header p {
                    color: #666;
                    font-size: 16px;
                    margin-top: 0;
                }
                .form-group {
                    margin-bottom: 24px;
                }
                .form-group label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: 600;
                }
                .form-group input {
                    width: 100%;
                    padding: 12px;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                    font-size: 16px;
                    box-sizing: border-box;
                }
                .error {
                    color: #ff3b30;
                    font-size: 14px;
                    margin-top: 4px;
                }
                .btn-primary {
                    background-color: #007aff;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    padding: 14px;
                    font-size: 16px;
                    font-weight: 600;
                    width: 100%;
                    cursor: pointer;
                    transition: background-color 0.2s;
                }
                .btn-primary:hover {
                    background-color: #0062cc;
                }
                .btn-primary:disabled {
                    background-color: #cccccc;
                    cursor: not-allowed;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>Welcome</h1>
                    <p>Enter your mobile number to continue</p>
                </div>
                
                <form id="loginForm">
                    <div class="form-group">
                        <label for="phoneNumber">Mobile Number</label>
                        <input type="tel" id="phoneNumber" name="phoneNumber" placeholder="Enter 10-digit number" pattern="[0-9]{10}" required>
                        <div id="phoneError" class="error"></div>
                    </div>
                    
                    <button type="submit" class="btn-primary" id="loginButton">Login</button>
                </form>
            </div>
            
            <script>
                document.getElementById('loginForm').addEventListener('submit', function(event) {
                    event.preventDefault();
                    
                    const phoneNumber = document.getElementById('phoneNumber').value;
                    const phoneError = document.getElementById('phoneError');
                    const loginButton = document.getElementById('loginButton');
                    
                    // Validate phone number
                    if (!/^[0-9]{10}$/.test(phoneNumber)) {
                        phoneError.textContent = 'Please enter a valid 10-digit phone number';
                        return;
                    }
                    
                    phoneError.textContent = '';
                    loginButton.disabled = true;
                    loginButton.textContent = 'Loading...';
                    
                    // Simulate API call
                    setTimeout(() => {
                        window.location.href = '/otp';
                    }, 1500);
                });
            </script>
        </body>
        </html>
        """
    }
    
    func renderOTPPage() -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <title>LoginApp - Verification</title>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                    background-color: #f9f9f9;
                    margin: 0;
                    padding: 0;
                    display: flex;
                    justify-content: center;
                    min-height: 100vh;
                }
                .container {
                    width: 100%;
                    max-width: 480px;
                    padding: 24px;
                }
                .header {
                    text-align: center;
                    margin-bottom: 32px;
                    margin-top: 40px;
                }
                .header h1 {
                    font-size: 28px;
                    font-weight: bold;
                    margin-bottom: 8px;
                }
                .header p {
                    color: #666;
                    font-size: 16px;
                    margin-top: 0;
                }
                .otp-container {
                    display: flex;
                    justify-content: space-between;
                    margin-bottom: 24px;
                }
                .otp-input {
                    width: 48px;
                    height: 48px;
                    font-size: 20px;
                    text-align: center;
                    border: 1px solid #ddd;
                    border-radius: 8px;
                }
                .error {
                    color: #ff3b30;
                    font-size: 14px;
                    margin-top: 4px;
                    text-align: center;
                }
                .resend {
                    text-align: center;
                    margin: 16px 0 32px;
                    color: #666;
                }
                .resend button {
                    background: none;
                    border: none;
                    color: #007aff;
                    font-size: 16px;
                    cursor: pointer;
                    padding: 0;
                }
                .btn-primary {
                    background-color: #007aff;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    padding: 14px;
                    font-size: 16px;
                    font-weight: 600;
                    width: 100%;
                    cursor: pointer;
                    transition: background-color 0.2s;
                }
                .btn-primary:hover {
                    background-color: #0062cc;
                }
                .btn-primary:disabled {
                    background-color: #cccccc;
                    cursor: not-allowed;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>Verification</h1>
                    <p>Enter the 6-digit code sent to your mobile number</p>
                </div>
                
                <form id="otpForm">
                    <div class="otp-container">
                        <input type="text" maxlength="1" class="otp-input" data-index="1" autofocus>
                        <input type="text" maxlength="1" class="otp-input" data-index="2">
                        <input type="text" maxlength="1" class="otp-input" data-index="3">
                        <input type="text" maxlength="1" class="otp-input" data-index="4">
                        <input type="text" maxlength="1" class="otp-input" data-index="5">
                        <input type="text" maxlength="1" class="otp-input" data-index="6">
                    </div>
                    
                    <div id="otpError" class="error"></div>
                    
                    <div class="resend">
                        <span id="timerText">Resend code in <span id="timer">30</span>s</span>
                        <button type="button" id="resendButton" style="display: none;">Resend OTP</button>
                    </div>
                    
                    <button type="submit" class="btn-primary" id="verifyButton" disabled>Verify OTP</button>
                </form>
            </div>
            
            <script>
                // Handle OTP input fields
                const otpInputs = document.querySelectorAll('.otp-input');
                const verifyButton = document.getElementById('verifyButton');
                let otpComplete = false;
                
                otpInputs.forEach(input => {
                    input.addEventListener('input', function() {
                        if (this.value.length === this.maxLength) {
                            const nextIndex = parseInt(this.dataset.index) + 1;
                            const nextInput = document.querySelector(`.otp-input[data-index="${nextIndex}"]`);
                            
                            if (nextInput) {
                                nextInput.focus();
                            }
                        }
                        
                        // Check if all inputs are filled
                        checkOTPComplete();
                    });
                    
                    input.addEventListener('keydown', function(e) {
                        if (e.key === 'Backspace' && this.value === '') {
                            const prevIndex = parseInt(this.dataset.index) - 1;
                            const prevInput = document.querySelector(`.otp-input[data-index="${prevIndex}"]`);
                            
                            if (prevInput) {
                                prevInput.focus();
                            }
                        }
                    });
                });
                
                function checkOTPComplete() {
                    otpComplete = Array.from(otpInputs).every(input => input.value.length === 1);
                    verifyButton.disabled = !otpComplete;
                }
                
                // Handle timer and resend button
                let timeRemaining = 30;
                const timer = document.getElementById('timer');
                const timerText = document.getElementById('timerText');
                const resendButton = document.getElementById('resendButton');
                
                const countdownInterval = setInterval(() => {
                    timeRemaining--;
                    timer.textContent = timeRemaining;
                    
                    if (timeRemaining <= 0) {
                        clearInterval(countdownInterval);
                        timerText.style.display = 'none';
                        resendButton.style.display = 'inline';
                    }
                }, 1000);
                
                resendButton.addEventListener('click', function() {
                    resendButton.style.display = 'none';
                    timerText.style.display = 'inline';
                    timeRemaining = 30;
                    timer.textContent = timeRemaining;
                    
                    const countdownInterval = setInterval(() => {
                        timeRemaining--;
                        timer.textContent = timeRemaining;
                        
                        if (timeRemaining <= 0) {
                            clearInterval(countdownInterval);
                            timerText.style.display = 'none';
                            resendButton.style.display = 'inline';
                        }
                    }, 1000);
                });
                
                // Handle form submission
                document.getElementById('otpForm').addEventListener('submit', function(event) {
                    event.preventDefault();
                    
                    if (!otpComplete) return;
                    
                    const otp = Array.from(otpInputs).map(input => input.value).join('');
                    verifyButton.disabled = true;
                    verifyButton.textContent = 'Verifying...';
                    
                    // Simulate API call
                    setTimeout(() => {
                        window.location.href = '/menu';
                    }, 1500);
                });
            </script>
        </body>
        </html>
        """
    }
    
    func renderMenuPage() -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <title>LoginApp - Menu</title>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                    background-color: #f9f9f9;
                    margin: 0;
                    padding: 0;
                }
                .container {
                    max-width: 800px;
                    margin: 0 auto;
                    padding: 24px;
                }
                header {
                    padding: 16px 0;
                    border-bottom: 1px solid #eee;
                    margin-bottom: 24px;
                }
                header h1 {
                    margin: 0;
                    font-size: 24px;
                }
                .category {
                    margin-bottom: 32px;
                }
                .category-title {
                    font-size: 20px;
                    font-weight: 600;
                    margin-bottom: 16px;
                    padding-bottom: 8px;
                    border-bottom: 1px solid #eee;
                }
                .menu-items {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
                    gap: 16px;
                }
                .menu-item {
                    background: white;
                    border-radius: 8px;
                    overflow: hidden;
                    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                    transition: transform 0.2s, box-shadow 0.2s;
                    cursor: pointer;
                }
                .menu-item:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                }
                .menu-item-image {
                    height: 160px;
                    background-color: #eee;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: #aaa;
                    font-size: 16px;
                }
                .menu-item-content {
                    padding: 16px;
                }
                .menu-item-title {
                    font-weight: 600;
                    margin: 0 0 8px 0;
                }
                .menu-item-price {
                    color: #007aff;
                    font-weight: 600;
                    margin: 0;
                }
                .menu-item-description {
                    color: #666;
                    font-size: 14px;
                    margin: 8px 0;
                    line-height: 1.4;
                }
                .badge {
                    display: inline-block;
                    padding: 4px 8px;
                    border-radius: 20px;
                    font-size: 12px;
                    font-weight: 600;
                    margin-top: 8px;
                }
                .badge-success {
                    background-color: #dffcef;
                    color: #00a878;
                }
                .badge-error {
                    background-color: #ffeeee;
                    color: #ff3b30;
                }
                .success-message {
                    text-align: center;
                    background-color: #dffcef;
                    color: #00a878;
                    padding: 16px;
                    border-radius: 8px;
                    margin-bottom: 24px;
                    font-weight: 600;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <header>
                    <h1>Digital Menu</h1>
                </header>
                
                <div class="success-message">
                    Login successful! Welcome to the Digital Menu.
                </div>
                
                <div class="category">
                    <h2 class="category-title">Appetizers</h2>
                    <div class="menu-items">
                        <div class="menu-item">
                            <div class="menu-item-image">Image</div>
                            <div class="menu-item-content">
                                <h3 class="menu-item-title">Spring Rolls</h3>
                                <p class="menu-item-price">$8.99</p>
                                <p class="menu-item-description">Crispy rolls filled with vegetables and served with sweet chili sauce.</p>
                                <div class="badge badge-success">Available</div>
                            </div>
                        </div>
                        <div class="menu-item">
                            <div class="menu-item-image">Image</div>
                            <div class="menu-item-content">
                                <h3 class="menu-item-title">Bruschetta</h3>
                                <p class="menu-item-price">$7.99</p>
                                <p class="menu-item-description">Toasted bread topped with tomatoes, garlic, and basil.</p>
                                <div class="badge badge-success">Available</div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="category">
                    <h2 class="category-title">Main Course</h2>
                    <div class="menu-items">
                        <div class="menu-item">
                            <div class="menu-item-image">Image</div>
                            <div class="menu-item-content">
                                <h3 class="menu-item-title">Grilled Salmon</h3>
                                <p class="menu-item-price">$24.99</p>
                                <p class="menu-item-description">Fresh salmon with asparagus and lemon butter sauce.</p>
                                <div class="badge badge-success">Available</div>
                            </div>
                        </div>
                        <div class="menu-item">
                            <div class="menu-item-image">Image</div>
                            <div class="menu-item-content">
                                <h3 class="menu-item-title">Beef Wellington</h3>
                                <p class="menu-item-price">$32.99</p>
                                <p class="menu-item-description">Tender beef wrapped in pastry with mushroom duxelles.</p>
                                <div class="badge badge-error">Unavailable</div>
                            </div>
                        </div>
                        <div class="menu-item">
                            <div class="menu-item-image">Image</div>
                            <div class="menu-item-content">
                                <h3 class="menu-item-title">Vegetable Curry</h3>
                                <p class="menu-item-price">$18.99</p>
                                <p class="menu-item-description">Mixed vegetables in a spicy coconut curry sauce with rice.</p>
                                <div class="badge badge-success">Available</div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="category">
                    <h2 class="category-title">Desserts</h2>
                    <div class="menu-items">
                        <div class="menu-item">
                            <div class="menu-item-image">Image</div>
                            <div class="menu-item-content">
                                <h3 class="menu-item-title">Chocolate Lava Cake</h3>
                                <p class="menu-item-price">$9.99</p>
                                <p class="menu-item-description">Warm chocolate cake with a molten center, served with ice cream.</p>
                                <div class="badge badge-success">Available</div>
                            </div>
                        </div>
                        <div class="menu-item">
                            <div class="menu-item-image">Image</div>
                            <div class="menu-item-content">
                                <h3 class="menu-item-title">New York Cheesecake</h3>
                                <p class="menu-item-price">$8.99</p>
                                <p class="menu-item-description">Classic cheesecake with graham cracker crust and berry compote.</p>
                                <div class="badge badge-success">Available</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </body>
        </html>
        """
    }
}

// Create a simple HTTP server
let server = SimpleHTTPServer()

// Setup HTTP server
let httpServer = HTTPServer()
httpServer.listenAddressIPv4 = "0.0.0.0"
httpServer.listenPort = 5000

// Add handlers for different routes
httpServer.route(.GET, "/") { request, responseWriter in
    let response = server.renderLoginPage()
    
    responseWriter.writeHeader(status: .ok)
    responseWriter.writeBody(response)
    responseWriter.done()
}

httpServer.route(.GET, "/otp") { request, responseWriter in
    let response = server.renderOTPPage()
    
    responseWriter.writeHeader(status: .ok)
    responseWriter.writeBody(response)
    responseWriter.done()
}

httpServer.route(.GET, "/menu") { request, responseWriter in
    let response = server.renderMenuPage()
    
    responseWriter.writeHeader(status: .ok)
    responseWriter.writeBody(response)
    responseWriter.done()
}

// Start HTTP server
do {
    try httpServer.start()
    server.start()
} catch {
    print("Failed to start server: \(error)")
}