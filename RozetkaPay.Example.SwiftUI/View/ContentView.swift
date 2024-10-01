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
                    destination: CardsListView(items: CardsViewModel.mocData)
                ) {
                    Text("Cards")
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
                        orderId: "order_test_3232-445",
                        items: CartViewModel.mocData
                    )
                ) {
                    Text("Pay")
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
            .navigationTitle("RozetkaPay.Example")
        }
    }
}

#Preview {
    ContentView()
}
