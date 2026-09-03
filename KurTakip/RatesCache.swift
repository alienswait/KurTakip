//
//  RatesCache.swift
//  KurTakip
//
//  Created by Mertcan Ünek on 3.09.2026.
//

import Foundation

struct RatesCache {
    
    private var fileURL: URL {
        let folder = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        
        return folder.appendingPathComponent("rates.json")
     
    }
    
    func save(_ rates: [Rate]){
        
        guard let data = try? JSONEncoder().encode(rates) else {return}
        try? data.write(to: fileURL)
    }
    
    func load() -> [Rate]? {
            guard let data = try? Data(contentsOf: fileURL) else { return nil }
            return try? JSONDecoder().decode([Rate].self, from: data)
        }
    
    
}
