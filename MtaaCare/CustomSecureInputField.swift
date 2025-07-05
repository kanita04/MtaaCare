//
//  CustomSecureInputField.swift
//  MtaaCare

import SwiftUI

struct CustomSecureInputField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = true

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.4)))
    }
}

