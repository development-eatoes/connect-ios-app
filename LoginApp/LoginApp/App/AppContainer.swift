import UIKit
import NetworkLayer
import UIComponents
import DigitalMenu
import Combine

// Dependency Injection Container
class AppContainer {
    // MARK: - Network Layer
    func makeNetworkService() -> NetworkService {
        return NetworkService(baseURL: "https://api.example.com")
    }
    
    // MARK: - Repositories
    func makeAuthRepository() -> AuthRepository {
        return AuthRepositoryImpl(networkService: makeNetworkService())
    }
    
    // MARK: - Use Cases
    func makeLoginUseCase() -> LoginUseCase {
        return LoginUseCase(repository: makeAuthRepository())
    }
    
    func makeVerifyOTPUseCase() -> VerifyOTPUseCase {
        return VerifyOTPUseCase(repository: makeAuthRepository())
    }
    
    func makeResendOTPUseCase() -> ResendOTPUseCase {
        return ResendOTPUseCase(repository: makeAuthRepository())
    }
    
    // MARK: - View Models
    func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(loginUseCase: makeLoginUseCase())
    }
    
    func makeOTPViewModel() -> OTPViewModel {
        return OTPViewModel(
            verifyOTPUseCase: makeVerifyOTPUseCase(),
            resendOTPUseCase: makeResendOTPUseCase()
        )
    }
    
    // MARK: - Digital Menu
    func makeMenuRepository() -> MenuRepository {
        return MenuRepository(networkService: makeNetworkService())
    }
    
    func makeFetchMenuUseCase() -> FetchMenuUseCase {
        return FetchMenuUseCase(repository: makeMenuRepository())
    }
    
    func makeMenuViewModel() -> MenuViewModel {
        return MenuViewModel(fetchMenuUseCase: makeFetchMenuUseCase())
    }
    
    func makeMenuView() -> MenuListView {
        return MenuListView(viewModel: makeMenuViewModel())
    }
}
