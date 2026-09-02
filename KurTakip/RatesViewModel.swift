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
    
    private let service = RateService()
    
    func load() async {
        do{
            rates = try await service.fetchRates()
        } catch {
            print("Hata: \(error)")
        }
    }
}
