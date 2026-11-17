//
//  WaterTestingService.swift
//  softwarePracticum
//
//  Created by Miriam Abecasis on 10/21/26.
//  Mirrors Backend/model/waterdata.py and calls Backend/routes/waterdata.py.

import Foundation

// Raw values must match the backend enums exactly.
nonisolated enum Waterbody: String, Codable, CaseIterable {
    case fletcherLake = "Fletcher Lake"
    case dealLake = "Deal Lake"
    case jacksonWoods = "Jackson Woods"
    case lakeComo = "Lake Como"
    case lakeTakanasseeWhalePondBrook = "Lake Takanassee / Whale Pond Brook"
    case shadowLake = "Shadow Lake"
    case silverLake = "Silver Lake"
    case springLake = "Spring Lake"
    case sunsetLake = "Sunset Lake"
    case sylvanLake = "Sylvan Lake"
    case wesleyLake = "Wesley Lake"
    case wreckPond = "Wreck Pond"
}

nonisolated enum WeatherConditions: String, Codable, CaseIterable {
    case storm = "Storm (heavy rain)"
    case rain = "Rain (steady rain)"
    case showers = "Showers (intermittent rain)"
    case overcast = "Overcast"
    case clear = "CLEAR/SUNNY"
}

/// A reading the backend accepts as either a number or "N/A".
nonisolated enum Reading: Codable {
    case value(Double)
    case notAvailable

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Double.self) {
            self = .value(value)
        } else {
            self = .notAvailable
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .value(let value): try container.encode(value)
        case .notAvailable: try container.encode("N/A")
        }
    }
}

/// Body for POST /waterdata (WaterdataCreate on the backend).
nonisolated struct WaterdataCreate: Encodable {
    var source: Waterbody
    var station: String
    var conductivity: Double
    var waterTemperature: Double
    var dissolvedOxygen: Double
    var saturationDO: Double
    var ph: Double
    var nitrate: Reading = .notAvailable
    var ammonium: Reading = .notAvailable
    var phosphate: Reading = .notAvailable
    var turbidity: Double
    var pcFluoroSense: Reading = .notAvailable
    var pastWeather: WeatherConditions
    var currWeather: WeatherConditions
    var notes: String? = nil
    // Comma-separated names. Must not be empty until login is added.
    var fieldMembers: String
}

/// What POST /waterdata returns. Extra fields in the response are ignored.
nonisolated struct Waterdata: Decodable {
    let id: String?
    let source: Waterbody
    let station: String
    let fieldMembers: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case source, station, fieldMembers, created
    }
}

enum WaterTestingService {
    static func upload(_ reading: WaterdataCreate) async throws -> Waterdata {
        try await APIClient.post("waterdata", body: reading)
    }
}

extension WaterdataCreate {
    // Placeholder until readings come from the Bluetooth device.
    static let sample = WaterdataCreate(
        source: .dealLake,
        station: "Station 1",
        conductivity: 450,
        waterTemperature: 18.5,
        dissolvedOxygen: 8.2,
        saturationDO: 92,
        ph: 7.4,
        turbidity: 3.1,
        pastWeather: .clear,
        currWeather: .overcast,
        fieldMembers: "Test User"
    )
}
