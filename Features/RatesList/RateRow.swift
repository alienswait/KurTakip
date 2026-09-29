//
//  RateRow.swift
//  KurTakip
//
//  Created by Mertcan Ünek on 22.09.2026.
//

import SwiftUI

struct RateRow: View {

    let rate: Rate

    private enum Constants {
        static let vStackSpacing: CGFloat = 2
        static let verticalPadding: CGFloat = 4
        static let sellingFractionDigits = 4
        static let changeFractionDigits = 2
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Constants.vStackSpacing) {
                Text(rate.code)
                    .font(.system(size: 15, weight: .medium))
                Text(rate.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: Constants.vStackSpacing) {
                Text(rate.selling, format: .number.precision(.fractionLength(Constants.sellingFractionDigits)))
                    .font(.system(size: 16))

                if let change = rate.change {
                    Text(verbatim: "\(change >= 0 ? "▲" : "▼") \(abs(change).formatted(.percent.precision(.fractionLength(Constants.changeFractionDigits))))")
                        .font(.caption)
                        .foregroundStyle(change >= 0 ? .green : .red)
                }
            }
        }
        .padding(.vertical, Constants.verticalPadding)
    }
}

#Preview {
    List {
        RateRow(rate: Rate(code: "USD", name: "ABD Doları", selling: 48.6460, previousSelling: 48.4630))
        RateRow(rate: Rate(code: "EUR", name: "Euro", selling: 56.1216, previousSelling: 56.1892))
        RateRow(rate: Rate(code: "GBP", name: "Ingiliz Sterlini", selling: 65.6703, previousSelling: nil))
    }
}
