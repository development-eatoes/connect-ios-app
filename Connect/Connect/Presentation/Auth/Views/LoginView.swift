import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var otpViewModel = DIContainer.shared.makeOTPViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Logo and welcome message
                VStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                        .padding(.bottom, 16)
                    
                    Text("Welcome to Connect")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Sign in to continue")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 50)
                .padding(.bottom, 30)
                
                // Phone Number Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Phone Number")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    CustomTextField(
                        placeholder: "Enter your mobile number",
                        text: $viewModel.phoneNumber,
                        keyboardType: .phonePad,
                        errorMessage: viewModel.phoneNumberError
                    )
                }
                .padding(.horizontal)
                
                // OTP Section (Shown after phone number submission)
                if viewModel.otpSent {
                    otpSection
                        .transition(.opacity)
                        .onAppear {
                            // Transfer session data to OTP view model
                            otpViewModel.sessionId = viewModel.sessionId ?? ""
                            otpViewModel.phoneNumber = viewModel.phoneNumber
                        }
                }
                
                Spacer()
                
                // Login button (changes to verify button after OTP is sent)
                PrimaryButton(
                    title: viewModel.otpSent ? "Verify OTP" : "Continue",
                    isLoading: viewModel.otpSent ? otpViewModel.isLoading : viewModel.isLoading,
                    isDisabled: viewModel.otpSent ? otpViewModel.otp.count < 6 : viewModel.phoneNumber.count < 10
                ) {
                    if viewModel.otpSent {
                        otpViewModel.verifyOTP()
                    } else {
                        viewModel.login()
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            
            // Error handling for phone number submission
            if viewModel.showError {
                ErrorView(message: viewModel.errorMessage) {
                    viewModel.showError = false
                }
            }
            
            // Error handling for OTP verification
            if otpViewModel.showError {
                ErrorView(message: otpViewModel.errorMessage) {
                    otpViewModel.showError = false
                }
            }
            
            // Loading overlay
            if viewModel.isLoading {
                LoadingView()
            }
        }
    }
    
    // OTP input section
    private var otpSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Enter OTP")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("We've sent a 6-digit verification code to \(viewModel.phoneNumber)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 8)
            
            OTPInputView(otpString: $otpViewModel.otp)
                .padding(.vertical, 10)
            
            // Resend button
            if otpViewModel.canResend {
                Button(action: {
                    otpViewModel.resendOTP()
                }) {
                    Text("Resend OTP")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .disabled(otpViewModel.resendInProgress)
                .opacity(otpViewModel.resendInProgress ? 0.5 : 1.0)
            } else {
                Text("Resend OTP in \(otpViewModel.resendCountdown)s")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Resend success
            if otpViewModel.resendSuccess {
                Text("OTP resent successfully!")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding(.top, 4)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = LoginViewModel(loginUseCase: LoginUseCase(authRepository: MockAuthRepository()))
        LoginView(viewModel: viewModel)
    }
}
#endif