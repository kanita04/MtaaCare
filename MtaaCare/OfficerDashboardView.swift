//
//  OfficerDashboardView.swift
//  MtaaCare

import SwiftUI
import FirebaseFirestore

struct OfficerDashboardView: View {
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    @State private var reports: [IssueModel] = []

    let statusOptions = ["All", "Pending", "In Progress", "Resolved"]

    var filteredReports: [IssueModel] {
        reports.filter { report in
            (selectedFilter == "All" || report.status == selectedFilter) &&
            (searchText.isEmpty || report.title.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        NavigationStack{
            VStack(spacing: 16) {
                
                // Header
                HStack {
                    Text("Dashboard").bold()
                    Spacer()
                    Image(systemName: "bell")
                    Image(systemName: "person.circle")
                }
                .font(.title3)
                .padding(.horizontal)
                
                // Search Bar
                HStack {
                    TextField("Search issues...", text: $searchText)
                        .padding(10)
                    Image(systemName: "magnifyingglass")
                        .padding(.trailing, 10)
                }
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Status Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(statusOptions, id: \.self) { status in
                            Button(action: {
                                selectedFilter = status
                            }) {
                                Text(status)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedFilter == status ? Color.mtaaGreen : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedFilter == status ? .white : .black)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("Dashboard")
                .navigationBarHidden(true)
                
                // Reports List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredReports) { report in
                            OfficerReportCard(report: report)
                        }
                    }
                    .padding(.horizontal)
                }
                
            }
            .onAppear {
                fetchReports()
            }
        }
    }

    func fetchReports() {
        let db = Firestore.firestore()
        db.collection("reports").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching reports: \(error.localizedDescription)")
                return
            }

            self.reports = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                let reporterName = data["reporterName"] as? String ?? "Unknown Reporter"
                let imageURL = data["imageURL"] as? String ?? ""

                guard let title = data["description"] as? String,
                      let description = data["description"] as? String,
                      let category = data["category"] as? String,
                      let status = data["status"] as? String,
                      let location = data["location"] as? String,
                      let userId = data["userId"] as? String,
                      let timestamp = (data["timestamp"] as? Timestamp)?.dateValue()
                else {
                    return nil
                }

                return IssueModel(
                    id: doc.documentID,
                    title: title,
                    description: description,
                    category: category,
                    location: location,
                    imageURL: imageURL,
                    timestamp: timestamp,
                    userId: userId,
                    reporterName: reporterName,
                    status: status
                )
            } ?? []
        }
    }
}

#Preview {
    OfficerDashboardView()
}
