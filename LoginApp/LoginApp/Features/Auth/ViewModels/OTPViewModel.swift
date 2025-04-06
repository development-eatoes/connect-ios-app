import Foundation
import Combine

class OTPViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var otpError: String?
    
    // Navigation event
    let onVerificationSuccess = PassthroughSubject<Void, Never>()
    
    private let verifyOTPUseCase: VerifyOTPUseCase
    private let resendOTPUseCase: ResendOTPUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // Session ID from login
    var sessionId: String?
    
    init(verifyOTPUseCase: VerifyOTPUseCase, resendOTPUseCase: ResendOTPUseCase) {
        self.verifyOTPUseCase = verifyOTPUseCase
        self.resendOTPUseCase = resendOTPUseCase
    }
    
    func verifyOTP(otp: String) {
        guard let sessionId = sessionId else {
            errorMessage = "Session has expired. Please login again."
            showError = true
            return
        }
        
        guard otp.count == 6 else {
            otpError = "Please enter a valid 6-digit OTP"
            return
        }
        
        otpError = nil
        isLoading = true
        
        verifyOTPUseCase.execute(sessionId: sessionId, otp: otp)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                        self?.showError = true
                    }
                },
                receiveValue: { [weak self] _ in
                    self?.onVerificationSuccess.send()
                }
            )
            .store(in: &cancellables)
    }
    
    func resendOTP() {
        guard let sessionId = sessionId else {
            errorMessage = "Session has expired. Please login again."
            showError = true
            return
        }
        
        isLoading = true
        
        resendOTPUseCase.execute(sessionId: sessionId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                        self?.showError = true
                    }
                },
                receiveValue: { _ in
                    // OTP resent successfully
                }
            )
            .store(in: &cancellables)
    }
}
