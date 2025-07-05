import Foundation
import FirebaseAuth
import FirebaseFirestore

enum UserRole {
    case resident
    case officer
}

class AppState: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var isLoggedIn: Bool = false
    @Published var userRole: UserRole = .resident  // default

    init() {
        checkAuthStatus()
    }

    func checkAuthStatus() {
        if let currentUser = Auth.auth().currentUser {
            fetchUserRole(for: currentUser.uid)
        } else {
            self.isLoggedIn = false
            self.isLoading = false
        }
    }

    private func fetchUserRole(for uid: String) {
        let db = Firestore.firestore()

        db.collection("users").document(uid).getDocument { snapshot, error in
            DispatchQueue.main.async {
                if let data = snapshot?.data(), let role = data["role"] as? String {
                    self.userRole = role.lowercased() == "officer" ? .officer : .resident
                } else {
                    self.userRole = .resident // fallback
                }
                self.isLoggedIn = true
                self.isLoading = false
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
        } catch {
            print("Logout failed: \(error.localizedDescription)")
        }
    }
}
