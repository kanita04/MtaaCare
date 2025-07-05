//
//  SplashScreen.swift
//  MtaaCare

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                Text("MtaaCare")
                    .font(.title)
                    .fontWeight(.bold)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 20)

                Spacer()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    isActive = true
                }
            }
            // ✅ This is the new way in iOS 16+
            .navigationDestination(isPresented: $isActive) {
                LoginView()
            }
        }
    }
}
