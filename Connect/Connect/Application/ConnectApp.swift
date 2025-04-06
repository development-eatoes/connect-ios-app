import SwiftUI

@main
struct ConnectApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            appCoordinator.contentForCurrentState()
                .environmentObject(appCoordinator)
        }
    }
}