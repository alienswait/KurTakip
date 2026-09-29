//
//  Optional+Extensions.swift
//  KurTakip
//
//  Created by Mertcan Ünek on 29.09.2026.
//


extension Optional where Wrapped: RangeReplaceableCollection {
    var orEmpty: Wrapped {
        self ?? Wrapped()
    }
}
