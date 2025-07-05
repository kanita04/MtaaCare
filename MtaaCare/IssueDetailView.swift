//
//  IssueDetailView.swift
//  MtaaCare

import SwiftUI

struct IssueDetailView: View {
    var issue: IssueModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Title and Back
                HStack {
                    Button(action: {
                         dismiss() 
                     }) {
                         Image(systemName: "chevron.left")
                             .foregroundColor(.primary)
                     }

                     Text(issue.title)
                         .font(.headline)
                         .lineLimit(1)
                         .truncationMode(.tail)

                     Spacer()
                 }
                 .padding(.bottom, 4)

                // Image + Reporter overlay
                ZStack(alignment: .bottomTrailing) {
                    Image(issue.categoryImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()

                    Text("Reported by: \(issue.reporterName)")
                        .font(.caption)
                        .padding(6)
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }


                // Status badge
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text(issue.status)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor(issue.status).opacity(0.2))
                        .foregroundColor(statusColor(issue.status))
                        .cornerRadius(8)
                }

                Divider()

                // Info Rows
                VStack(alignment: .leading, spacing: 8) {
                    infoRow(icon: "tag", label: "Category", value: issue.category)
                    infoRow(icon: "mappin.and.ellipse", label: "Location", value: issue.location)
                    infoRow(icon: "clock", label: "Reported", value: issue.reportedDateFormatted)
                }

                Divider()

                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                    Text(issue.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                Divider()

                // Progress Timeline (Static example)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Progress Timeline")
                        .font(.headline)

                    timelineRow(icon: "checkmark.circle.fill", label: "Issue Reported", date: "May 12, 10:30am", iconColor: .green)
                    timelineRow(icon: "wrench.and.screwdriver.fill", label: "Work In Progress", date: "May 20, 9:00am", iconColor: .yellow)
                    timelineRow(icon: "doc.text", label: "Resolution Pending", date: nil, iconColor: .gray.opacity(0.5))
                }

                Spacer()
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
    }

    func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.primary)
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.body)
            }
        }
    }

    func timelineRow(icon: String, label: String, date: String?, iconColor: Color) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
            VStack(alignment: .leading) {
                Text(label)
                    .font(.body)
                if let date = date {
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }

    func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "resolved": return .green
        case "in progress": return .yellow
        default: return .red
        }
    }
}

