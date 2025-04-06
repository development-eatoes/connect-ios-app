import XCTest
import Combine
@testable import Connect

class LoginViewModelTests: XCTestCase {
    
    var sut: LoginViewModel!
    var mockLoginUseCase: MockLoginUseCase!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockLoginUseCase = MockLoginUseCase()
        sut = LoginViewModel(loginUseCase: mockLoginUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockLoginUseCase = nil
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testLoginWithValidPhoneNumber() {
        // Given
        let expectation = self.expectation(description: "Login succeeds")
        mockLoginUseCase.stubbedResult = Result<String, Error>.success("test-session-id").publisher.eraseToAnyPublisher()
        
        // Observe state changes
        sut.$otpSent
            .dropFirst() // Skip initial value
            .sink { value in
                if value {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.phoneNumber = "1234567890"
        sut.login()
        
        // Then
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error)
            XCTAssertTrue(self.sut.otpSent)
            XCTAssertEqual(self.sut.sessionId, "test-session-id")
            XCTAssertNil(self.sut.phoneNumberError)
            XCTAssertEqual(self.mockLoginUseCase.executeCallCount, 1)
            XCTAssertEqual(self.mockLoginUseCase.phoneNumber, "1234567890")
        }
    }
    
    func testLoginWithInvalidPhoneNumber() {
        // Given
        sut.phoneNumber = "123"
        
        // When
        sut.login()
        
        // Then
        XCTAssertFalse(sut.otpSent)
        XCTAssertNil(sut.sessionId)
        XCTAssertNotNil(sut.phoneNumberError)
        XCTAssertEqual(mockLoginUseCase.executeCallCount, 0)
    }
    
    func testLoginFailure() {
        // Given
        let expectation = self.expectation(description: "Login fails")
        let error = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockLoginUseCase.stubbedResult = Result<String, Error>.failure(error).publisher.eraseToAnyPublisher()
        
        // Observe state changes
        sut.$showError
            .dropFirst() // Skip initial value
            .sink { value in
                if value {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.phoneNumber = "1234567890"
        sut.login()
        
        // Then
        waitForExpectations(timeout: 1.0) { error in
            XCTAssertNil(error)
            XCTAssertFalse(self.sut.otpSent)
            XCTAssertNil(self.sut.sessionId)
            XCTAssertTrue(self.sut.showError)
            XCTAssertEqual(self.sut.errorMessage, "Test error")
            XCTAssertEqual(self.mockLoginUseCase.executeCallCount, 1)
        }
    }
}

// MARK: - Mock implementation for testing
class MockLoginUseCase: LoginUseCase {
    
    var executeCallCount = 0
    var phoneNumber: String?
    var stubbedResult: AnyPublisher<String, Error>!
    
    init() {
        super.init(authRepository: MockAuthRepository())
    }
    
    override func execute(phoneNumber: String) -> AnyPublisher<String, Error> {
        executeCallCount += 1
        self.phoneNumber = phoneNumber
        return stubbedResult
    }
}

class MockAuthRepository: AuthRepository {
    func login(phoneNumber: String) -> AnyPublisher<LoginResponse, Error> {
        fatalError("Not implemented - use the mock use case instead")
    }
    
    func verifyOTP(phoneNumber: String, sessionId: String, otp: String) -> AnyPublisher<VerifyOTPResponse, Error> {
        fatalError("Not implemented - use the mock use case instead")
    }
    
    func resendOTP(sessionId: String) -> AnyPublisher<LoginResponse, Error> {
        fatalError("Not implemented - use the mock use case instead")
    }
}