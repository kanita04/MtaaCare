//
//  CustomInputField.swift
//  MtaaCare

import SwiftUI

struct CustomInputField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .keyboardType(keyboardType)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.4)))
    }
}


