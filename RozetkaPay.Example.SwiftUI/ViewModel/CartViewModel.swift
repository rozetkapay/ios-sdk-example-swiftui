//
//  CartViewModel.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//

import Foundation
import RozetkaPaySDK
import OSLog

final class CartViewModel: ObservableObject {
    
 
    var clientParameters = ClientAuthParameters(
        token: Credentials.DEV_AUTH_TOKEN,
        widgetKey: Credentials.WIDGET_KEY
    )
    
    var testApplePayConfig: ApplePayConfig = ApplePayConfig.Test(
        merchantIdentifier: Credentials.APPLE_PAY_MERCHANT_ID,
        merchantName: Credentials.APPLE_PAY_MERCHANT_NAME
    )
    
    @Published var items: [Product]
    @Published var orderId: String
    @Published var alertItem: AlertItem?
    
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
        Localization.cart_shipment_cost_free.description
    }
    
    //MARK: - Inits
    init(
        orderId: String,
        items: [Product]
    ) {
        self.orderId = orderId
        self.items = items
    }
    
    //MARK: - MocData
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

//MARK: - Private methods
private extension CartViewModel {
    
    private func add(item: Product) {
        items.append(item)
    }
}

//MARK: - Methods
extension CartViewModel {
    func handleResult(_ result: PaymentResult) {
        switch result {
        case let .pending(orderId, paymentId, message, error):
            alertItem = AlertItem(
                type: .info,
                title: "Pending",
                message: "Payment \(paymentId ?? "Whithout paymentId") is pending. Order ID: \(orderId)"
            )
            Logger.payment.info(
                "Payment \(paymentId ?? "Whithout paymentId" ) is pending. Order ID: \(orderId). Message: \(message ?? "No message"). Error: \(error?.localizedDescription ?? "No error description")"
            )
        case let .complete(orderId, paymentId):
            alertItem = AlertItem(
                type: .success,
                title: "Successful",
                message: "Payment \(paymentId) was successful. Order ID: \(orderId)"
            )
            Logger.payment.info(
                "Payment \(paymentId) was successful. Order ID: \(orderId)"
            )
        case let .failed(error):
            if error.code == .transactionAlreadyPaid {
                alertItem = AlertItem(
                    type: .warning,
                    title: "Failed",
                    message: "Order ID: \(orderId) already paid. "
                )
                Logger.payment.info(
                    "⚠️ WARNING: Payment \(error.paymentId ?? "Whithout paymentId" ) already paid. Order ID: \(self.orderId)."
                )
                return
            }
            
            if let message = error.message, !message.isEmpty {
                alertItem = AlertItem(
                    type: .error,
                    title: "Failed",
                    message: "Payment \(error.paymentId ?? "") failed with message: \(message)."
                )
                var errorText =  "⚠️ WARNING: An error with message \"\(message)\", paymentId: \"\(error.paymentId ?? "")\"."
                
                
                errorText += " errorDescription: \(error.localizedDescription)."
                errorText += "Please try again. ⚠️"
                Logger.payment.warning("\(errorText)")
            } else {
                alertItem = AlertItem(
                    type: .error,
                    title: "Failed",
                    message: "An unknown error occurred with payment \(error.paymentId ?? ""). Please try again."
                )
                Logger.payment.warning(
                    "⚠️ WARNING: An error occurred during payment process. paymentId: \(error.paymentId ?? ""). Please try again. ⚠️"
                )
            }
        case .cancelled:
            alertItem = AlertItem(
                type: .info,
                title: "Cancelled",
                message: "Payment was cancelled manually by the user."
            )
            Logger.payment.info("Payment was cancelled manually by user")
        }
    }
}
