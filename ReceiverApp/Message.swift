import Foundation

// The JSON payload. Must be IDENTICAL in both apps.
struct Message: Codable, Equatable {
    var title: String
    var body: String
    var sentAt: Date
    var source: String
    var station: String
    var conductivity: Double
    var waterTemperature: Double
    var dissolvedOxygen: Double
    var saturationDO: Double
    var ph: Double
    var turbidity: Double
    var notes: String? = nil
    // Comma-separated names. Must not be empty until login is added.
    var fieldMembers: String
}

extension JSONEncoder {
    static let ble: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()
}

extension JSONDecoder {
    static let ble: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
}

extension Message {
    static func random(count: Int) -> Message {
        func r(_ range: ClosedRange<Double>, _ places: Double = 1) -> Double {
            let p = pow(10, places)
            return (Double.random(in: range) * p).rounded() / p
        }

        return Message(
            title: "Reading #\(count)",
            body: "Randomized test data",
            sentAt: .now,
            source: "dealLake",
            station: "Station \(Int.random(in: 1...3))",
            conductivity: r(300...600, 0),
            waterTemperature: r(10...25),
            dissolvedOxygen: r(6...10),
            saturationDO: r(80...105, 0),
            ph: r(6.5...8.5),
            turbidity: r(0.5...10),
            fieldMembers: "Test User"
        )
    }
}
