//
//  LoginView.swift
//  SoftwarePracticum
//
//  Created by Miriam Abecasis on 9/24/26.
//

import SwiftUI

struct LoginView: View {
    @State private var name = ""
    @State private var isLoggedIn = false

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Text("Welcome")
                    .font(.largeTitle)
                    .bold()

                Text("Enter your name to continue")
                    .foregroundStyle(.secondary)

                TextField("Name", text: $name)
                    .textContentType(.name)
                    .autocorrectionDisabled()
                    .submitLabel(.go)
                    .onSubmit(logIn)
                    .padding()
                    .background(Color(.blue))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Button(action: logIn) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .disabled(trimmedName.isEmpty)

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationDestination(isPresented: $isLoggedIn) {
                MainTabView()
            }
        }
    }
//move to VM
    private func logIn() {
        guard !trimmedName.isEmpty else { return }
        isLoggedIn = true
    }
}

#Preview {
    LoginView()
}
