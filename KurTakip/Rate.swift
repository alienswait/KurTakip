//
//  Rate.swift
//  KurTakip
//
//  Created by Mertcan Ünek on 3.09.2026.
//

import Foundation

struct Rate: Identifiable, Codable {
    let code: String
    let selling: Double

    var id: String { code }
}
