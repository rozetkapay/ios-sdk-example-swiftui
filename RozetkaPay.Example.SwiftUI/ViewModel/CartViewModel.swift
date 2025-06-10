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
    
    //MARK: - Credentials
    private let credentials = AppConfiguration.shared.credentials
    var clientParameters: ClientAuthParameters {
        ClientAuthParameters(
            token: credentials.AUTH_TOKEN,
            widgetKey: credentials.WIDGET_KEY
        )
    }
    
    var testApplePayConfig: ApplePayConfig {
        ApplePayConfig.Test(
            merchantIdentifier: credentials.APPLE_PAY_MERCHANT_ID,
            merchantName: credentials.APPLE_PAY_MERCHANT_NAME
        )
    }
    
    var testCardToken: String {
        credentials.TEST_CARD_TOKEN_1
    }
    
    var errorCardToken: String {
        credentials.ERROR_CARD_TOKEN_1
    }

    //MARK: - Properties
    @Published var items: [Product]
    @Published var orderId: String
    @Published var alertItem: AlertItem?
    
    var totalNetAmountInCoins: Int64 {
        items.reduce(0) { $0 + $1.netAmountInCoins }
    }

    var totalVatAmountInCoins: Int64 {
        items.reduce(0) { $0 + $1.vatAmountInCoins }
    }

    var totalAmountInCoins: Int64 {
        totalNetAmountInCoins + totalVatAmountInCoins
    }
    
    var totalAmount: Double {
        totalAmountInCoins.currencyFormatAmount()
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
                category: "category1",
                currency: Config.defaultCurrencyCode,
                description: "description test",
                image: Images.cartItemFirst.name,
                name: "Air Pods RZTK",
                price: 700.00,
                quantity: 3,
                url: "url"
            ),
            Product(
                category: "category1",
                currency: Config.defaultCurrencyCode,
                description: "description test",
                image: Images.cartItemSecond.name,
                name: "RZTK Power Bank",
                price: 300,
                quantity: 1,
                url: "url"
            ),
            Product(
                category: "category1",
                currency: Config.defaultCurrencyCode,
                description: "description test",
                image: Images.cartItemThird.name,
                name: "RZTK Macbook Pro 16",
                price: 6000,
                quantity: 2,
                url: "url"
            ),
            Product(
                category: "category1",
                currency: Config.defaultCurrencyCode,
                description: "description test",
                image: Images.cartItemFourth.name,
                name: "RZTK magic mouse",
                price: 1200.00,
                quantity: 2,
                url: "url"
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
    
    static func generateOrderId() -> String {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let uuidSuffix = UUID().uuidString.prefix(8)
        let orderId = "order-apple-\(timestamp)-\(uuidSuffix)"
        return orderId
    }
        
    func handleResult(_ result: PaymentResult) {
        switch result {
        case let .pending(orderId, paymentId, message, error):
            alertItem = AlertItem(
                type: .info,
                title: "Pending",
                message: "Payment \(paymentId ?? "Without paymentId") is pending. Order ID: \(orderId)"
            )
            Logger.payment.info(
                "Payment \(paymentId ?? "Without paymentId" ) is pending. Order ID: \(orderId). Message: \(message ?? "No message"). Error: \(error?.localizedDescription ?? "No error description")"
            )
        case let .complete(orderId, paymentId, tokenizedCard):
            var text = "Payment \(paymentId) was successful. Order ID: \(orderId)"
            if let tokenizedCard = tokenizedCard {
                text += "TokenizedCard: \(tokenizedCard.cardInfo?.maskedNumber ?? tokenizedCard.name ?? tokenizedCard.token)"
            }
            alertItem = AlertItem(
                type: .success,
                title: "Successful",
                message: text
            )
            Logger.payment.info("\(text)")
        case let .failed(error):
            if error.code == .transactionAlreadyPaid {
                alertItem = AlertItem(
                    type: .warning,
                    title: "Failed",
                    message: "Order ID: \(orderId) already paid. "
                )
                Logger.payment.info(
                    "⚠️ WARNING: Payment \(error.paymentId ?? "Without paymentId" ) already paid. Order ID: \(self.orderId)."
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
