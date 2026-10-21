//
//  AccountSettingsView.swift
//  softwarePracticum
//

import SwiftUI

struct AccountSettingsView: View {
    @Binding var isLoggedIn: Bool

    @State private var units = "Meters"
    @State private var notificationsEnabled = false
    @State private var autoConnectEnabled = false

    var body: some View {
        Form {
            Section("Account") {
                LabeledContent("Name", value: "")
                LabeledContent("Phone Number", value: "")
                Picker("Units", selection: $units) {
                    Text("Meters").tag("Meters")
                    Text("Feet").tag("Feet")
                }
                Toggle("Notifications", isOn: $notificationsEnabled)
            }

            Section("Device") {
                LabeledContent("Connected Device", value: "")
                Toggle("Auto Connect", isOn: $autoConnectEnabled)
            }

            Section {
                Button("Log Out", role: .destructive) {
                    // TODO: Clear the user's session.
                    isLoggedIn = false
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Account Settings")
    }
}

#Preview {
    NavigationStack {
        AccountSettingsView(isLoggedIn: .constant(true))
    }
}
