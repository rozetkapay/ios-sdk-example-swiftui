//
//  NumberUtils.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 04.09.2024.
//

import Foundation

extension Double {
    
    func currencyFormat() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = Config.decimalSeparator
        return formatter.string(for: self) ?? self.description
    }
    
    func convertToCoinsAmount() -> Int64 {
        let amount = Double(self * 100).nextUp
        return Int64(amount)
    }
}

extension Int64 {
    
    func currencyFormatAmount() -> Double {
        return Double(self)/100.0
    }
    
    func currencyFormat() -> String {
        return (Double(self)/100.0).currencyFormat()
    }
    
    func toString() -> String {
        return self.description
    }
}
