//
//  ContentView.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 18.08.2024.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                NavigationLink(
                    destination: CardsListView(
                        items: CardsViewModel.mocData
                    )
                ) {
                    Text(Localization.main_cards_button_title.description)
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            colorScheme == .dark ? Color.white : Color.black
                        )
                        .foregroundColor(
                            colorScheme == .dark ? Color.black : Color.white
                        )
                        .cornerRadius(10)
                }
                
                NavigationLink(
                    destination: CartView(
                        orderId: generateOrderId(),
                        items: CartViewModel.mocData
                    )
                ) {
                    Text(Localization.main_pay_button_title.description)
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle(Localization.main_title.description)
        }
    }
    
    private func generateOrderId() -> String {
        return "order-apple-\(Int(Date().timeIntervalSince1970 * 1000))"
    }
}

//MARK: Preview
#Preview {
    ContentView()
}
