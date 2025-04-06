const express = require('express');
const path = require('path');
const app = express();
const port = 5000;

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// Create the pages from our Swift app design
app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
        <title>Connect</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                background-color: #0f0f0f;
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                min-height: 100vh;
                color: #fff;
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
                color: #aaa;
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
                border: 1px solid #333;
                border-radius: 8px;
                font-size: 16px;
                box-sizing: border-box;
                background-color: #222;
                color: #fff;
            }
            .error {
                color: #ff3b30;
                font-size: 14px;
                margin-top: 4px;
            }
            .btn-primary {
                background-color: #2196f3;
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
                background-color: #1976d2;
            }
            .btn-primary:disabled {
                background-color: #555;
                cursor: not-allowed;
            }
            .app-demo-banner {
                background-color: #333;
                color: #fff;
                text-align: center;
                padding: 10px;
                font-size: 14px;
                border-radius: 4px;
                margin-bottom: 20px;
            }
            .otp-container {
                display: flex;
                justify-content: space-between;
                margin-bottom: 24px;
            }
            .otp-input {
                width: 40px;
                height: 40px;
                font-size: 20px;
                text-align: center;
                border: 1px solid #333;
                border-radius: 8px;
                background-color: #222;
                color: #fff;
            }
            .resend {
                text-align: center;
                margin: 16px 0 32px;
                color: #aaa;
            }
            .resend button {
                background: none;
                border: none;
                color: #2196f3;
                font-size: 16px;
                cursor: pointer;
                padding: 0;
            }
            .tabs {
                display: flex;
                margin-bottom: 20px;
            }
            .tab {
                flex: 1;
                text-align: center;
                padding: 15px 0;
                cursor: pointer;
                border-bottom: 2px solid transparent;
                transition: border-color 0.3s;
            }
            .tab.active {
                border-bottom: 2px solid #2196f3;
                color: #2196f3;
            }
            #otpSection {
                display: none;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="app-demo-banner">
                Connect - Swift Clean Architecture App
            </div>
            
            <div class="header">
                <h1>Welcome to Connect</h1>
                <p>Sign in to continue</p>
            </div>
            
            <div class="tabs">
                <div class="tab active" id="phoneTab">Phone Number</div>
                <div class="tab" id="otpTab">Verification</div>
            </div>
            
            <div id="phoneSection">
                <form id="phoneForm">
                    <div class="form-group">
                        <label for="phoneNumber">Mobile Number</label>
                        <input type="tel" id="phoneNumber" name="phoneNumber" placeholder="Enter 10-digit number" pattern="[0-9]{10}" required>
                        <div id="phoneError" class="error"></div>
                    </div>
                    
                    <button type="submit" class="btn-primary" id="requestOtpButton">Request OTP</button>
                </form>
            </div>
            
            <div id="otpSection">
                <form id="otpForm">
                    <div class="form-group">
                        <label>Enter 6-digit OTP sent to your mobile</label>
                        <div class="otp-container">
                            <input type="text" maxlength="1" class="otp-input" data-index="1" autofocus>
                            <input type="text" maxlength="1" class="otp-input" data-index="2">
                            <input type="text" maxlength="1" class="otp-input" data-index="3">
                            <input type="text" maxlength="1" class="otp-input" data-index="4">
                            <input type="text" maxlength="1" class="otp-input" data-index="5">
                            <input type="text" maxlength="1" class="otp-input" data-index="6">
                        </div>
                        <div id="otpError" class="error"></div>
                    </div>
                    
                    <div class="resend">
                        <span id="timerText">Resend code in <span id="timer">30</span>s</span>
                        <button type="button" id="resendButton" style="display: none;">Resend OTP</button>
                    </div>
                    
                    <button type="submit" class="btn-primary" id="verifyButton" disabled>Verify OTP</button>
                </form>
            </div>
        </div>
        
        <script>
            // Tab switching logic
            const phoneTab = document.getElementById('phoneTab');
            const otpTab = document.getElementById('otpTab');
            const phoneSection = document.getElementById('phoneSection');
            const otpSection = document.getElementById('otpSection');
            
            phoneTab.addEventListener('click', function() {
                phoneTab.classList.add('active');
                otpTab.classList.remove('active');
                phoneSection.style.display = 'block';
                otpSection.style.display = 'none';
            });
            
            otpTab.addEventListener('click', function() {
                otpTab.classList.add('active');
                phoneTab.classList.remove('active');
                otpSection.style.display = 'block';
                phoneSection.style.display = 'none';
            });
            
            // Phone validation and OTP request
            document.getElementById('phoneForm').addEventListener('submit', function(event) {
                event.preventDefault();
                
                const phoneNumber = document.getElementById('phoneNumber').value;
                const phoneError = document.getElementById('phoneError');
                const requestOtpButton = document.getElementById('requestOtpButton');
                
                // Validate phone number
                if (!/^[0-9]{10}$/.test(phoneNumber)) {
                    phoneError.textContent = 'Please enter a valid 10-digit phone number';
                    return;
                }
                
                phoneError.textContent = '';
                requestOtpButton.disabled = true;
                requestOtpButton.textContent = 'Sending OTP...';
                
                // Simulate API call
                setTimeout(() => {
                    // Switch to OTP tab
                    otpTab.click();
                    requestOtpButton.disabled = false;
                    requestOtpButton.textContent = 'Request OTP';
                }, 1500);
            });
            
            // Handle OTP input fields
            const otpInputs = document.querySelectorAll('.otp-input');
            const verifyButton = document.getElementById('verifyButton');
            let otpComplete = false;
            
            otpInputs.forEach(input => {
                input.addEventListener('input', function() {
                    if (this.value.length === this.maxLength) {
                        const nextIndex = parseInt(this.dataset.index) + 1;
                        const nextInput = document.querySelector('.otp-input[data-index="' + nextIndex + '"]');
                        
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
                        const prevInput = document.querySelector('.otp-input[data-index="' + prevIndex + '"]');
                        
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
  `);
});

app.get('/menu', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
        <title>Connect - Home</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
            
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
                background-color: #0f0f0f;
                margin: 0;
                padding: 0;
                color: #fff;
                line-height: 1.5;
                -webkit-font-smoothing: antialiased;
                -moz-osx-font-smoothing: grayscale;
            }
            
            .app-container {
                max-width: 480px;
                margin: 0 auto;
                position: relative;
                padding-bottom: 60px;
            }
            
            .banner-notification {
                background-color: #f7b731;
                color: #000;
                text-align: center;
                padding: 8px;
                font-size: 13px;
                font-weight: 500;
            }
            
            .header-image {
                width: 100%;
                height: 220px;
                object-fit: cover;
                display: block;
            }
            
            .categories-section {
                padding: 20px 15px;
            }
            
            .section-title {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 15px;
                letter-spacing: -0.2px;
            }
            
            .featured-card {
                background-color: #1a1a1a;
                border-radius: 12px;
                overflow: hidden;
                margin-bottom: 28px;
                position: relative;
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            }
            
            .featured-card img {
                width: 100%;
                height: 180px;
                object-fit: cover;
            }
            
            .featured-overlay {
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                background: linear-gradient(to top, rgba(0,0,0,0.9), rgba(0,0,0,0.4), transparent);
                padding: 25px 15px 15px;
                color: white;
            }
            
            .featured-title {
                font-size: 18px;
                font-weight: 800;
                margin-bottom: 6px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .featured-description {
                font-size: 14px;
                opacity: 0.9;
                margin-bottom: 12px;
            }
            
            .action-button {
                background-color: #2196f3;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 16px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: background-color 0.2s, transform 0.1s;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .action-button:hover {
                background-color: #1976d2;
                transform: translateY(-2px);
            }
            
            .events-section {
                margin-bottom: 28px;
            }
            
            .event-card {
                background-color: #1a1a1a;
                border-radius: 12px;
                overflow: hidden;
                margin-bottom: 15px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            }
            
            .event-card img {
                width: 100%;
                height: 150px;
                object-fit: cover;
            }
            
            .event-details {
                padding: 15px;
            }
            
            .event-title {
                font-weight: 700;
                margin-bottom: 6px;
                font-size: 16px;
            }
            
            .event-date {
                font-size: 13px;
                color: #bbb;
                margin-bottom: 14px;
                font-weight: 500;
            }
            
            .carousel-dots {
                display: flex;
                justify-content: center;
                margin-top: 15px;
                gap: 6px;
            }
            
            .dot {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background-color: #555;
            }
            
            .dot.active {
                background-color: #2196f3;
                width: 20px;
                border-radius: 10px;
            }
            
            .featured-items {
                display: flex;
                margin-bottom: 28px;
                overflow-x: auto;
                scrollbar-width: none;
                -ms-overflow-style: none;
                gap: 16px;
                padding: 4px 0;
            }
            
            .featured-items::-webkit-scrollbar {
                display: none;
            }
            
            .featured-item {
                flex: 0 0 auto;
                width: 140px;
                background-color: #1a1a1a;
                border-radius: 12px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.15);
                overflow: hidden;
            }
            
            .featured-item img {
                width: 100%;
                height: 100px;
                object-fit: cover;
            }
            
            .featured-item-content {
                padding: 10px;
            }
            
            .featured-item-title {
                font-weight: 600;
                font-size: 14px;
                margin-bottom: 4px;
            }
            
            .featured-item-subtitle {
                font-size: 12px;
                color: #bbb;
                font-weight: 500;
            }
            
            .category-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 16px;
                margin-bottom: 28px;
            }
            
            .category-card {
                background-color: #1a1a1a;
                border-radius: 16px;
                overflow: hidden;
                aspect-ratio: 1.1;
                position: relative;
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
                transition: transform 0.2s;
            }
            
            .category-card:hover {
                transform: scale(1.02);
            }
            
            .category-card img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.3s;
            }
            
            .category-card:hover img {
                transform: scale(1.05);
            }
            
            .category-overlay {
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                background: linear-gradient(to top, rgba(0,0,0,0.9), rgba(0,0,0,0.3), transparent);
                padding: 20px 15px 12px;
                color: white;
            }
            
            .category-name {
                font-weight: 700;
                font-size: 16px;
            }
            
            .footer {
                display: flex;
                justify-content: space-between;
                padding: 20px 15px;
                background-color: #111;
                border-top: 1px solid #333;
                margin-top: 20px;
            }
            
            .footer-logo {
                text-align: center;
                margin-bottom: 12px;
            }
            
            .footer-logo img {
                width: 55px;
                height: 55px;
                border-radius: 50%;
                border: 2px solid #2196f3;
                box-shadow: 0 2px 8px rgba(33, 150, 243, 0.3);
            }
            
            .footer-venue {
                font-weight: 700;
                margin-bottom: 4px;
                font-size: 14px;
            }
            
            .footer-address {
                font-size: 12px;
                color: #bbb;
                margin-bottom: 12px;
                max-width: 180px;
            }
            
            .footer-action {
                display: flex;
                flex-direction: column;
                gap: 10px;
                justify-content: center;
            }
            
            .footer-button {
                border: 1px solid #2196f3;
                color: #2196f3;
                background: none;
                border-radius: 6px;
                padding: 8px 12px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                transition: background-color 0.2s, color 0.2s;
                white-space: nowrap;
            }
            
            .footer-button:hover {
                background-color: rgba(33, 150, 243, 0.1);
            }
            
            .footer-tab-bar {
                display: flex;
                justify-content: space-around;
                padding: 10px 0;
                background-color: #111;
                border-top: 1px solid #333;
                position: fixed;
                bottom: 0;
                width: 100%;
                max-width: 480px;
                z-index: 100;
                box-shadow: 0 -2px 10px rgba(0,0,0,0.3);
            }
            
            .footer-tab {
                display: flex;
                flex-direction: column;
                align-items: center;
                font-size: 10px;
                color: #aaa;
                transition: color 0.2s;
            }
            
            .footer-tab.active {
                color: #2196f3;
            }
            
            .footer-tab:hover {
                color: #ddd;
            }
            
            .footer-tab.active:hover {
                color: #2196f3;
            }
            
            .footer-tab i {
                font-size: 20px;
                margin-bottom: 5px;
            }
            
            .app-demo-banner {
                background-color: #333;
                color: #fff;
                text-align: center;
                padding: 10px;
                font-size: 14px;
                font-weight: 500;
            }
            
            /* Page indicators */
            .page-indicator {
                display: flex;
                justify-content: center;
                gap: 5px;
                margin: 10px 0 16px;
            }
            
            .indicator {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background-color: #444;
            }
            
            .indicator.active {
                background-color: #2196f3;
                width: 20px;
                border-radius: 4px;
            }
            
            /* View more button */
            .view-more {
                display: flex;
                align-items: center;
                justify-content: center;
                color: #2196f3;
                font-size: 14px;
                font-weight: 600;
                margin-top: 10px;
                cursor: pointer;
                gap: 6px;
            }
            
            .view-more i {
                font-size: 18px;
            }
        </style>
    </head>
    <body>
        <div class="app-container">
            <div class="app-demo-banner">
                Connect - Swift Clean Architecture App
            </div>
            
            <div class="banner-notification">
                This is a test channel announcement to view your promos!
            </div>
            
            <img src="https://images.unsplash.com/photo-1544148103-0773bf10d330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGJlZXJ8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=800&q=60" class="header-image" alt="Beer">
            
            <div class="categories-section">
                <div class="featured-card">
                    <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YnVyZ2VyfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60" alt="Burger">
                    <div class="featured-overlay">
                        <div class="featured-title">SEE YOUR FAVOURITE BURGER</div>
                        <div class="featured-description">Pickup at your table</div>
                        <button class="action-button">ORDER NOW</button>
                    </div>
                </div>
                
                <h2 class="section-title">Upcoming Events</h2>
                <div class="events-section">
                    <div class="event-card">
                        <img src="https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Y29uY2VydHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60" alt="Concert">
                        <div class="event-details">
                            <div class="event-title">Bollywood</div>
                            <div class="event-date">Dec 02</div>
                            <button class="action-button">Buy Now</button>
                        </div>
                    </div>
                    
                    <div class="page-indicator">
                        <div class="indicator active"></div>
                        <div class="indicator"></div>
                        <div class="indicator"></div>
                    </div>
                </div>
                
                <h2 class="section-title">Exclusively yours</h2>
                <div class="featured-items">
                    <div class="featured-item">
                        <img src="https://images.unsplash.com/photo-1565299507177-b0ac66763828?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGJ1cmdlcnxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60" alt="Chicken Burger">
                        <div class="featured-item-content">
                            <div class="featured-item-title">Chicken Burger</div>
                            <div class="featured-item-subtitle">Crispy & juicy</div>
                        </div>
                    </div>
                    <div class="featured-item">
                        <img src="https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8ZnJlbmNoJTIwZnJpZXN8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=800&q=60" alt="French Fries">
                        <div class="featured-item-content">
                            <div class="featured-item-title">French Fries</div>
                            <div class="featured-item-subtitle">Crispy & salty</div>
                        </div>
                    </div>
                    <div class="featured-item">
                        <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGl6emF8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=800&q=60" alt="Pizza">
                        <div class="featured-item-content">
                            <div class="featured-item-title">Pepperoni Pizza</div>
                            <div class="featured-item-subtitle">Hot & spicy</div>
                        </div>
                    </div>
                </div>
                
                <h2 class="section-title">Categories</h2>
                <div class="category-grid">
                    <div class="category-card">
                        <img src="https://images.unsplash.com/photo-1625937286074-9ca519f7d9dc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8Zm9vZCUyMG1lbnV8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=800&q=60" alt="Food Menu">
                        <div class="category-overlay">
                            <div class="category-name">Food Menu</div>
                        </div>
                    </div>
                    <div class="category-card">
                        <img src="https://images.unsplash.com/photo-1608885898957-a26745315d04?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8aGFyZCUyMGRyaW5rc3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60" alt="Hard Drinks">
                        <div class="category-overlay">
                            <div class="category-name">Hard drinks</div>
                        </div>
                    </div>
                    <div class="category-card">
                        <img src="https://images.unsplash.com/photo-1502872364588-894d7d6ddfab?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cGFydHl8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=800&q=60" alt="Party Menu">
                        <div class="category-overlay">
                            <div class="category-name">Party Menu</div>
                        </div>
                    </div>
                    <div class="category-card">
                        <img src="https://images.unsplash.com/photo-1612528443702-f6741f70a049?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c2hvdCUyMGRyaW5rc3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60" alt="Short Hot Menu">
                        <div class="category-overlay">
                            <div class="category-name">Short Hot Menu</div>
                        </div>
                    </div>
                </div>
                
                <div class="view-more">
                    View more <i class="fas fa-chevron-down"></i>
                </div>
            </div>
            
            <div class="footer">
                <div>
                    <div class="footer-logo">
                        <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60" alt="Iron Hill Bengaluru">
                    </div>
                    <div class="footer-venue">Iron Hill Bengaluru</div>
                    <div class="footer-address">Popular Junction, Bengaluru, Pizza Pan Rd</div>
                </div>
                <div class="footer-action">
                    <button class="footer-button">Edit Profile</button>
                    <button class="footer-button">Buy Gift</button>
                </div>
            </div>
            
            <div class="footer-tab-bar">
                <div class="footer-tab active">
                    <i class="fas fa-home"></i>
                    <span>Menu</span>
                </div>
                <div class="footer-tab">
                    <i class="fas fa-utensils"></i>
                    <span>Reserve Table</span>
                </div>
                <div class="footer-tab">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Buy Gift Now</span>
                </div>
            </div>
        </div>
        
        <script>
            // Add hover effects and basic interactivity
            document.querySelectorAll('.action-button').forEach(button => {
                button.addEventListener('click', function() {
                    this.style.transform = 'scale(0.95)';
                    setTimeout(() => {
                        this.style.transform = 'none';
                    }, 100);
                });
            });
            
            document.querySelectorAll('.footer-tab').forEach(tab => {
                tab.addEventListener('click', function() {
                    document.querySelectorAll('.footer-tab').forEach(t => {
                        t.classList.remove('active');
                    });
                    this.classList.add('active');
                });
            });
            
            document.querySelector('.view-more').addEventListener('click', function() {
                // This would normally expand to show more categories
                this.innerHTML = 'Loading... <i class="fas fa-spinner fa-spin"></i>';
                setTimeout(() => {
                    this.innerHTML = 'View more <i class="fas fa-chevron-down"></i>';
                }, 1500);
            });
        </script>
    </body>
    </html>
  `);
});

// Start the server
app.listen(port, '0.0.0.0', () => {
  console.log(`Connect app running at http://localhost:${port}`);
});