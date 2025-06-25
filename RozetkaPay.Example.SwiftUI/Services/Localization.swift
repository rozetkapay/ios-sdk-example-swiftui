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
    case main_batch_pay_button_title
    
    //MARK: - Cart
    case cart_title
    case cart_navigation_bar_title
    case cart_checkout_button_title
    case cart_total_title
    case cart_shipment_title
    case cart_shipment_cost_free
    case cart_use_tokenized_card
    
    //MARK: - Batch cart
    case batch_cart_title
    case batch_cart_navigation_bar_title
    case batch_cart_checkout_button_title
    case batch_cart_total_title
    case batch_cart_group_order_title
    case batch_cart_group_order_total_title
    case batch_cart_shipment_title
    case batch_cart_shipment_cost_free
    case batch_cart_use_tokenized_card

    //MARK: - Cards
    case cards_title
    case cards_navigation_bar_title
    case cards_add_new_card_button_title
    
    //MARK: - Alert
    case ok_button_title
    
}
