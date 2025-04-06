import UIKit
import SwiftUI
import Combine

class AppCoordinator {
    private let window: UIWindow
    private let container: AppContainer
    private var cancellables = Set<AnyCancellable>()
    private var isLoggedIn = false
    
    init(window: UIWindow, container: AppContainer) {
        self.window = window
        self.container = container
    }
    
    func start() {
        if isLoggedIn {
            showMainScreen()
        } else {
            showLoginScreen()
        }
        
        window.makeKeyAndVisible()
    }
    
    private func showLoginScreen() {
        let loginViewModel = container.makeLoginViewModel()
        
        // Set up navigation callback
        loginViewModel.onLoginSuccess
            .sink { [weak self] in
                self?.showOTPScreen()
            }
            .store(in: &cancellables)
        
        let loginView = LoginView(viewModel: loginViewModel)
        let hostingController = UIHostingController(rootView: loginView)
        window.rootViewController = UINavigationController(rootViewController: hostingController)
    }
    
    private func showOTPScreen() {
        let otpViewModel = container.makeOTPViewModel()
        
        // Set up navigation callback
        otpViewModel.onVerificationSuccess
            .sink { [weak self] in
                self?.isLoggedIn = true
                self?.showMainScreen()
            }
            .store(in: &cancellables)
        
        let otpView = OTPView(viewModel: otpViewModel)
        let hostingController = UIHostingController(rootView: otpView)
        
        if let navigationController = window.rootViewController as? UINavigationController {
            navigationController.pushViewController(hostingController, animated: true)
        }
    }
    
    private func showMainScreen() {
        // Import the DigitalMenu module
        let menuView = container.makeMenuView()
        let hostingController = UIHostingController(rootView: menuView)
        window.rootViewController = UINavigationController(rootViewController: hostingController)
    }
}
