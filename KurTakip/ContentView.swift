//
//  ContentView.swift
//  KurTakip
//
//  Created by Mertcan Ünek on 1.09.2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RatesViewModel()

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.rates.isEmpty {
                ProgressView("Kurlar yükleniyor...")
            } else if let errorMessage = viewModel.errorMessage,
                      viewModel.rates.isEmpty {
                ContentUnavailableView(
                    "Bağlantı sorunu",
                    systemImage: "wifi.slash",
                    description: Text(errorMessage)
                )
            } else {
                List {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    ForEach(viewModel.rates) { rate in
                        HStack {
                            Text(rate.code)
                            Spacer()
                            Text(rate.selling, format: .number.precision(.fractionLength(4)))
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    ContentView()
}
