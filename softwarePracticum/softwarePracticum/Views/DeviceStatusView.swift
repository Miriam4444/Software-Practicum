//
//  DeviceStatusView.swift
//  softwarePracticum
//

import SwiftUI

struct DeviceStatusView: View {
    var body: some View {
        List {
            Section("Current Device") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("No device connected")
                            .font(.headline)
                        Text("Disconnected")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button("Disconnect", role: .destructive) {
                        // TODO: Disconnect from the current device.
                    }
                    .buttonStyle(.bordered)
                    .disabled(true)
                }
            }

            Section("Saved Devices") {
                // TODO: List saved devices; tapping one connects to it.
                Text("No saved devices")
                    .foregroundStyle(.secondary)
            }

            Section("Available Devices") {
                // TODO: List scanned devices; tapping one connects to it.
                Text("No devices found")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Device Status")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Scan for Devices") {
                    // TODO: Start scanning for Bluetooth devices.
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeviceStatusView()
    }
}
