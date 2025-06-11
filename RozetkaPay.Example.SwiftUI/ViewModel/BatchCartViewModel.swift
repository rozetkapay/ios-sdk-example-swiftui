//
//  BatchCartViewModel.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 29.05.2025.
//
import Foundation
import RozetkaPaySDK
import OSLog

final class BatchCartViewModel: ObservableObject {
    
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
    
    private static var batchApiKey: String {
        AppConfiguration.shared.credentials.BATCH_API_KEY
    }
    
    //MARK: - Properties
    @Published var alertItem: AlertItem?
    
    @Published var externalId: String
    @Published var orders: [Order]
    
    var totalNetAmountInCoins: Int64 {
        orders.reduce(0) { $0 + $1.totalNetAmountInCoins }
    }

    var totalVatAmountInCoins: Int64 {
        orders.reduce(0) { $0 + $1.totalVatAmountInCoins }
    }

    var totalAmountInCoins: Int64 {
        orders.reduce(0) { $0 + $1.totalAmountInCoins }
    }
    
    var totalAmount: Double {
        orders.reduce(0) { $0 + $1.totalAmount }
    }
    
    var shipment: String {
        Localization.cart_shipment_cost_free.description
    }
    
    //MARK: - Inits
    init(
        externalId: String,
        orders: [Order]
    ) {
        self.externalId = externalId
        self.orders = orders
    }
    
    //MARK: - MocData
    static func generateMocData() -> [Order] {
        return [
            Order(
                apiKey: batchApiKey,
                description: "order description",
                externalId: generateOrderId(),
                unifiedExternalId: "test_unifiedExternalId",
                products: [
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemFirst.name,
                        name: "Air Pods RZTK",
                        price: 700.00,
                        quantity: 1,
                        url: "url"
                    ),
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemSecond.name,
                        name: "RZTK Power Bank",
                        price: 300.00,
                        quantity: 1,
                        url: "url"
                    ),
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemThird.name,
                        name: "RZTK Macbook Pro 16",
                        price: 6000.00,
                        quantity: 1,
                        url: "url"
                    ),
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemFourth.name,
                        name: "RZTK magic mouse",
                        price: 1000.00,
                        quantity: 1,
                        url: "url"
                    )
                ]
            ),
            Order(
                apiKey: batchApiKey,
                description: "order description",
                externalId: generateOrderId(),
                products: [
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemFifth.name,
                        name: "Комп'ютер Apple Mac Mini M4",
                        price: 1000.00,
                        quantity: 1,
                        url: "url"
                    ),
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemSixth.name,
                        name: "RZTK Apple iPad 10.9",
                        price: 800.00,
                        quantity: 1,
                        url: "url"
                    ),
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemSeventh.name,
                        name: "RZTK Apple Watch Ultra 2",
                        price: 900.00,
                        quantity: 1,
                        url: "url"
                    ),
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemEighth.name,
                        name: "Моноблок Apple iMac М4 4.5К",
                        price: 1200.00,
                        quantity: 1,
                        url: "url"
                    )
                ]
            )
            
        ]
    }
}

//MARK: - Private methods
private extension BatchCartViewModel {
    
    private func add(item: Order) {
        orders.append(item)
    }
}

//MARK: - Methods
extension BatchCartViewModel {
    
    static func generateExternalId() -> String {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let uuidSuffix = UUID().uuidString.prefix(8)
        let orderId = "external-apple-\(timestamp)-\(uuidSuffix)"
        return orderId
    }
    
    static func generateOrderId() -> String {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let uuidSuffix = UUID().uuidString.prefix(8)
        let orderId = "order-apple-\(timestamp)-\(uuidSuffix)"
        return orderId
    }
    
    func handleResult(_ result: BatchPaymentResult) {
        switch result {
        case let .pending(batchExternalId, ordersPayments, message, error):
            alertItem = AlertItem(
                type: .info,
                title: "Pending",
                message: "BatchPayment is pending. External ID: \(batchExternalId)"
            )
            Logger.payment.info(
                "BatchPayment is pending. External ID: \(batchExternalId). Message: \(message ?? "No message"). Error: \(error?.localizedDescription ?? "No error description")"
            )
        case let .complete(batchExternalId, ordersPayments, tokenizedCard):
            var text = "BatchPayment was successful. External ID: \(batchExternalId)"
            if let tokenizedCard = tokenizedCard {
                text += "TokenizedCard: \(tokenizedCard.cardInfo?.maskedNumber ?? tokenizedCard.name ?? tokenizedCard.token)"
            }
            alertItem = AlertItem(
                type: .success,
                title: "Successful",
                message: text
            )
            Logger.payment.info("\(text)")
        case let .failed(batchExternalId, error, ordersPayments):
            if error.code == .transactionAlreadyPaid {
                alertItem = AlertItem(
                    type: .warning,
                    title: "Failed",
                    message: "External ID: \(batchExternalId ?? self.externalId) already paid. "
                )
                Logger.payment.info(
                    "⚠️ WARNING: BatchPayment already paid. External ID: \(batchExternalId ?? self.externalId)."
                )
                return
            }
            
            if let message = error.message, !message.isEmpty {
                alertItem = AlertItem(
                    type: .error,
                    title: "Failed",
                    message: "BatchPayment with external ID: \(batchExternalId ?? self.externalId) has failed with message: \(message)."
                )
                var errorText =  "⚠️ WARNING: An error with message \"\(message)\", paymentId: \"\(error.paymentId ?? "")\"."
                
                
                errorText += " errorDescription: \(error.localizedDescription)."
                errorText += "Please try again. ⚠️"
                Logger.payment.warning("\(errorText)")
            } else {
                alertItem = AlertItem(
                    type: .error,
                    title: "Failed",
                    message: "An unknown error occurred with external ID: \(batchExternalId ?? self.externalId). Please try again."
                )
                Logger.payment.warning(
                    "⚠️ WARNING: An error occurred during batchpayment process. external ID: \(batchExternalId ?? self.externalId). Please try again. ⚠️"
                )
            }
        case .cancelled:
            alertItem = AlertItem(
                type: .info,
                title: "Cancelled",
                message: "BatchPayment was cancelled manually by the user."
            )
            Logger.payment.info("BatchPayment was cancelled manually by user")
        }
    }
}
