import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.isLoading {
            SplashScreen()
        } else if appState.isLoggedIn {
            switch appState.userRole {
            case .resident:
                MainTabView()      // Resident user
            case .officer:
                OfficerTabView()   // Officer user
            }
        } else {
            LoginView()
        }
    }
}
