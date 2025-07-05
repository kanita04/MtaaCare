//
//  SignUpView.swift
//  MtaaCare

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignupView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @State private var fullName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Create Account")
                .font(.title)
                .bold()

            Group {
                CustomInputField(placeholder: "Full Name", text: $fullName)
                CustomInputField(placeholder: "Email Address", text: $email, keyboardType: .emailAddress)
                CustomInputField(placeholder: "Phone Number", text: $phone, keyboardType: .phonePad)

                CustomSecureInputField(placeholder: "Password", text: $password, isSecure: !showPassword)
                CustomSecureInputField(placeholder: "Confirm Password", text: $confirmPassword, isSecure: !showConfirmPassword)
            }

            Button(action: {
                errorMessage = ""

                //Input validation
                guard !fullName.isEmpty, !email.isEmpty, !password.isEmpty else {
                    errorMessage = "Please fill all required fields."
                    return
                }

                guard password == confirmPassword else {
                    errorMessage = "Passwords do not match."
                    return
                }

                //Firebase Auth
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let user = result?.user {
                        // Save user profile to Firestore
                        let db = Firestore.firestore()
                        db.collection("users").document(user.uid).setData([
                            "fullName": fullName,
                            "email": email,
                            "phone": phone,
                            "role": "resident",
                            "createdAt": Timestamp()
                        ]) { err in
                            if let err = err {
                                errorMessage = "Failed to save user data: \(err.localizedDescription)"
                            } else {
                                //Move to MainTabView
                                appState.isLoggedIn = true
                                dismiss()
                            }
                        }
                    } else if let error = error {
                        errorMessage = error.localizedDescription
                    }
                }
            }) {
                Text("Create Account")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.mtaaGreen)
                    .cornerRadius(10)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            HStack {
                Text("Already have an account?")
                Button("Sign In") {
                    appState.isLoggedIn = false
                    dismiss()
                }
                .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    SignupView()
}

