import Foundation
import Combine

// Dependency Injection Container
class DIContainer {
    // Singleton instance
    static let shared = DIContainer()
    
    // Dependencies
    private let authRepository: AuthRepository
    private let menuRepository: MenuRepository
    
    // Initialization
    private init() {
        // In a real app, we'd have real implementations of these
        #if DEBUG
        self.authRepository = MockAuthRepository()
        self.menuRepository = MockMenuRepository()
        #else
        // For a production app, these would be real implementations
        // that connect to APIs
        self.authRepository = MockAuthRepository() // Replace with real implementation
        self.menuRepository = MockMenuRepository() // Replace with real implementation
        #endif
    }
    
    // MARK: - Auth Use Cases
    
    // Create login use case
    func makeLoginUseCase() -> LoginUseCase {
        return LoginUseCase(authRepository: authRepository)
    }
    
    // Create verify OTP use case
    func makeVerifyOTPUseCase() -> VerifyOTPUseCase {
        return VerifyOTPUseCase(authRepository: authRepository)
    }
    
    // Create resend OTP use case
    func makeResendOTPUseCase() -> ResendOTPUseCase {
        return ResendOTPUseCase(authRepository: authRepository)
    }
    
    // MARK: - Menu Use Cases
    
    // Create fetch categories use case
    func makeFetchCategoriesUseCase() -> FetchCategoriesUseCase {
        return FetchCategoriesUseCase(menuRepository: menuRepository)
    }
    
    // Create fetch menu items use case
    func makeFetchMenuItemsUseCase() -> FetchMenuItemsUseCase {
        return FetchMenuItemsUseCase(menuRepository: menuRepository)
    }
    
    // Create fetch menu item detail use case
    func makeFetchMenuItemDetailUseCase() -> FetchMenuItemDetailUseCase {
        return FetchMenuItemDetailUseCase(menuRepository: menuRepository)
    }
    
    // MARK: - View Models
    
    // Create login view model
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(loginUseCase: makeLoginUseCase())
    }
    
    // Create OTP view model
    func makeOTPViewModel() -> OTPViewModel {
        return OTPViewModel(
            verifyOTPUseCase: makeVerifyOTPUseCase(),
            resendOTPUseCase: makeResendOTPUseCase()
        )
    }
    
    // Create menu view model
    func makeMenuViewModel() -> MenuViewModel {
        return MenuViewModel(
            fetchCategoriesUseCase: makeFetchCategoriesUseCase(),
            fetchMenuItemsUseCase: makeFetchMenuItemsUseCase(),
            fetchMenuItemDetailUseCase: makeFetchMenuItemDetailUseCase()
        )
    }
}