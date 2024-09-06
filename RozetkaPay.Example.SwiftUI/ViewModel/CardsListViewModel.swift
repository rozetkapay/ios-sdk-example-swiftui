//
//  CardsListViewModel.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 18.08.2024.
//

import Foundation
import RozetkaPaySDK

class CardsViewModel: ObservableObject {
    
    @Published var items: [CardToken]
    
    var clientWidgetParameters = ClientWidgetParameters(
        widgetKey: Credentials.WIDGET_KEY
    )
    
    func add(item: CardToken) {
        items.append(item)
    }
    
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
