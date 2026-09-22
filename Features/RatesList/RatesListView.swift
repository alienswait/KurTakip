//
//  ContentView.swift
//  KurTakip
//
//  Created by Mertcan Ünek on 1.09.2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RatesViewModel(
        service: RateService(),
        cache: RatesCache()
    )
    @State private var searchText = ""

    private var filteredRates: [Rate] {
        guard !searchText.isEmpty else { return viewModel.rates }
        return viewModel.rates.filter {
            $0.code.localizedCaseInsensitiveContains(searchText) ||
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.rates.isEmpty {
                    ProgressView("Kurlar yükleniyor...")
                } else if let message = viewModel.errorMessage,
                          viewModel.rates.isEmpty {
                    ContentUnavailableView {
                        Label("Bağlantı sorunu", systemImage: "wifi.slash")
                    } description: {
                        Text(message)
                    } actions: {
                        Button("Tekrar dene") {
                            Task { await viewModel.load() }
                        }
                    }
                } else {
                    List {
                        Section {
                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }

                            ForEach(filteredRates) { rate in
                                RateRow(rate: rate)
                            }
                        } header: {
                            if let lastUpdated = viewModel.lastUpdated {
                                Text("TCMB · \(lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                                    .textCase(nil)
                            }
                        }
                    }
                    .searchable(text: $searchText, prompt: "Ara")
                }
            }
            .navigationTitle("Kurlar")
            .task { await viewModel.load() }
            .refreshable { await viewModel.load() }
        }
    }
}

#Preview {
    ContentView()
}
