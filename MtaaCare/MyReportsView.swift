import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestore

struct MyReportsView: View {
    @State private var reports: [IssueModel] = []
    @State private var isLoading = true
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {

                // Header
                HStack {
                    HStack(spacing: 10) {
                        Image(systemName: "person.crop.circle")
                            .font(.system(size: 30))
                        VStack(alignment: .leading) {
                            Text("My Reports").bold()
                            Text("Resident").font(.caption).foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)

                // Content
                if isLoading {
                    ProgressView("Loading reports...")
                        .padding()
                } else if !errorMessage.isEmpty {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if reports.isEmpty {
                    Text("You haven't reported any issues yet.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(reports) { report in
                                NavigationLink(destination: IssueDetailView(issue: report)) {
                                    ReportCardView(report: report)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

            }
            .padding(.top)
            .background(Color(.systemGroupedBackground))
            .onAppear { fetchReports() }
        }
    }

    func fetchReports() {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "User not authenticated."
            isLoading = false
            return
        }

        let db = Firestore.firestore()
        db.collection("reports")
          .whereField("userId", isEqualTo: uid)
          .getDocuments { snapshot, error in
              isLoading = false

              if let error = error {
                  errorMessage = "Failed to load reports: \(error.localizedDescription)"
                  return
              }

              guard let documents = snapshot?.documents else { return }

              self.reports = documents.compactMap { doc in
                  try? doc.data(as: IssueModel.self)
              }
              .sorted { ($0.timestamp) > ($1.timestamp) }
          }
    }

}
