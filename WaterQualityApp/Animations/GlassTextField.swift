//
//  GlassTextField.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 27.10.2025.
//


import SwiftUI

struct GlassTextField: View {
    let placeholder: String
    @Binding var text: String
    let systemImage: String

    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.cyan.opacity(0.8))
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
                .textInputAutocapitalization(.never)
                .foregroundColor(.primary)
        }
        .padding(12)
        .background(.thinMaterial)
        .cornerRadius(12)
    }
}

struct GlassSecureField: View {
    let placeholder: String
    @Binding var text: String
    let systemImage: String

    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.cyan.opacity(0.8))
            SecureField(placeholder, text: $text)
                .foregroundColor(.primary)
        }
        .padding(12)
        .background(.thinMaterial)
        .cornerRadius(12)
    }
}
