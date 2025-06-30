//
//  SplashScreen.swift
//  MtaaCare

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            //
        } else {
            VStack {
                Spacer()
                Image("logo") // Make sure this image exists in Assets.xcassets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                Text("MtaaCare")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 30)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}


