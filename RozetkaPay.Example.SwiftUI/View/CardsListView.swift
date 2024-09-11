//
//  CardsListView.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//

import OSLog
import SwiftUI
import RozetkaPaySDK

struct CardsListView: View {
    
    @StateObject var viewModel: CardsViewModel
    @State private var isSheetPresented = false
    @Environment(\.presentationMode) var presentationMode
    
    public init(items: [CardToken]) {
        _viewModel = StateObject(
            wrappedValue: CardsViewModel(
                items: items
            )
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your cards:")
                .font(.headline)
                .padding([.leading, .top])
            
            List(viewModel.items) { item in
                HStack {
                    CardView(
                        cardTypeImage: item.paymentSystem.logoName,
                        cardName: item.name,
                        maskedNumber: item.maskedNumber
                    )
                    
                }
                .listRowInsets(
                    EdgeInsets(
                        top: 5,
                        leading: 20,
                        bottom: 5,
                        trailing: 20)
                )
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            
            Spacer()
            
            Button(action: {
                isSheetPresented.toggle()
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add new card")
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(12)
            }
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationBarTitle("Tokenize card", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
        .navigationTitle("Your Cart")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isSheetPresented) {
            
            RozetkaPaySDK.TokenizationView(
                parameters: TokenizationParameters(
                    client: viewModel.clientWidgetParameters,
                    viewParameters: TokenizationViewParameters(
                        cardNameField: .optional,
                        emailField: .required,
                        cardholderNameField: .optional
                    )
                ),
                callback: { result in
                    tokenizationFinished(result: result)
                    isSheetPresented.toggle()
                }
            )
        }
    }
    
    private func tokenizationFinished(result: TokenizationResult) {
        switch result {
        case .success(let value):
            addNewCard(tokenizedCard: value)
        case .failure(let error):
            switch error {
            case let .failed(message, _):
                
                if let message = message, !message.isEmpty {
                    Logger.tokenizedCard.warning(
                        "⚠️ WARNING: An error with message \"\(message)\". Please try again. ⚠️"
                    )
                } else {
                    Logger.tokenizedCard.warning(
                        "⚠️ WARNING: An error occurred during tokenization process. Please try again. ⚠️"
                    )
                }
            case .cancelled:
                Logger.tokenizedCard.info("Tokenization was cancelled")
            }
        }
    }
    
    private func addNewCard(tokenizedCard: TokenizedCard) {
        viewModel.add(
            item: CardToken(
                paymentSystem: tokenizedCard.cardInfo?.paymentSystem,
                name: tokenizedCard.name,
                maskedNumber: tokenizedCard.cardInfo?.maskedNumber ,
                cardToken: tokenizedCard.token
            )
        )
    }
}

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
                .stroke(Color.gray.opacity(0.4),
                        lineWidth: 1)
        )
    }
}

#Preview {
    CardsListView(items: CardsViewModel.mocData)
}
