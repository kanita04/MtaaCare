//
//  MainTabView.swift
//  MtaaCare

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            MyReportsView()
                .tabItem {
                    Image(systemName: "doc.plaintext")
                    Text("Reports")
                }

            ReportIssueView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Report")
                }

            Text("Notifications") 
                .tabItem {
                    Image(systemName: "bell")
                    Text("Alerts")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .accentColor(.mtaaGreen)
    }
}
#Preview {
    MainTabView()
}

