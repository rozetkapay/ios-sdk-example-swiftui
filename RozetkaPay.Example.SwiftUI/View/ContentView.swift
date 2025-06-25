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

                ///Cards
                NavigationLink(
                    destination: CardsListView()
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
                ///Pay
                NavigationLink(
                    destination: CartView()
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
                ///Batch Pay
                NavigationLink(
                    destination: BatchCartView()
                ) {
                    Text(Localization.main_batch_pay_button_title.description)
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle(Localization.main_title.description)
        }
    }
    
}

//MARK: Preview
#Preview {
    ContentView()
}
