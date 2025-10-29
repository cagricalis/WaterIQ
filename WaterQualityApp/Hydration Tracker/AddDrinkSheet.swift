//
//  AddDrinkSheet.swift
//  WaterQualityApp
//
//  Created by Çağrı Mehmet Çalış on 28.10.2025.
//


//  AddDrinkSheet.swift
//  WaterQualityApp

import SwiftUI

struct AddDrinkSheet: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (Int, String) -> Void

    @State private var kind: String = "Water"
    @State private var amount: Double = 250

    var body: some View {
        NavigationStack {
            VStack(spacing: 22) {
                HStack(spacing: 18) {
                    drinkIcon("Water", "drop.fill")
                    drinkIcon("Coffee", "cup.and.saucer.fill")
                    drinkIcon("Juice",  "glass.fill")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("How much did you drink?")
                        .font(.headline)
                        .foregroundColor(.hNavy)

                    HStack {
                        Slider(value: $amount, in: 50...1000, step: 10)
                        Text("\(Int(amount)) ml")
                            .frame(width: 80, alignment: .trailing)
                            .foregroundColor(.hNavy)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Button {
                    onAdd(Int(amount), kind)
                    dismiss()
                } label: {
                    Text("ADD")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.hNavy)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.top, 6)

                Spacer()
            }
            .padding()
            .navigationTitle("Add Intake")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill").font(.title2)
                    }
                }
            }
        }
    }

    private func drinkIcon(_ name: String, _ system: String) -> some View {
        Button {
            kind = name
        } label: {
            VStack(spacing: 8) {
                Image(systemName: system).font(.title2)
                Text(name).font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(kind == name ? Color.hBlue.opacity(0.35) : Color.white.opacity(0.9))
            .foregroundColor(.hNavy)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
