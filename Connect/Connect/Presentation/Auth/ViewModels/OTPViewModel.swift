import Foundation
import Combine

class OTPViewModel: ObservableObject {
    // Input fields
    @Published var otp = ""
    @Published var phoneNumber = ""
    @Published var sessionId = ""
    
    // UI state
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var canResend = false
    @Published var resendInProgress = false
    @Published var resendSuccess = false
    @Published var resendCountdown = 60
    
    // Dependencies
    private let verifyOTPUseCase: VerifyOTPUseCase
    private let resendOTPUseCase: ResendOTPUseCase
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    
    // State
    private var authenticated = false
    
    init(verifyOTPUseCase: VerifyOTPUseCase, resendOTPUseCase: ResendOTPUseCase) {
        self.verifyOTPUseCase = verifyOTPUseCase
        self.resendOTPUseCase = resendOTPUseCase
        
        startResendTimer()
    }
    
    // Verify OTP
    func verifyOTP() {
        guard otp.count == 6, !sessionId.isEmpty, !phoneNumber.isEmpty else {
            showError = true
            errorMessage = "Please enter a valid OTP code"
            return
        }
        
        isLoading = true
        
        verifyOTPUseCase.execute(
            sessionId: sessionId,
            phoneNumber: phoneNumber,
            otp: otp
        )
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
                // Store tokens (in real app this would use a token manager/keychain)
                // For demo purposes, we just set a flag
                self?.authenticated = true
                
                // In a real app, we'd navigate to the main app here
                // But that will be handled by AppCoordinator
            }
        )
        .store(in: &cancellables)
    }
    
    // Resend OTP
    func resendOTP() {
        guard !sessionId.isEmpty, !phoneNumber.isEmpty, canResend, !resendInProgress else {
            return
        }
        
        resendInProgress = true
        resendSuccess = false
        
        resendOTPUseCase.execute(sessionId: sessionId, phoneNumber: phoneNumber)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.resendInProgress = false
                    
                    if case .failure(let error) = completion {
                        self?.showError = true
                        self?.errorMessage = error.localizedDescription
                    } else {
                        // Reset resend timer
                        self?.startResendTimer()
                    }
                },
                receiveValue: { [weak self] response in
                    // Update session ID if new one was provided
                    if let newSessionId = response.sessionId {
                        self?.sessionId = newSessionId
                    }
                    
                    // Show success
                    self?.resendSuccess = true
                    
                    // Auto-hide success message after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self?.resendSuccess = false
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    // Timer for resend OTP cooldown
    private func startResendTimer() {
        canResend = false
        resendCountdown = 60
        
        // Invalidate existing timer if any
        timer?.invalidate()
        
        // Create a new timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.resendCountdown > 0 {
                self.resendCountdown -= 1
            } else {
                self.canResend = true
                self.timer?.invalidate()
            }
        }
    }
    
    // Reset view model state
    func resetState() {
        otp = ""
        phoneNumber = ""
        sessionId = ""
        isLoading = false
        showError = false
        errorMessage = ""
        canResend = false
        resendInProgress = false
        resendSuccess = false
        authenticated = false
        
        timer?.invalidate()
        startResendTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
}

#if DEBUG
class VerifyOTPUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(sessionId: String, phoneNumber: String, otp: String) -> AnyPublisher<TokenResponse, Error> {
        return authRepository.verifyOTP(sessionId: sessionId, phoneNumber: phoneNumber, otp: otp)
    }
}

class ResendOTPUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(sessionId: String, phoneNumber: String) -> AnyPublisher<ResendOTPResponse, Error> {
        return authRepository.resendOTP(sessionId: sessionId, phoneNumber: phoneNumber)
    }
}
#endif