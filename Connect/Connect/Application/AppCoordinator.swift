import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    enum AppScreen {
        case login
        case menu
    }
    
    @Published var currentScreen: AppScreen = .login
    @Published var isAuthenticated = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // For a real app, check for user session in keychain/UserDefaults
        checkAuthentication()
    }
    
    private func checkAuthentication() {
        // In a real app, we would check for an existing session token
        // For now, always start at the login screen
        isAuthenticated = false
        currentScreen = .login
    }
    
    func userDidAuthenticate() {
        isAuthenticated = true
        currentScreen = .menu
    }
    
    func logout() {
        isAuthenticated = false
        currentScreen = .login
    }
}