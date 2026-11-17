//
//  DataHistoryView.swift
//  softwarePracticum
//

import SwiftUI

struct DataHistoryView: View {
    var body: some View {
        // TODO: Replace with real data requests from the device. Each row should
        // show an uploaded/not-uploaded icon ("checkmark.icloud.fill" / "icloud.slash").
        List {
            NavigationLink("Sample Reading (test upload)") {
                DataDetailView(reading: .sample)
            }
        }
        .navigationTitle("Data History")
    }
}

#Preview {
    NavigationStack {
        DataHistoryView()
    }
}
