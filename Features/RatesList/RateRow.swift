//
//  RateRow.swift
//  KurTakip
//
//  Created by Mertcan Ünek on 22.09.2026.
//


import SwiftUI

struct RateRow: View {
    
    let rate: Rate
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                
                Text(rate.code)
                    .font(.system(size: 15, weight: .medium))
                Text(rate.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                
                Text(rate.selling, format: .number.precision(.fractionLength(4)))
                    .font(.system(size: 16))
                
                if let change = rate.change {
                                    Text("\(change >= 0 ? "▲" : "▼") \(abs(change), format: .percent.precision(.fractionLength(2)))")
                                        .font(.caption)
                                        .foregroundStyle(change>=0 ? .green : .red)
                                }
                    
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        RateRow(rate: Rate(code: "USD", name: "ABD Doları", selling: 48.6460, previousSelling: 48.4630))
        RateRow(rate: Rate(code: "EUR", name: "Euro", selling: 56.1216, previousSelling: 56.1892))
        RateRow(rate: Rate(code: "GBP", name: "Ingiliz Sterlini", selling: 65.6703, previousSelling: nil))
    }
}
