//
//  RegistrationView.swift
//  SoftwarePracticum
//
//  Created by Miriam Abecasis on 9/24/26.
//
import SwiftUI

struct RegistrationView: View {
    
    enum Field { case username, phone }
 
    @State private var username = ""
    @State private var phone = ""
    @State private var isSubmitting = false
    @State private var showSuccess = false
    @FocusState private var focusedField: Field?
 
    // MARK: - Validation
 
    private var isUsernameValid: Bool {
        username.trimmingCharacters(in: .whitespaces).count >= 3
    }
 
    private var isPhoneValid: Bool {
        phone.filter(\.isNumber).count == 10
    }
 
    private var isFormValid: Bool { isUsernameValid && isPhoneValid }
 
    /// Binding that auto-formats the phone number as (555) 123-4567
    private var phoneBinding: Binding<String> {
        Binding(
            get: { phone },
            set: { phone = Self.formatPhone($0) }
        )
    }
 
    // MARK: - Body
 
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Create your account")
                            .font(.largeTitle.bold())
                        Text("Enter your details to get started.")
                            .foregroundStyle(.secondary)
                    }
 
                    // Username
                    inputField(
                        title: "Username",
                        icon: "person",
                        error: (!username.isEmpty && !isUsernameValid)
                            ? "Must be at least 3 characters." : nil
                    ) {
                        TextField("johndoe", text: $username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textContentType(.username)
                            .submitLabel(.next)
                            .focused($focusedField, equals: .username)
                            .onSubmit { focusedField = .phone }
                    }
 
                    // Phone number
                    inputField(
                        title: "Phone number",
                        icon: "phone",
                        error: (!phone.isEmpty && !isPhoneValid)
                            ? "Enter a valid 10-digit number." : nil
                    ) {
                        TextField("(555) 123-4567", text: phoneBinding)
                            .keyboardType(.phonePad)
                            .textContentType(.telephoneNumber)
                            .focused($focusedField, equals: .phone)
                    }
 
                    Button(action: submit) {
                        Group {
                            if isSubmitting {
                                ProgressView().tint(.white)
                            } else {
                                Text("Register").fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isFormValid || isSubmitting)
                    .padding(.top, 8)
                }
                .padding(24)
            }
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { focusedField = nil }
                }
            }
            .alert("Welcome, \(username)!", isPresented: $showSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your account has been created.")
            }
        }
    }
    
    private func inputField<Content: View>(
            title: String,
            icon: String,
            error: String?,
            @ViewBuilder content: () -> Content
        ) -> some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.subheadline.weight(.medium))
     
                HStack(spacing: 10) {
                    Image(systemName: icon)
                        .foregroundStyle(.secondary)
                        .frame(width: 20)
                    content()
                }
                .padding(14)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(error == nil ? Color.clear : Color.red, lineWidth: 1)
                )
     
                if let error {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
     
        private func submit() {
            focusedField = nil
            isSubmitting = true
     
            // Replace this with your real network call.
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                isSubmitting = false
                showSuccess = true
            }
        }
     
        private static func formatPhone(_ input: String) -> String {
            let digits = String(input.filter(\.isNumber).prefix(10))
            var result = ""
            for (index, char) in digits.enumerated() {
                switch index {
                case 0: result += "(\(char)"
                case 3: result += ") \(char)"
                case 6: result += "-\(char)"
                default: result.append(char)
                }
            }
            return result
        }
    }
     
#Preview {
    RegistrationView()
}
