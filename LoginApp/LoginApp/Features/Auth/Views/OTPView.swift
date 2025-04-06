import SwiftUI
import UIComponents
import Combine

struct OTPView: View {
    @ObservedObject var viewModel: OTPViewModel
    @State private var otp: String = ""
    @State private var timeRemaining: Int = 30
    @State private var timer: AnyCancellable?
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Verification")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Enter the 6-digit code sent to your mobile number")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            Spacer()
            
            // OTP input
            VStack(alignment: .center, spacing: 16) {
                OTPTextField(otp: $otp)
                
                if let error = viewModel.otpError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                HStack {
                    if timeRemaining > 0 {
                        Text("Resend code in \(timeRemaining)s")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Button("Resend OTP") {
                            viewModel.resendOTP()
                            resetTimer()
                        }
                        .disabled(viewModel.isLoading)
                    }
                }
                .padding(.top, 8)
            }
            
            Spacer()
            
            // Verify button
            VStack {
                PrimaryButton(
                    title: "Verify OTP",
                    isLoading: viewModel.isLoading,
                    action: {
                        viewModel.verifyOTP(otp: otp)
                    }
                )
                .disabled(otp.count != 6 || viewModel.isLoading)
            }
            .padding(.bottom, 24)
        }
        .padding()
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Verification Error"),
                message: Text(viewModel.errorMessage ?? "An error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            resetTimer()
        }
        .onDisappear {
            timer?.cancel()
        }
        .navigationTitle("Verification")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func resetTimer() {
        timeRemaining = 30
        timer?.cancel()
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
    }
}
