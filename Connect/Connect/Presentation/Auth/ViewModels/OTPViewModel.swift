import Foundation
import Combine

class OTPViewModel: ObservableObject {
    // Input
    @Published var otp: String = ""
    @Published var phoneNumber: String = ""
    @Published var sessionId: String = ""
    
    // Output
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var otpError: String? = nil
    @Published var isVerified: Bool = false
    @Published var resendInProgress: Bool = false
    @Published var resendSuccess: Bool = false
    
    // Timer for resend button
    @Published var resendCountdown: Int = 30
    @Published var canResend: Bool = false
    
    // User data after successful authentication
    @Published var user: User? = nil
    @Published var authToken: String? = nil
    
    // Event publisher for successful verification
    private let verificationSuccessSubject = PassthroughSubject<User, Never>()
    var onVerificationSuccess: AnyPublisher<User, Never> {
        return verificationSuccessSubject.eraseToAnyPublisher()
    }
    
    private let verifyOTPUseCase: VerifyOTPUseCase
    private let resendOTPUseCase: ResendOTPUseCase
    private var cancellables = Set<AnyCancellable>()
    private var timer: AnyCancellable?
    
    init(verifyOTPUseCase: VerifyOTPUseCase, resendOTPUseCase: ResendOTPUseCase) {
        self.verifyOTPUseCase = verifyOTPUseCase
        self.resendOTPUseCase = resendOTPUseCase
        startResendTimer()
    }
    
    func verifyOTP() {
        guard validateOTP() else { return }
        
        isLoading = true
        showError = false
        
        verifyOTPUseCase.execute(phoneNumber: phoneNumber, sessionId: sessionId, otp: otp)
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
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.authToken = response.token
                    self.user = response.user
                    self.isVerified = true
                    self.verificationSuccessSubject.send(response.user)
                }
            )
            .store(in: &cancellables)
    }
    
    func resendOTP() {
        guard canResend else { return }
        
        resendInProgress = true
        resendSuccess = false
        showError = false
        
        resendOTPUseCase.execute(sessionId: sessionId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.resendInProgress = false
                    
                    if case .failure(let error) = completion {
                        self.showError = true
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] _ in
                    guard let self = self else { return }
                    self.resendSuccess = true
                    self.resetResendTimer()
                    
                    // Hide success message after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.resendSuccess = false
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func validateOTP() -> Bool {
        // Simple validation for demonstration purposes
        if otp.count != 6 || !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: otp)) {
            otpError = "Please enter a valid 6-digit OTP"
            return false
        }
        
        otpError = nil
        return true
    }
    
    private func startResendTimer() {
        canResend = false
        resendCountdown = 30
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.resendCountdown > 0 {
                    self.resendCountdown -= 1
                } else {
                    self.canResend = true
                    self.timer?.cancel()
                }
            }
    }
    
    private func resetResendTimer() {
        timer?.cancel()
        startResendTimer()
    }
    
    deinit {
        timer?.cancel()
    }
}