//
//  DataHistoryView.swift
//  softwarePracticum
//

import SwiftUI

struct DataHistoryView: View {
    var body: some View {
        // TODO: Replace with a List of data requests. Each row should be a
        // NavigationLink to DataDetailView and show an uploaded/not-uploaded
        // icon ("checkmark.icloud.fill" / "icloud.slash").
        ContentUnavailableView(
            "No Data",
            systemImage: "tray",
            description: Text("Data requests from your device will appear here.")
        )
        .navigationTitle("Data History")
    }
}

#Preview {
    NavigationStack {
        DataHistoryView()
    }
}
