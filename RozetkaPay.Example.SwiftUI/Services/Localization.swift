//
//  Localization.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 21.04.2025.
//


enum Localization: String {
    
    var description: String {
        let localized = String.LocalizationValue(rawValue)
        return String(localized: localized)
    }
    
    case main_title
    case main_cards_button_title
    case main_pay_button_title
    
    case cart_title
    case cart_navigation_bar_title
    case cart_checkout_button_title
    case cart_total_title
    case cart_shipment_title
    case cart_shipment_cost_free

    //MARK: - Cards
    case cards_title
    case cards_navigation_bar_title
    case cards_add_new_card_button_title
    
    //MARK: - Alert
    case ok_button_title
    
}

