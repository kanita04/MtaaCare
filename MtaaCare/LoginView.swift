//
//  LoginView.swift
//  MtaaCare

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Logo
            Text("MC")
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(Color.green)

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
                // TODO: Add sign-in logic
            }) {
                Text("Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .padding(.horizontal)
            }

            // Sign Up Link
            HStack {
                Text("Don't have an account?")
                Button(action: {
                    // TODO: Navigate to sign up screen
                }) {
                    Text("Sign Up")
                        .foregroundColor(.blue)
                        .bold()
                }
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

