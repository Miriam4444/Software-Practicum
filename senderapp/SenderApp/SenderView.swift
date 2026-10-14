import SwiftUI

struct SenderView: View {
    @StateObject private var ble = BLESender()
    @State private var title = "Hello"
    @State private var bodyText = "Sent over Bluetooth!"

    var body: some View {
        NavigationStack {
            Form {
                Section("Status") {
                    Label(ble.status, systemImage: ble.isSubscribed ? "link" : "antenna.radiowaves.left.and.right")
                }
                Section("Message") {
                    TextField("Title", text: $title)
                    TextField("Body", text: $bodyText, axis: .vertical)
                }
                Button("Send JSON") {
                    ble.send(Message(title: title, body: bodyText, sentAt: .now))
                }
                .disabled(!ble.isSubscribed)
            }
            .navigationTitle("Sender")
        }
    }
}
