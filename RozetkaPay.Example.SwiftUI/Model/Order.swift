//
//  Order.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 30.05.2025.
//

import Foundation
import RozetkaPaySDK

struct Order: Identifiable {
    let id = UUID()
    let apiKey: String
    let description: String
    let externalId: String
    let unifiedExternalId: String?
    let products: [Product]
    
    var totalNetAmountInCoins: Int64 {
        products.reduce(0) { $0 + $1.netAmountInCoins }
    }
    
    var totalVatAmountInCoins: Int64 {
       products.reduce(0) { $0 + $1.vatAmountInCoins }
    }
    
    var totalAmountInCoins: Int64 {
        totalNetAmountInCoins + totalVatAmountInCoins
    }
    
    var totalAmount: Double {
        totalAmountInCoins.currencyFormatAmount()
    }
    
    init(
        apiKey: String,
        description: String,
        externalId: String,
        unifiedExternalId: String? = nil,
        products: [Product]
    ) {
        self.apiKey = apiKey
        self.description = description
        self.externalId = externalId
        self.unifiedExternalId = unifiedExternalId
        self.products = products
    }
}

extension Array where Element == Order {
    
    func mapToBatchOrder(key: String? = nil) -> [BatchOrder] {
        return self.compactMap { order in
            
            return BatchOrder(
                apiKey: key ?? order.apiKey,
                amountInCoins: order.totalAmountInCoins,
                description: order.description,
                externalId: order.externalId,
                unifiedExternalId: order.unifiedExternalId,
                products: order.products.mapToBatchProduct()
            )
        }
    }
}
