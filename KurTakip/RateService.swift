//
//  Untitled.swift
//  KurTakip
//
//  Created by Mertcan Ünek on 1.09.2026.
//

import Foundation

struct RateService {
    func fetchRates() async throws -> [Rate] {
        
        let url = URL(string: "https://www.tcmb.gov.tr/kurlar/today.xml")!
        let (data, _) = try await URLSession.shared.data(from: url)
        print("Gelen veri boyutu: \(data.count) byte")
        return []
        
    }
}
