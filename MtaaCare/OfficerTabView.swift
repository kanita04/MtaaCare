//
//  OfficerTabView.swift
//  MtaaCare
//

import SwiftUI

struct OfficerTabView: View {
    var body: some View {
        TabView {
            OfficerDashboardView()
                .tabItem {
                    Image(systemName: "tray.full.fill")
                    Text("Reports")
                }

//            OfficerAnalyticsView()
            Text("Analytics")
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Analytics")
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
