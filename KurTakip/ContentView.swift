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
    @StateObject private var viewModel = RatesViewModel()
    
    var body: some View {
        List(viewModel.rates) { rate in
            HStack {
                Text(rate.code)
                Spacer()
                Text(rate.selling, format: .number.precision(.fractionLength(4)))
            }
        }
        .task{
            await viewModel.load()
            }
        }
    }

#Preview {
        ContentView()
    }
