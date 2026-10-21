//
//  RegistrationView.swift
//  softwarePracticum
//

import SwiftUI

struct RegistrationView: View {
    @Binding var isLoggedIn: Bool

    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            TextField("Name", text: $name)
                .textContentType(.name)
                .padding()
                .background(.quaternary, in: .rect(cornerRadius: 12))

            TextField("Phone Number", text: $phoneNumber)
                .phoneNumberInput()
                .padding()
                .background(.quaternary, in: .rect(cornerRadius: 12))

            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            Button {
                register()
            } label: {
                Text("Register")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Spacer()
        }
        .padding()
        .navigationTitle("Register")
    }

    private func register() {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Please enter your name."
            return
        }
        if phoneNumber.filter(\.isNumber).count < 10 {
            errorMessage = "Please enter a valid phone number."
            return
        }
        errorMessage = nil

        // TODO: Call RegisterUser to send name and phone number to the backend.
        isLoggedIn = true
    }
}

#Preview {
    NavigationStack {
        RegistrationView(isLoggedIn: .constant(false))
    }
}
