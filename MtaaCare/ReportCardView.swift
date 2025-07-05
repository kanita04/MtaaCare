//
//  ReportCardView.swift
//  MtaaCare

import SwiftUI

struct ReportCardView: View {
    let report: IssueModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(report.description.prefix(40))
                    .bold()
                Spacer()
                Text(report.status)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor(for: report.status))
                    .cornerRadius(8)
            }

            Text(report.category)
                .foregroundColor(.gray)
                .font(.subheadline)

            HStack {
                Text("Reported: \(report.reportedDateFormatted)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }

    func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "resolved": return Color.green.opacity(0.3)
        case "in progress": return Color.yellow.opacity(0.4)
        default: return Color.red.opacity(0.3)
        }
    }
}

