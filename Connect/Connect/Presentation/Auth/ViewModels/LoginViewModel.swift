import Foundation
import Combine

class LoginViewModel: ObservableObject {
    // Input
    @Published var phoneNumber: String = ""
    
    // Output
    @Published var otpSent: Bool = false
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var phoneNumberError: String? = nil
    @Published var sessionId: String? = nil
    
    private let loginUseCase: LoginUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func login() {
        guard validatePhoneNumber() else { return }
        
        isLoading = true
        showError = false
        
        loginUseCase.execute(phoneNumber: phoneNumber)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self.showError = true
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] sessionId in
                    guard let self = self else { return }
                    self.sessionId = sessionId
                    self.otpSent = true
                }
            )
            .store(in: &cancellables)
    }
    
    private func validatePhoneNumber() -> Bool {
        // Simple validation for demonstration purposes
        if phoneNumber.count < 10 {
            phoneNumberError = "Please enter a valid phone number"
            return false
        }
        
        phoneNumberError = nil
        return true
    }
}