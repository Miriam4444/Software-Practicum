//
//  MainTabView.swift
//  softwarePracticum
//

import SwiftUI

/// The bottom tab bar shown across the four main views.
struct MainTabView: View {
    @Binding var isLoggedIn: Bool

    var body: some View {
        TabView {
            Tab("Devices", systemImage: "antenna.radiowaves.left.and.right") {
                NavigationStack {
                    DeviceStatusView()
                }
            }

            Tab("Data", systemImage: "list.bullet.rectangle") {
                NavigationStack {
                    DataHistoryView()
                }
            }

            Tab("Help", systemImage: "questionmark.circle") {
                NavigationStack {
                    BluetoothHelpView()
                }
            }

            Tab("Settings", systemImage: "gearshape") {
                NavigationStack {
                    AccountSettingsView(isLoggedIn: $isLoggedIn)
                }
            }
        }
    }
}

#Preview {
    MainTabView(isLoggedIn: .constant(true))
}
