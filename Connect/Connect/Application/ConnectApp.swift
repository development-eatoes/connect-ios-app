import SwiftUI

@main
struct ConnectApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appCoordinator)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        Group {
            switch appCoordinator.currentScreen {
            case .login:
                LoginView(viewModel: DIContainer.shared.makeLoginViewModel())
                    .onReceive(DIContainer.shared.makeOTPViewModel().onVerificationSuccess) { _ in
                        appCoordinator.userDidAuthenticate()
                    }
                
            case .menu:
                MenuHomeView(viewModel: DIContainer.shared.makeMenuViewModel())
            }
        }
    }
}