//
//  ContentView.swift
//  softwarePracticum
//
//  Created by Miriam Abecasis on 10/13/26.
//

import SwiftUI

/// Root view: shows the login flow until the user is logged in,
/// then the main tab interface.
struct ContentView: View {
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            MainTabView(isLoggedIn: $isLoggedIn)
        } else {
            NavigationStack {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}

#Preview {
    ContentView()
}
