//
//  OfficerReportCard.swift
//  MtaaCare
//

import SwiftUI

struct OfficerReportCard: View {
    let report: IssueModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(report.title).bold()
                Spacer()
                Text(report.status)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor(report.status))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Text(report.category)
                .foregroundColor(.gray)

            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text(report.location)
                Spacer()
                Text("Reported: \(report.reportedDateFormatted)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 1)
    }

    func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "resolved": return .green
        case "in progress": return .yellow
        case "pending", "new": return .red
        default: return .gray
        }
    }
}

