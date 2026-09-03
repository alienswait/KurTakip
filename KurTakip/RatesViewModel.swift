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
    
    private let service = RateService()
    private let cache = RatesCache()
    
    func load() async {
        
        if let cachedRates = cache.load() {
            rates = cachedRates
            
        }
        
        isLoading = true
        errorMessage = nil
        
        do{
            rates = try await service.fetchRates()
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
