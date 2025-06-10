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
    public init(
        items: [CardToken]? = nil
    ) {
        _viewModel = StateObject(
            wrappedValue: CardsViewModel(
                items: items ?? CardsViewModel.mocData
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
        Text(Localization.cards_title.description)
            .font(.headline)
            .padding([.leading, .top])
    }
    
    ///
    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            
            Images.arrowLeft.image()
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
                Images.plus.image()
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
                viewModel.handleResult(result)
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
    
}

//MARK: Preview
#Preview {
    CardsListView(items: CardsViewModel.mocData)
}
