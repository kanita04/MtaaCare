//
//  IssueCard.swift
//  MtaaCare

import SwiftUI

struct IssueCard: View {
    let title: String
    let category: String
    let status: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).bold()
            HStack {
                Text(category).font(.caption).foregroundColor(.gray)
                Spacer()
                Text(status)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.2))
                    .foregroundColor(color)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

