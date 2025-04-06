import Foundation
import SwiftUI
import Combine

// MARK: - AppState

enum AppState {
    case loading
    case login
    case main
}

// MARK: - App Coordinator

class AppCoordinator: ObservableObject {
    @Published var appState: AppState = .loading
    
    // Auth status
    @Published var isAuthenticated = false
    
    // User tokens (in a real app these would be securely stored)
    private var authToken: String?
    private var refreshToken: String?
    
    // Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Check if user is already authenticated
        checkAuthentication()
    }
    
    // Check if user is authenticated
    private func checkAuthentication() {
        // In a real app, we would check for valid tokens in the keychain
        // For demo purposes, just set to false to show login screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.isAuthenticated = false
            self?.appState = self?.isAuthenticated == true ? .main : .login
        }
    }
    
    // Handle successful login
    func handleSuccessfulLogin(token: String, refreshToken: String) {
        // Store tokens (in a real app, this would use the keychain)
        self.authToken = token
        self.refreshToken = refreshToken
        
        // Update authentication state
        isAuthenticated = true
        appState = .main
    }
    
    // Handle logout
    func logout() {
        // Clear tokens
        authToken = nil
        refreshToken = nil
        
        // Update authentication state
        isAuthenticated = false
        appState = .login
    }
    
    // Content view for current app state
    @ViewBuilder
    func contentForCurrentState() -> some View {
        switch appState {
        case .loading:
            LoadingView()
        case .login:
            LoginView(viewModel: DIContainer.shared.makeLoginViewModel())
        case .main:
            MenuHomeView(viewModel: DIContainer.shared.makeMenuViewModel())
                .environmentObject(self)
        }
    }
}