//
//  CardView.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 29.09.2024.
//

import SwiftUI

struct CardView: View {
    var cardTypeImage: String
    var cardName: String
    var maskedNumber: String
    
    var body: some View {
        HStack {
            Image(cardTypeImage)
                .resizable()
                .frame(width: 30, height: 20)
                .padding(.top, 8)
            
            VStack(alignment: .leading) {
                Text(cardName)
                    .font(.headline)
                
                Text(maskedNumber)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
        )
    }
}
