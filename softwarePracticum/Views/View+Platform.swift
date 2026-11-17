//
//  View+Platform.swift
//  softwarePracticum
//

import SwiftUI

/// Wrappers for modifiers that aren't available on every platform this target supports.
extension View {
    /// Shows the phone keyboard where supported.
    func phoneNumberInput() -> some View {
        #if os(macOS)
        self.textContentType(.telephoneNumber)
        #else
        self
            .keyboardType(.phonePad)
            .textContentType(.telephoneNumber)
        #endif
    }

    /// Uses an inline navigation title where supported.
    func inlineNavigationTitle() -> some View {
        #if os(macOS)
        self
        #else
        self.navigationBarTitleDisplayMode(.inline)
        #endif
    }
}
