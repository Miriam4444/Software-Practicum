import CoreBluetooth
import Foundation
import Combine

// Acts as a BLE *central*: scans for the sender, connects, subscribes, rebuilds the JSON.
final class BLEReceiver: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var status = "Starting…"
    @Published var messages: [Message] = []
    @Published var lastRawJSON = ""

    private var central: CBCentralManager!
    private var peripheral: CBPeripheral?
    private var buffer = Data()

    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: nil)
    }

    // MARK: Scanning / connecting

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard central.state == .poweredOn else {
            status = "Bluetooth unavailable (\(central.state.rawValue))"
            return
        }
        scan()
    }

    private func scan() {
        central.scanForPeripherals(withServices: [BLE.serviceUUID])
        status = "Scanning…"
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        central.stopScan()
        self.peripheral = peripheral          // must keep a strong reference
        peripheral.delegate = self
        central.connect(peripheral)
        status = "Connecting…"
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        status = "Connected"
        peripheral.discoverServices([BLE.serviceUUID])
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.peripheral = nil
        scan()
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.peripheral = nil
        buffer.removeAll()
        scan()                                 // auto-reconnect
    }

    // MARK: Discovery / subscribe

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let service = peripheral.services?.first(where: { $0.uuid == BLE.serviceUUID }) else { return }
        peripheral.discoverCharacteristics([BLE.characteristicUUID], for: service)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let c = service.characteristics?.first(where: { $0.uuid == BLE.characteristicUUID }) else { return }
        peripheral.setNotifyValue(true, for: c)
        status = "Listening for JSON"
    }

    // MARK: Receiving

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let chunk = characteristic.value else { return }

        if chunk == BLE.endMarker {
            lastRawJSON = String(decoding: buffer, as: UTF8.self)
            if let msg = try? JSONDecoder.ble.decode(Message.self, from: buffer) {
                messages.insert(msg, at: 0)
                status = "Received ✓"
            } else {
                status = "Got data but couldn't decode JSON"
            }
            buffer.removeAll()
        } else {
            buffer.append(chunk)
        }
    }
}
