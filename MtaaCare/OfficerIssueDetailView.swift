//
//  OfficerIssueDetailView.swift
//  MtaaCare

import SwiftUI
import FirebaseFirestore

struct OfficerIssueDetailView: View {
    var issue: IssueModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var newStatus: String = ""
    @State private var officerComment: String = ""
    @State private var isSubmitting = false

    let statusOptions = ["Pending", "In Progress", "Resolved"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Title + Back
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }

                    Text(issue.title)
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                }

                // Image + Reporter
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

                // Current Status
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
                infoRow(icon: "tag", label: "Category", value: issue.category)
                infoRow(icon: "mappin.and.ellipse", label: "Location", value: issue.location)
                infoRow(icon: "clock", label: "Reported", value: issue.reportedDateFormatted)

                Divider()

                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                    Text(issue.description)
                        .foregroundColor(.secondary)
                }

                Divider()

                // Update Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Update Status")
                        .font(.headline)

                    Picker("Status", selection: $newStatus) {
                        ForEach(statusOptions, id: \.self) { status in
                            Text(status).tag(status)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                    Text("Officer Comments")
                        .font(.headline)

                    TextEditor(text: $officerComment)
                        .frame(height: 100)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }

                // Submit
                Button {
                    submitUpdate()
                } label: {
                    Text("Submit Update")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.mtaaGreen)
                        .cornerRadius(12)
                }
                .disabled(isSubmitting)

                // Previous updates (mocked here, dynamic optional)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Previous Updates")
                        .font(.headline)
                    OfficerUpdateCard(comment: "Team dispatched for initial assessment. Equipment and materials being arranged.", status: "In Progress", timestamp: "04-05-2025 10:30am")
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarHidden(true)
    }

    func submitUpdate() {
        isSubmitting = true

        let db = Firestore.firestore()
        let update = [
            "comment": officerComment,
            "status": newStatus,
            "timestamp": FieldValue.serverTimestamp()
        ] as [String : Any]

        db.collection("reports")
            .document(issue.id ?? "")
            .updateData([
                "status": newStatus,
                "updates": FieldValue.arrayUnion([update])
            ]) { error in
                isSubmitting = false
                if error == nil {
                    officerComment = ""
                    newStatus = ""
                }
            }
    }

    func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
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

    func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "resolved": return .green
        case "in progress": return .yellow
        default: return .red
        }
    }
}

struct OfficerUpdateCard: View {
    var comment: String
    var status: String
    var timestamp: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(timestamp)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text(status)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor(status).opacity(0.2))
                    .foregroundColor(statusColor(status))
                    .cornerRadius(8)
            }
            Text(comment)
                .font(.body)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 2)
    }

    func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "resolved": return .green
        case "in progress": return .yellow
        default: return .red
        }
    }
}
