//
//  PaymentSystem.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 01.09.2024.
//

import Foundation

enum PaymentSystem: Equatable {
    case visa
    case masterCard
    case prostir
    case other(name: String)
    
    static func parsePaymentSystem(from input: String?) -> PaymentSystem {
        guard let input = input?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) else {
            return .other(name: "Unknown")
        }
        
        switch input {
        case PaymentSystem.visa.toString().lowercased():
            return .visa
        case PaymentSystem.masterCard.toString().lowercased():
            return .masterCard
        case PaymentSystem.prostir.toString().lowercased():
            return .prostir
        default:
            return .other(name: input)
        }
    }
    
    private func toString() -> String {
        switch self {
        case .visa:
            return "Visa"
        case .masterCard:
            return "MasterCard"
        case .prostir:
            return "Prostir"
        case .other(let name):
            return name
        }
    }
 
    var logoName: String {
        switch self {
        case .visa:
            return Images.paymentSystemVisa.name
        case .masterCard:
            return Images.paymentSystemMastercard.name
        case .prostir:
            return Images.paymentSystemProstir.name
        case .other:
            return Images.paymentSystemDefault.name
        }
    }
    
}
