//
//  DataDetailView.swift
//  softwarePracticum
//

import SwiftUI

struct DataDetailView: View {
    var body: some View {
        List {
            Section("Collected") {
                LabeledContent("Time", value: "")
                LabeledContent("Location", value: "")
            }

            Section("Readings") {
                // TODO: Add charts/graphs of the request's data (Swift Charts).
                ContentUnavailableView("No Readings", systemImage: "chart.xyaxis.line")
                    .frame(height: 240)
            }

            Section {
                Button {
                    // TODO: Upload data to the backend.
                } label: {
                    Label("Upload Data", systemImage: "icloud.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Data Detail")
        .inlineNavigationTitle()
    }
}

#Preview {
    NavigationStack {
        DataDetailView()
    }
}
