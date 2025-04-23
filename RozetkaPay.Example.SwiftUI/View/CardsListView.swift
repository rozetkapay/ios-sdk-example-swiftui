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
    //MARK: - Properties
    @StateObject var viewModel: CardsViewModel
    @State private var isSheetPresented = false
    @State private var alertItem: AlertItem?
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - Init
    public init(items: [CardToken]) {
        _viewModel = StateObject(
            wrappedValue: CardsViewModel(
                items: items
            )
        )
    }
    
    //MARK: - UI
    var body: some View {
        VStack(alignment: .leading) {
            titleView
            listView
            Spacer()
            addNewCardButton
        }
        .navigationBarTitle(Localization.cards_navigation_bar_title.description, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
        .fullScreenCover(isPresented: $isSheetPresented) {
            tokenizationView
        }
        .customAlert(item: $alertItem)
    }
}

//MARK: UI
private extension CardsListView {
    
    ///
    var titleView: some View {
        Text(Localization.cart_title.description)
            .font(.headline)
            .padding([.leading, .top])
    }
    
    ///
    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.primary)
        }
    }
    
    ///
    var listView: some View {
        List(viewModel.items) { item in
            HStack {
                makeCardView(item)
            }
            .listRowInsets(
                EdgeInsets(
                    top: 5,
                    leading: 20,
                    bottom: 5,
                    trailing: 20
                )
            )
            .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
    }
    
    ///
    var addNewCardButton: some View {
        Button(action: {
            isSheetPresented.toggle()
        }) {
            HStack {
                Image(systemName: "plus")
                Text(Localization.cards_add_new_card_button_title.description)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(12)
        }
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    ///
    var tokenizationView: some View {
        RozetkaPaySDK.TokenizationView(
            parameters: TokenizationParameters(
                client: viewModel.clientWidgetParameters,
                viewParameters: TokenizationViewParameters(
                    cardNameField: .optional,
                    emailField: .required,
                    cardholderNameField: .optional
                )
            ),
            onResultCallback: { result in
                handleResult(result)
                isSheetPresented.toggle()
            }
        )
    }
}

//MARK: Private Methods
private extension CardsListView {
    
    func makeCardView(_ item: CardToken) -> some View {
        CardView(
            cardTypeImage: item.paymentSystem.logoName,
            cardName: item.name,
            maskedNumber: item.maskedNumber
        )
    }
    
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

//MARK: Preview
#Preview {
    CardsListView(items: CardsViewModel.mocData)
}
