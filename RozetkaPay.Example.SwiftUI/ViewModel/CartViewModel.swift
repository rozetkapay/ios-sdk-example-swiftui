//
//  CartViewModel.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//

import Foundation
import RozetkaPaySDK

final class CartViewModel: ObservableObject {
    var clientParameters: ClientAuthParameters = ClientAuthParameters(
        token: Credentials.DEV_AUTH_TOKEN
    )
    
    var testApplePayConfig: ApplePayConfig = ApplePayConfig.Test(
        merchantIdentifier: Credentials.APPLE_PAY_MERCHANT_ID,
        merchantName: Credentials.APPLE_PAY_MERCHANT_NAME
    )
    
    @Published var items: [Product]
    
    @Published var orderId: String
    
    var totalAmount: Double {
        items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
    
    var totalTax: Double {
        (totalAmount * 0.2).nextUp
    }
    
    var totalPrice: Double {
        totalAmount + totalTax
    }
    
    var shipment: String {
        "Free"
    }
    
    //MARK: - Init
    init(
        orderId: String,
        items: [Product]
    ) {
        self.orderId = orderId
        self.items = items
    }
    
    func add(item: Product) {
        items.append(item)
    }
    
    static var mocData: [Product] = {
        return [
            Product(
                name: "Air Pods RZTK",
                price: 629.00,
                quantity: 1,
                imageName: "cart.item.1"
            ),
            Product(
                name: "RZTK Power Bank",
                price: 229.00,
                quantity: 2,
                imageName: "cart.item.2"
            ),
            Product(
                name: "RZTK Macbook Pro 16",
                price: 599.00,
                quantity: 1,
                imageName: "cart.item.3"
            ),
            Product(
                name: "RZTK magic mouse",
                price: 1199.00,
                quantity: 1,
                imageName: "cart.item.4"
            )
        ]
    }()
}
