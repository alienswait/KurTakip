//
//  KurTakipTests.swift
//  KurTakipTests
//
//  Created by Mertcan Ünek on 15.09.2026.
//

import Testing
import Foundation
@testable import KurTakip


struct StubRateService: RateServiceProtocol {
    
    let result: Result<[Rate], Error>
    
    func fetchRates() async throws -> [Rate] {
        try result.get()
    }
}


final class StubRateCache:RatesCacheProtocol {
    
    private var stored: [Rate]?
    
    init(stored:[Rate]? = nil){
        self.stored = stored
    }
    
    func save (_ rates: [Rate]){
        stored = rates
    }
    
    func load() -> [Rate]? {
        stored
    }
}

@MainActor
struct RatesViewModelTests {
    
    @Test func ServisBasariliysaKurlarYuklenir() async{
        
        let sahteKurlar = [
            Rate(code: "USD", name:"ABD Doları", selling: 48.27),
            Rate(code: "EUR", name:"Euro", selling: 55.97)
        ]
        
        let servis = StubRateService(result: .success(sahteKurlar))
        let viewModel = RatesViewModel(service: servis, cache: StubRateCache())
        
        await viewModel.load()
        
        
        #expect(viewModel.rates.count == 2)
        #expect(viewModel.rates.first?.code == "USD")
        #expect(viewModel.errorMessage == nil)
        
        
    }
    
    @Test func servisHatalarvarsaHataMesajiGosterilir() async{
        
       
        let servis = StubRateService(result: .failure(URLError(.notConnectedToInternet)))
        let viewModel = RatesViewModel(service: servis, cache: StubRateCache())
        
        await viewModel.load()
        
        #expect(viewModel.rates.isEmpty)
        #expect(viewModel.errorMessage != nil)
        
        
    }
    
    
}

