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
    @State private var rates: [Rate] = []
    private let service = RateService()
    var body: some View {
        List(rates) { rate in
            HStack {
                Text(rate.code)
                Spacer()
                Text(rate.selling, format: .number.precision(.fractionLength(4)))
            }
        }
        .task{
            do{
                rates = try await service.fetchRates()
            }catch{
                print("Hata \(error)")
            }
        }
    }
}
#Preview {
        ContentView()
    }
