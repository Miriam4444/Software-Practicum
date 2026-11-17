//
//  BluetoothHelpView.swift
//  softwarePracticum
//

import SwiftUI

struct BluetoothHelpView: View {
    private let appleBluetoothHelpURL = URL(string: "https://support.apple.com/en-us/HT204091")

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("How to Connect")
                        .font(.headline)

                    Text("""
                    1. Make sure Bluetooth is turned on in Settings or Control Center.
                    2. Power on your device and keep it close to your iPhone.
                    3. Open the Devices tab and tap “Scan for Devices”.
                    4. Select your device from the list of available devices.
                    5. Once connected, the device status will show “Connected”.
                    """)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.quaternary, in: .rect(cornerRadius: 12))

                if let appleBluetoothHelpURL {
                    Link(destination: appleBluetoothHelpURL) {
                        Label("Apple Bluetooth Support", systemImage: "arrow.up.right.square")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Bluetooth Help")
    }
}

#Preview {
    NavigationStack {
        BluetoothHelpView()
    }
}
