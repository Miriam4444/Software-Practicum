//
//  LoginView.swift
//  softwarePracticum
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool

    @State private var phoneNumber = ""

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Welcome")
                .font(.largeTitle.bold())

            TextField("Phone Number", text: $phoneNumber)
                .phoneNumberInput()
                .padding()
                .background(.quaternary, in: .rect(cornerRadius: 12))

            Button {
                // TODO: Send phone number to the backend for authentication.
                isLoggedIn = true
            } label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(phoneNumber.isEmpty)

            Spacer()

            HStack {
                Text("Don't have an account?")
                NavigationLink("Register") {
                    RegistrationView(isLoggedIn: $isLoggedIn)
                }
            }
            .font(.callout)
        }
        .padding()
        .navigationTitle("Login")
        .inlineNavigationTitle()
    }
}

#Preview {
    NavigationStack {
        LoginView(isLoggedIn: .constant(false))
    }
}
