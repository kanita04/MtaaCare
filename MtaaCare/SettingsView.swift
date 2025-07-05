import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var pushNotifications = true
    @State private var darkMode = false
    @State private var selectedLanguage = "English"

    @State private var userName: String = ""
    @State private var userEmail: String = ""

    var body: some View {
        VStack(spacing: 24) {

            // Header
            HStack {
                Text("Settings")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)

            // User Info
            HStack(spacing: 16) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading) {
                    Text(userName).bold()
                    Text(userEmail)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal)

            // Settings Cards
            VStack(spacing: 16) {
                settingRow(icon: "globe", title: "Language", trailingText: selectedLanguage)
                ToggleSettingRow(icon: "bell.fill", title: "Push Notifications", isOn: $pushNotifications)
                ToggleSettingRow(icon: "moon.fill", title: "Dark Mode", isOn: $darkMode)
            }
            .padding(.horizontal)

            // Logout Button
            Button(action: {
                appState.logout()
            }) {
                HStack {
                    Image(systemName: "arrow.right.square")
                    Text("Logout").bold()
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(20)
            }
            .padding(.horizontal)

            Spacer()

            // Footer
            VStack(spacing: 4) {
                Text("MtaaCare v1")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text("© 2025 MtaaCare. All rights reserved.")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 16)
        }
        .padding(.top)
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            fetchUserInfo()
        }
    }

    // MARK: - Fetch user info
    func fetchUserInfo() {
        guard let user = Auth.auth().currentUser else { return }

        userEmail = user.email ?? ""

        // If name is stored in Firestore:
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            if let data = snapshot?.data(), let name = data["fullName"] as? String {
                userName = name
            } else {
                userName = "Resident"
            }
        }
    }

    // MARK: - UI Components
    func settingRow(icon: String, title: String, trailingText: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.black)
            Text(title).bold()
            Spacer()
            Text(trailingText)
                .foregroundColor(.gray)
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ToggleSettingRow: View {
    var icon: String
    var title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.black)
            Text(title).bold()
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
