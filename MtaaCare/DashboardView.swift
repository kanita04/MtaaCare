//
//  DashboardView.swift
//  MtaaCare

import SwiftUI
import MapKit

struct DashboardView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -1.2921, longitude: 36.8219), // Nairobi
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )

    // Sample issue annotations
    let issues: [IssueAnnotation] = [
        IssueAnnotation(title: "Pothole on Moi Avenue", coordinate: CLLocationCoordinate2D(latitude: -1.28, longitude: 36.82), color: .red),
        IssueAnnotation(title: "Garbage Collection", coordinate: CLLocationCoordinate2D(latitude: -1.31, longitude: 36.83), color: .yellow),
        IssueAnnotation(title: "Broken Street Light", coordinate: CLLocationCoordinate2D(latitude: -1.29, longitude: 36.81), color: .green)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                //Search/location bar
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.gray)
                    Text("Nairobi")
                        .font(.subheadline)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                //Apple Map
                Map(initialPosition: MapCameraPosition.region(region)) {
                    ForEach(issues) { issue in
                        Annotation(issue.title, coordinate: issue.coordinate) {
                            Circle()
                                .fill(issue.color)
                                .frame(width: 16, height: 16)
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        }
                    }
                }
                .frame(height: 300)
                .cornerRadius(12)
                .padding(.horizontal)


                //Nearby Issues
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nearby Issues")
                        .font(.headline)

                    IssueCard(title: "Pothole on Moi Avenue", category: "Roads", status: "New", color: .red)
                    IssueCard(title: "Garbage Collection", category: "Sanitation", status: "In Progress", color: .yellow)
                    IssueCard(title: "Broken Street Light", category: "Infrastructure", status: "Resolved", color: .green)
                }
                .padding(.horizontal)

                //Report Button
                Button(action: {
                    // TODO: Go to report form
                }) {
                    Text("Report An Issue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.mtaaGreen)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding(.top)
        }
    }
}


#Preview {
    DashboardView()
}
