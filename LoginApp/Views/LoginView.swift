import SwiftUI
import UIComponents
import Combine
import NetworkLayer

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                // Logo or app icon
                Image(systemName: "link.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("Connect")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 24) {
                    // Phone number input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number")
                            .font(.headline)
                        
                        StyledTextField(
                            placeholder: "Enter your phone number",
                            text: $viewModel.phoneNumber,
                            keyboardType: .phonePad
                        )
                    }
                    
                    // OTP Section (only visible after requesting OTP)
                    if viewModel.showOTPField {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Verification Code")
                                .font(.headline)
                            
                            Text("We've sent a verification code to \(viewModel.phoneNumber)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            OTPField(
                                otpText: $viewModel.otpCode,
                                codeLength: 4,
                                onCompleted: { code in
                                    // Auto-verify when code is complete
                                    viewModel.verifyOTP()
                                }
                            )
                            .padding(.top, 8)
                        }
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    // Send OTP or Verify OTP button
                    PrimaryButton(
                        title: viewModel.showOTPField ? "Verify Code" : "Send Code",
                        isLoading: viewModel.isLoading,
                        isDisabled: viewModel.showOTPField ? viewModel.otpCode.count < 4 : viewModel.phoneNumber.count < 10
                    ) {
                        if viewModel.showOTPField {
                            viewModel.verifyOTP()
                        } else {
                            viewModel.sendOTP()
                        }
                    }
                    
                    // Resend option when OTP is visible
                    if viewModel.showOTPField {
                        Button("Resend Code") {
                            viewModel.resendOTP()
                        }
                        .font(.subheadline)
                        .padding(.top, 8)
                    }
                }
                .padding()
            }
            .padding(.horizontal, 20)
            // If login successful, show menu
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                MenuHomeView(viewModel: viewModel.createMenuHomeViewModel())
            }
        }
    }
}

class LoginViewModel: ObservableObject {
    private var authService: AuthServiceProtocol?
    private var menuService: MenuServiceProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var phoneNumber: String = ""
    @Published var otpCode: String = ""
    @Published var showOTPField: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isLoggedIn: Bool = false
    
    init() {
        // Initialize services
        let networkService = NetworkService(baseURL: "https://api.connect.example.com")
        authService = AuthService(networkService: networkService)
        menuService = MenuService(networkService: networkService)
    }
    
    func sendOTP() {
        guard let authService = authService else {
            self.errorMessage = "Service unavailable"
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        authService.login(phoneNumber: phoneNumber)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                if response.success {
                    self.showOTPField = true
                } else {
                    self.errorMessage = response.message
                }
            }
            .store(in: &cancellables)
    }
    
    func verifyOTP() {
        guard let authService = authService else {
            self.errorMessage = "Service unavailable"
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        authService.verifyOTP(phoneNumber: phoneNumber, otp: otpCode)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                if response.success {
                    // Save token for future API calls
                    if let token = response.token {
                        UserDefaults.standard.set(token, forKey: "authToken")
                        // You would also update the NetworkService with the token
                        // networkService.setAuthToken(token)
                    }
                    
                    self.isLoggedIn = true
                } else {
                    self.errorMessage = response.message
                }
            }
            .store(in: &cancellables)
    }
    
    func resendOTP() {
        sendOTP()
    }
    
    func createMenuHomeViewModel() -> MenuHomeViewModel {
        return MenuHomeViewModel(menuService: menuService!)
    }
}

// Preview Helpers
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}