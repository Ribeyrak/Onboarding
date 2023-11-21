//
//  Number.swift
//  Onboarding
//
//  Created by Evhen Lukhtan on 21.11.2023.
//

import Foundation

extension NumberFormatter {
    
    static let currencyFormatter = createFormatter(locale: .init(identifier: "en_US"),
                                                   style: .currency)
    static func createFormatter(locale: Locale? = nil, style: Style) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = locale ?? Locale.current
        formatter.numberStyle = style
        return formatter
    }
}

