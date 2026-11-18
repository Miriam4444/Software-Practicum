//
//  DeviceStatusView.swift
//  softwarePracticum
//
import SwiftUI

//struct DeviceStatusView: View {
  //  @StateObject private var ble = BLEReceiver()

    /// `BLEReceiver` only tells us about connection through its status string,
    /// so we infer "connected" from the states it sets after a link is up.
    /*private var isConnected: Bool {
        switch ble.status {
        case "Connected", "Listening for JSON", "Received ✓":
            return true
        default:
            return ble.status.hasPrefix("Got data")
        }
    }

    var body: some View {
        List {
            Section("Current Device") {
                HStack {
                    VStack(alignment: .leading) {
                        Text(isConnected ? "Water-quality sensor" : "No device connected")
                            .font(.headline)
                        Text(ble.status)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if !isConnected {
                        ProgressView()
                    }
                }
            }

            Section("Latest Readings") {
                if ble.messages.isEmpty {
                    Text(isConnected ? "Waiting for data…" : "No readings yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(Array(ble.messages.enumerated()), id: \.offset) { _, m in
                        DeviceReadingRow(m: m)
                    }
                }
            }

            if !ble.lastRawJSON.isEmpty {
                Section("Last raw JSON") {
                    Text(ble.lastRawJSON)
                        .font(.system(.footnote, design: .monospaced))
                }
            }
        }
        .navigationTitle("Device Status")
    }
}*/
struct ReceiverView: View {
    @StateObject private var ble = BLEReceiver()

    var body: some View {
        NavigationStack {
            List {
                Section("Status") { Text(ble.status) }

                if !ble.lastRawJSON.isEmpty {
                    Section("Last raw JSON") {
                        Text(ble.lastRawJSON).font(.system(.footnote, design: .monospaced))
                    }
                }

                Section("Messages") {
                    if ble.messages.isEmpty {
                        Text("Nothing yet").foregroundStyle(.secondary)
                    }
                    ForEach(Array(ble.messages.enumerated()), id: \.offset) { _, m in
                        DeviceReadingRow(m: m)
                    }
                }
            }
            .navigationTitle("Receiver")
        }
    }
}

private struct DeviceReadingRow: View {
    let m: Message

    var body: some View {
        let header = m.title + " · " + m.station
        let line1 = String(format: "Temp %.1f °C · pH %.1f", m.waterTemperature, m.ph)
        let line2 = String(format: "Cond %.0f µS/cm · Turb %.1f NTU", m.conductivity, m.turbidity)
        let line3 = String(format: "DO %.1f mg/L (%.0f%%)", m.dissolvedOxygen, m.saturationDO)
        let time = m.sentAt.formatted(date: .omitted, time: .standard)

        return VStack(alignment: .leading, spacing: 4) {
            Text(header).font(.headline)
            Text(line1)
            Text(line2)
            Text(line3)
            Text(time).font(.caption).foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        ReceiverView()
    }
}
