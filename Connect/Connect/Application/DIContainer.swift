import Foundation

class DIContainer {
    static let shared = DIContainer()
    
    // MARK: - Network
    lazy var networkService: NetworkService = {
        // Using a placeholder base URL for now
        // In a real app, this would be configured from environment
        let baseURL = URL(string: "https://api.example.com")!
        return NetworkService(baseURL: baseURL)
    }()
    
    // MARK: - Repositories
    lazy var authRepository: AuthRepository = {
        return AuthRepositoryImpl(networkService: networkService)
    }()
    
    lazy var menuRepository: MenuRepository = {
        return MenuRepositoryImpl(networkService: networkService)
    }()
    
    // MARK: - Use Cases
    // Auth use cases
    lazy var loginUseCase: LoginUseCase = {
        return LoginUseCase(authRepository: authRepository)
    }()
    
    lazy var verifyOTPUseCase: VerifyOTPUseCase = {
        return VerifyOTPUseCase(authRepository: authRepository)
    }()
    
    lazy var resendOTPUseCase: ResendOTPUseCase = {
        return ResendOTPUseCase(authRepository: authRepository)
    }()
    
    // Menu use cases
    lazy var fetchCategoriesUseCase: FetchCategoriesUseCase = {
        return FetchCategoriesUseCase(menuRepository: menuRepository)
    }()
    
    lazy var fetchMenuItemsUseCase: FetchMenuItemsUseCase = {
        return FetchMenuItemsUseCase(menuRepository: menuRepository)
    }()
    
    lazy var fetchMenuItemDetailUseCase: FetchMenuItemDetailUseCase = {
        return FetchMenuItemDetailUseCase(menuRepository: menuRepository)
    }()
    
    // MARK: - View Models
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(loginUseCase: loginUseCase)
    }
    
    func makeOTPViewModel() -> OTPViewModel {
        return OTPViewModel(
            verifyOTPUseCase: verifyOTPUseCase,
            resendOTPUseCase: resendOTPUseCase
        )
    }
    
    func makeMenuViewModel() -> MenuViewModel {
        return MenuViewModel(
            fetchCategoriesUseCase: fetchCategoriesUseCase,
            fetchMenuItemsUseCase: fetchMenuItemsUseCase,
            fetchMenuItemDetailUseCase: fetchMenuItemDetailUseCase
        )
    }
}