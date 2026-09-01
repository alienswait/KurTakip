//
//  ContentView.swift
//  KurTakip
//
//  Created by Mertcan Ünek on 1.09.2026.
//

import SwiftUI
struct Rate: Identifiable {
    let id = UUID()
    let code: String
    let selling: Double
}

struct ContentView: View {
    let rates = [
        Rate(code: "USD", selling: 41.18),
        Rate(code: "EUR", selling: 47.92),
        Rate(code: "GBP", selling: 55.41),
    ]
    var body: some View {
        List(rates) { rate in
            HStack {
                Text(rate.code)
                Spacer()
                Text(rate.selling, format: .number.precision(.fractionLength(4)))
            }
        }
    }
}
#Preview {
        ContentView()
    }
