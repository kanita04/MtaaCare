//
//  LoginView.swift
//  MtaaCare

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var navigateToSignup: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Logo
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)

            // App name
            Text("MtaaCare")
                .font(.title)
                .fontWeight(.bold)

            // Subtitle
            Text("Report and track civic issues in your neighborhood")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)

            // Email Field
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.horizontal)

            // Password Field
            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                } else {
                    SecureField("Password", text: $password)
                }

                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)

            // Sign In Button
            Button(action: {
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if let user = result?.user {
                        print("Signed in: \(user.uid)")
                        let db = Firestore.firestore()
                        db.collection("users").document(user.uid).getDocument { snapshot, error in
                            DispatchQueue.main.async {
                                if let data = snapshot?.data(), let role = data["role"] as? String {
                                    appState.userRole = role.lowercased() == "officer" ? .officer : .resident
                                } else {
                                    appState.userRole = .resident // fallback
                                }
                                appState.isLoggedIn = true
                            }
                        }
                    } else if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }) {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.mtaaGreen)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .padding(.horizontal)
            }

            // Sign Up Link
            HStack {
                Text("Don't have an account?")
                Button(action: {
                    navigateToSignup = true
                }) {
                    Text("Sign Up")
                        .foregroundColor(.blue)
                        .bold()
                }
            }

            .navigationDestination(isPresented: $navigateToSignup) {
                SignupView()
                    .environmentObject(appState)
            }
            
            Spacer()

            // Terms and Privacy
            Text("By continuing, you agree to our Terms & Privacy Policy")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
    }
}
