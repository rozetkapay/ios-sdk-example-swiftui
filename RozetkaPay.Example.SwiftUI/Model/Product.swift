//
//  Product.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//

import Foundation
import RozetkaPaySDK

struct Product: Identifiable {
    let id = UUID()
    let category: String
    let currency: String
    let description: String
    let image: String
    let name: String
    let priceInCoins: Int64
    let vatRate: Double
    let netAmountInCoins: Int64
    let vatAmountInCoins: Int64
    let quantity: Int64
    let url: String

    var price: Double {
        priceInCoins.currencyFormatAmount()
    }
    
    var amount: Double {
        (priceInCoins * quantity).currencyFormatAmount()
    }
        
    init(
        category: String,
        currency: String,
        description: String,
        image: String,
        name: String,
        price: Double,
        vatRate: Double = 0.2,
        netAmountInCoins: Int64? = nil,
        vatAmountInCoins: Int64? = nil,
        quantity: Int64,
        url: String
    ) {
        self.category = category
        self.currency = currency
        self.description = description
        self.image = image
        self.name = name

        self.quantity = quantity
        self.url = url

        let _priceInCoins = price.convertToCoinsAmount()
        let total = _priceInCoins * quantity

        self.priceInCoins = _priceInCoins
        if let net = netAmountInCoins, let vat = vatAmountInCoins {
            self.netAmountInCoins = net
            self.vatAmountInCoins = vat
        } else {
            let vat = Int64(Double(total) * vatRate / (1 + vatRate))
            let net = total - vat

            self.netAmountInCoins = net
            self.vatAmountInCoins = vat
        }
        self.vatRate = vatRate
    }
}

extension Array where Element == Product {
    
    func mapToBatchProduct() -> [BatchProduct] {
        return self.map { product in
            return BatchProduct(
                category: product.category,
                currency: product.currency,
                description: product.description,
                id: product.id.uuidString,
                image: product.image,
                name: product.name,
                netAmountInCoins: product.netAmountInCoins,
                vatAmountInCoins: product.vatAmountInCoins,
                quantity: product.quantity.toString(),
                url: product.url
            )
        }
    }
}
