//
//  CardsListViewModel.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 18.08.2024.
//

import Foundation
import RozetkaPaySDK
import OSLog

class CardsViewModel: ObservableObject {
    
    //MARK: - Properties
    @Published var items: [CardToken]
    @Published var alertItem: AlertItem?
    
    var clientWidgetParameters = ClientWidgetParameters(
        widgetKey: Credentials.WIDGET_KEY
    )
    
    //MARK: - Inits
    init() {
        self.items = []
    }
    
    required init(items: [CardToken]) {
        self.items = items
    }
    
    static var mocData: [CardToken] = {
        return [
            CardToken(
                paymentSystem: .visa,
                name: "Mono Black",
                maskedNumber: "**** **** **** 1234",
                cardToken: "token1"
            ),
            CardToken(
                paymentSystem: .masterCard,
                name: "Mono White",
                maskedNumber: "**** **** **** 5858",
                cardToken: "token1"
            ),
            CardToken(
                paymentSystem: PaymentSystem.other(name: "ПРОСТІР"),
                name: "Oschad Пенсійна",
                maskedNumber: "**** **** **** 9999",
                cardToken: "token1"
            ),
            CardToken(
                paymentSystem: .prostir,
                name: "GlobusBank Light",
                maskedNumber: "**** **** **** 1234",
                cardToken: "token1"
            ),
        ]
    }()
}
//MARK: - Private methods
private extension CardsViewModel {
    
    private func add(item: CardToken) {
        items.append(item)
    }
    
    private func addNewCard(tokenizedCard: TokenizedCard) {
        add(item: CardToken(
            paymentSystem: tokenizedCard.cardInfo?.paymentSystem,
            name: tokenizedCard.name,
            maskedNumber: tokenizedCard.cardInfo?.maskedNumber ,
            cardToken: tokenizedCard.token
        )
        )
    }
}

//MARK: - Methods
extension CardsViewModel {
    
    func handleResult(_ result: TokenizationResult) {
        switch result {
        case .success(let value):
            alertItem = AlertItem(
                type: .success,
                title: "Successful",
                message: "Tokenization card was successful."
            )
            addNewCard(tokenizedCard: value)
        case .failure(let error):
            switch error {
            case let .failed(message, _):
                if let message = message, !message.isEmpty {
                    alertItem = AlertItem(
                        type: .error,
                        title: "Failed",
                        message: "Tokenization of card failed with message: \(message)."
                    )
                    Logger.tokenizedCard.warning(
                        "⚠️ WARNING: An error with message \"\(message)\". Please try again. ⚠️"
                    )
                } else {
                    alertItem = AlertItem(
                        type: .error,
                        title: "Failed",
                        message: "An unknown error occurred with card tokenization. Please try again."
                    )
                    Logger.tokenizedCard.warning(
                        "⚠️ WARNING: An error occurred during tokenization process. Please try again. ⚠️"
                    )
                }
            case .cancelled:
                alertItem = AlertItem(
                    type: .info,
                    title: "Cancelled",
                    message: "Tokenization was cancelled manually by the user."
                )
                
                Logger.tokenizedCard.info("Tokenization was cancelled manually by user")
            }
        }
    }
}
