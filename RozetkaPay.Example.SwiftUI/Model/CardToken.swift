//
//  CardToken.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 18.08.2024.
//

import Foundation

struct CardToken: Identifiable {
    let id = UUID()
    let paymentSystem: PaymentSystem
    let name: String
    let maskedNumber: String
    
    private var cardToken: String?

    init(
        paymentSystem: String?,
        name: String?,
        maskedNumber: String?,
        cardToken: String? = nil
    ) {
        self.paymentSystem = PaymentSystem.parsePaymentSystem(from: paymentSystem)
        self.name = name ?? ""
        self.maskedNumber = maskedNumber ?? ""
        self.cardToken = cardToken
    }
    
    init(
        paymentSystem: PaymentSystem,
        name: String,
        maskedNumber: String,
        cardToken: String? = nil
    ) {
        self.paymentSystem = paymentSystem
        self.name = name
        self.maskedNumber = maskedNumber
        self.cardToken = cardToken
    }
    
    mutating func setup(cardToken: String? = nil) {
        self.cardToken = cardToken
    }
    
    
    
}
