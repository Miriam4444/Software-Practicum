import SwiftUI

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
                        VStack(alignment: .leading, spacing: 4) {
                            Text(m.title).font(.headline)
                            Text(m.body)
                            Text(m.sentAt.formatted(date: .omitted, time: .standard))
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Receiver")
        }
    }
}
