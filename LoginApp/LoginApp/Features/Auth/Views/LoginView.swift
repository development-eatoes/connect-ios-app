import SwiftUI
import UIComponents

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var phoneNumber: String = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Welcome")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Enter your mobile number to continue")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 40)
            
            Spacer()
            
            // Phone input
            VStack(alignment: .leading, spacing: 8) {
                Text("Mobile Number")
                    .font(.headline)
                
                PhoneNumberTextField(phoneNumber: $phoneNumber)
                
                if let error = viewModel.phoneNumberError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            Spacer()
            
            // Login button
            VStack {
                PrimaryButton(
                    title: "Login",
                    isLoading: viewModel.isLoading,
                    action: {
                        viewModel.login(phoneNumber: phoneNumber)
                    }
                )
                .disabled(!viewModel.isPhoneNumberValid(phoneNumber))
            }
            .padding(.bottom, 24)
        }
        .padding()
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Login Error"),
                message: Text(viewModel.errorMessage ?? "An error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
    }
}
