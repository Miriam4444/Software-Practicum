//
//  DataDetailView.swift
//  softwarePracticum
//

import SwiftUI

struct DataDetailView: View {
    var reading: WaterdataCreate = .sample

    @State private var status: String?
    @State private var isUploading = false

    var body: some View {
        List {
            Section("Collected") {
                LabeledContent("Time", value: "")
                LabeledContent("Location", value: "\(reading.source.rawValue), \(reading.station)")
            }

            Section("Readings") {
                // TODO: MAYBE Add charts/graphs of the request's data (Swift Charts).
                LabeledContent("Conductivity", value: reading.conductivity, format: .number)
                LabeledContent("Water Temperature", value: reading.waterTemperature, format: .number)
                LabeledContent("Dissolved Oxygen", value: reading.dissolvedOxygen, format: .number)
                LabeledContent("SaturationDO", value: reading.saturationDO, format: .number)
                LabeledContent("pH", value: reading.ph, format: .number)
                LabeledContent("Turbidity", value: reading.turbidity, format: .number)
                LabeledContent("Past Weather", value: reading.pastWeather.rawValue)
                LabeledContent("Current Weather", value: reading.currWeather.rawValue)
            }

            Section {
                Button {
                    upload()
                } label: {
                    Label("Upload Data", systemImage: "icloud.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .disabled(isUploading)

                if let status {
                    Text(status)
                        .font(.footnote)
                }
            }
        }
        .navigationTitle("Data Detail")
        .inlineNavigationTitle()
    }

    private func upload() {
        isUploading = true
        Task {
            do {
                let saved = try await WaterTestingService.upload(reading)
                status = "Uploaded (id: \(saved.id ?? "?"))"
            } catch {
                status = error.localizedDescription
            }
            isUploading = false
        }
    }
}

#Preview {
    NavigationStack {
        DataDetailView()
    }
}
