//
//  Rate.swift
//  KurTakip
//
//  Created by Mertcan Ünek on 3.09.2026.
//

import Foundation

struct Rate: Identifiable, Codable {
    let code: String
    let name: String
    let selling: Double
    var previousSelling: Double?

    var id: String { code }
    
    var change: Double? {
        guard let previousSelling, previousSelling != 0 else { return nil }
        return (selling - previousSelling) / previousSelling
        
    }
}
