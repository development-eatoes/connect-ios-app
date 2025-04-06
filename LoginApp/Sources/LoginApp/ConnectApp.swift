import SwiftUI

@main
struct ConnectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var showLogin = true
    
    var body: some View {
        if isLoggedIn {
            MenuHomeView()
        } else if showLogin {
            LoginView { 
                showLogin = false 
            }
        } else {
            OTPView { 
                isLoggedIn = true 
            }
        }
    }
}

// Simple login view with phone number input
struct LoginView: View {
    @State private var phoneNumber = ""
    @State private var isPhoneValid = false
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            VStack(spacing: 8) {
                Text("Welcome")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Enter your mobile number to continue")
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 32)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Mobile Number")
                    .fontWeight(.semibold)
                
                TextField("Enter 10-digit number", text: $phoneNumber)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .onChange(of: phoneNumber) { newValue in
                        isPhoneValid = newValue.count == 10 && newValue.allSatisfy { $0.isNumber }
                    }
            }
            
            Spacer()
            
            Button(action: onContinue) {
                Text("Login")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isPhoneValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!isPhoneValid)
        }
        .padding()
    }
}

// OTP verification view
struct OTPView: View {
    @State private var otpFields = Array(repeating: "", count: 6)
    @State private var timeRemaining = 30
    @State private var isOTPComplete = false
    @State private var timer: Timer?
    let onVerify: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            VStack(spacing: 8) {
                Text("Verification")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Enter the 6-digit code sent to your mobile number")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 32)
            
            HStack(spacing: 8) {
                ForEach(0..<6, id: \.self) { index in
                    OTPTextField(text: $otpFields[index], isLastField: index == 5) { newValue in
                        handleOTPInput(index: index, newValue: newValue)
                    }
                }
            }
            
            VStack {
                if timeRemaining > 0 {
                    Text("Resend code in \(timeRemaining)s")
                        .foregroundColor(.secondary)
                } else {
                    Button("Resend OTP") {
                        resetTimer()
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding(.top, 16)
            
            Spacer()
            
            Button(action: onVerify) {
                Text("Verify OTP")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isOTPComplete ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!isOTPComplete)
        }
        .padding()
        .onAppear {
            resetTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func handleOTPInput(index: Int, newValue: String) {
        // Move to next field if current field is filled
        if newValue.count == 1 && index < 5 {
            let nextField = index + 1
            // Set focus to next field (in a real app, you'd use FocusState for this)
        }
        
        // Update OTP completion status
        checkOTPComplete()
    }
    
    private func checkOTPComplete() {
        isOTPComplete = otpFields.allSatisfy { $0.count == 1 }
    }
    
    private func resetTimer() {
        timeRemaining = 30
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
}

// Custom OTP text field
struct OTPTextField: View {
    @Binding var text: String
    let isLastField: Bool
    let onTextChange: (String) -> Void
    
    var body: some View {
        TextField("", text: $text)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .frame(width: 48, height: 48)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .onChange(of: text) { newValue in
                // Limit to 1 character
                if newValue.count > 1 {
                    text = String(newValue.prefix(1))
                }
                onTextChange(text)
            }
    }
}