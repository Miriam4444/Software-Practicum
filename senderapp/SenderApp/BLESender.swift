import CoreBluetooth
import Foundation
import Combine

// Acts as a BLE *peripheral*: advertises a service and pushes JSON to subscribers.
final class BLESender: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    @Published var status = "Starting…"
    @Published var isSubscribed = false

    private var manager: CBPeripheralManager!
    private var characteristic: CBMutableCharacteristic!
    private var subscriber: CBCentral?

    private var outgoing: [Data] = []   // chunks waiting to be sent

    override init() {
        super.init()
        manager = CBPeripheralManager(delegate: self, queue: nil)
    }

    // MARK: Public

    func send(_ message: Message) {
        guard let central = subscriber else { status = "No receiver connected"; return }
        guard let json = try? JSONEncoder.ble.encode(message) else { status = "Encode failed"; return }

        // BLE packets are small, so split the JSON into chunks the receiver can handle.
        let size = central.maximumUpdateValueLength
        outgoing = stride(from: 0, to: json.count, by: size).map {
            json.subdata(in: $0..<min($0 + size, json.count))
        }
        outgoing.append(BLE.endMarker)
        flush()
        status = "Sending \(json.count) bytes…"
    }

    // MARK: Sending

    private func flush() {
        while let chunk = outgoing.first {
            // Returns false when the transmit queue is full; we retry in peripheralManagerIsReady.
            guard manager.updateValue(chunk, for: characteristic, onSubscribedCentrals: nil) else { return }
            outgoing.removeFirst()
        }
        status = "Sent ✓"
    }

    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        flush()
    }

    // MARK: Setup

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        guard peripheral.state == .poweredOn else {
            status = "Bluetooth unavailable (\(peripheral.state.rawValue))"
            return
        }
        characteristic = CBMutableCharacteristic(
            type: BLE.characteristicUUID,
            properties: [.notify],
            value: nil,
            permissions: [.readable]
        )
        let service = CBMutableService(type: BLE.serviceUUID, primary: true)
        service.characteristics = [characteristic]
        peripheral.removeAllServices()
        peripheral.add(service)
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let error { status = "Add service error: \(error.localizedDescription)"; return }
        peripheral.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [BLE.serviceUUID],
            CBAdvertisementDataLocalNameKey: "JSONSender"
        ])
        status = "Advertising… waiting for receiver"
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral,
                           didSubscribeTo characteristic: CBCharacteristic) {
        subscriber = central
        isSubscribed = true
        status = "Receiver connected"
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral,
                           didUnsubscribeFrom characteristic: CBCharacteristic) {
        subscriber = nil
        isSubscribed = false
        outgoing.removeAll()
        status = "Receiver disconnected"
    }
}
