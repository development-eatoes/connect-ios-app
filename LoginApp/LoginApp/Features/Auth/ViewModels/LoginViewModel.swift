import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var phoneNumberError: String?
    
    // Navigation event
    let onLoginSuccess = PassthroughSubject<Void, Never>()
    
    // Session ID to pass to OTP screen
    private(set) var sessionId: String?
    
    private let loginUseCase: LoginUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    func login(phoneNumber: String) {
        guard isPhoneNumberValid(phoneNumber) else {
            phoneNumberError = "Please enter a valid 10-digit phone number"
            return
        }
        
        phoneNumberError = nil
        isLoading = true
        
        loginUseCase.execute(phoneNumber: phoneNumber)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                        self?.showError = true
                    }
                },
                receiveValue: { [weak self] sessionId in
                    self?.sessionId = sessionId
                    self?.onLoginSuccess.send()
                }
            )
            .store(in: &cancellables)
    }
    
    func isPhoneNumberValid(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
}
