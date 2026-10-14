import Foundation

// The JSON payload. Must be IDENTICAL in both apps.
struct Message: Codable, Equatable {
    var title: String
    var body: String
    var sentAt: Date
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
