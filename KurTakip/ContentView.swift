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
            }  else if let message = viewModel.errorMessage,
                        viewModel.rates.isEmpty {
                  ContentUnavailableView {
                      Label("Bağlantı sorunu", systemImage: "wifi.slash")
                  } description: {
                      Text(message)
                  } actions: {
                      Button("Tekrar dene") {
                          Task {
                              await viewModel.load()
                          }
                      }
                  }
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
        .refreshable {
            await viewModel.load()
        }
    }
}

#Preview {
    ContentView()
}
