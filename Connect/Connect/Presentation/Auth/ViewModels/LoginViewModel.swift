import Foundation
import Combine

class LoginViewModel: ObservableObject {
    // Input fields
    @Published var phoneNumber = ""
    @Published var phoneNumberError: String? = nil
    
    // UI state
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var otpSent = false
    
    // Session data
    @Published var sessionId: String?
    
    // Dependencies
    private let loginUseCase: LoginUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
        
        // Validate phone number on changes
        $phoneNumber
            .dropFirst()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] phoneNumber in
                self?.validatePhoneNumber(phoneNumber)
            }
            .store(in: &cancellables)
    }
    
    // Validate phone number format
    private func validatePhoneNumber(_ phoneNumber: String) {
        // Simple validation for demo purposes
        if phoneNumber.count < 10 {
            phoneNumberError = "Phone number must be at least 10 digits"
        } else {
            phoneNumberError = nil
        }
    }
    
    // Login with phone number
    func login() {
        guard phoneNumberError == nil, !phoneNumber.isEmpty else {
            showError = true
            errorMessage = "Please enter a valid phone number"
            return
        }
        
        isLoading = true
        
        loginUseCase.execute(phoneNumber: phoneNumber)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self?.showError = true
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    self?.sessionId = response.sessionId
                    self?.otpSent = true
                }
            )
            .store(in: &cancellables)
    }
    
    // Reset state for a new login attempt
    func resetState() {
        phoneNumber = ""
        phoneNumberError = nil
        isLoading = false
        showError = false
        errorMessage = ""
        otpSent = false
        sessionId = nil
    }
}

// Preview support
#if DEBUG
class MockAuthRepository: AuthRepository {
    func login(phoneNumber: String) -> AnyPublisher<LoginResponse, Error> {
        return Just(LoginResponse(sessionId: "mock-session-id", expiresIn: 300))
            .setFailureType(to: Error.self)
            .delay(for: 1.0, scheduler: RunLoop.main) // Simulate network delay
            .eraseToAnyPublisher()
    }
    
    func verifyOTP(sessionId: String, phoneNumber: String, otp: String) -> AnyPublisher<TokenResponse, Error> {
        return Just(TokenResponse(token: "mock-token", refreshToken: "mock-refresh-token", expiresIn: 3600))
            .setFailureType(to: Error.self)
            .delay(for: 1.0, scheduler: RunLoop.main) // Simulate network delay
            .eraseToAnyPublisher()
    }
    
    func resendOTP(sessionId: String, phoneNumber: String) -> AnyPublisher<ResendOTPResponse, Error> {
        return Just(ResendOTPResponse(success: true, sessionId: "mock-session-id", expiresIn: 300))
            .setFailureType(to: Error.self)
            .delay(for: 1.0, scheduler: RunLoop.main) // Simulate network delay
            .eraseToAnyPublisher()
    }
}

class LoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(phoneNumber: String) -> AnyPublisher<LoginResponse, Error> {
        return authRepository.login(phoneNumber: phoneNumber)
    }
}
#endif