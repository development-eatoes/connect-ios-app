import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @State private var showOTPVerification = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 24) {
                    // Logo
                    Image(systemName: "link.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                        .padding(.bottom, 20)
                    
                    // Welcome text
                    Text("Welcome to Connect")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Enter your phone number to continue")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                    
                    // Phone number input
                    StyledTextField(
                        placeholder: "Phone Number",
                        text: $viewModel.phoneNumber,
                        keyboardType: .phonePad,
                        errorMessage: viewModel.phoneNumberError
                    )
                    
                    if viewModel.otpSent {
                        // OTP view in the same screen
                        VStack(spacing: 12) {
                            Text("Enter the OTP sent to \(viewModel.phoneNumber)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            // OTP fields
                            OTPVerificationSection(
                                viewModel: OTPViewModel(
                                    verifyOTPUseCase: DIContainer.shared.verifyOTPUseCase,
                                    resendOTPUseCase: DIContainer.shared.resendOTPUseCase
                                ).also {
                                    $0.phoneNumber = viewModel.phoneNumber
                                    $0.sessionId = viewModel.sessionId
                                }
                            )
                        }
                        .padding(.vertical, 20)
                        .transition(.opacity)
                    } else {
                        // Login button
                        PrimaryButton(
                            title: "Continue",
                            action: {
                                viewModel.login()
                            },
                            isLoading: viewModel.isLoading,
                            isDisabled: viewModel.phoneNumber.isEmpty
                        )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                
                // Error alert
                .alert(isPresented: $viewModel.showError) {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.errorMessage ?? "Something went wrong"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct OTPVerificationSection: View {
    @ObservedObject var viewModel: OTPViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            OTPField(
                otp: $viewModel.otp,
                otpLength: 6,
                errorMessage: viewModel.otpError
            )
            
            PrimaryButton(
                title: "Verify OTP",
                action: {
                    viewModel.verifyOTP()
                },
                isLoading: viewModel.isLoading,
                isDisabled: viewModel.otp.count < 6
            )
            
            Button("Resend OTP") {
                viewModel.resendOTP()
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.blue)
            .disabled(viewModel.isLoading)
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? "Something went wrong"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// Extension to make property initialization cleaner
extension OTPViewModel {
    func also(configure: (OTPViewModel) -> Void) -> OTPViewModel {
        configure(self)
        return self
    }
}