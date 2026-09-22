//
//  RatesViewModel.swift
//  KurTakip
//
//  Created by Mertcan Ünek on 2.09.2026.
//

import SwiftUI
import Combine

@MainActor
final class RatesViewModel: ObservableObject {

    @Published private(set) var rates: [Rate] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let service: RateServiceProtocol
    private let cache: RatesCacheProtocol

    init(service: RateServiceProtocol, cache: RatesCacheProtocol) {
        self.service = service
        self.cache = cache
    }

    func load() async {

        let cachedRates = cache.load()
        if let cachedRates {
            rates = cachedRates
        }

        isLoading = true
        errorMessage = nil

        do {
            let freshRates = try await service.fetchRates()

            let previousSellingByCode = Dictionary(
                uniqueKeysWithValues: (cachedRates ?? []).map { ($0.code, $0.selling) }
            )

            rates = freshRates.map { rate in
                var rate = rate
                rate.previousSelling = previousSellingByCode[rate.code]
                return rate
            }

            cache.save(rates)
        } catch {
            if rates.isEmpty {
                errorMessage = "Kurlar yüklenemedi. Bağlantını kontrol et."
            } else {
                errorMessage = "Güncellenemedi, son kayıtlı kurlar gösteriliyor."
            }
        }

        isLoading = false
    }
}
