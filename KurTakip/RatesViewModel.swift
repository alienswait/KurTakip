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
    
    func load() async {
        
        isLoading = true
        errorMessage = nil
        
        do{
            rates = try await service.fetchRates()
        } catch {
            errorMessage = "Veri alınırken hata meydana geldi. Bağlantını kontrol etmeyi deneyin."
        }
        
        isLoading = false
    }
}
