//
//  CartView.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//


import SwiftUI
import RozetkaPaySDK

struct CartView: View {
    //MARK: - Properties
    @StateObject private var viewModel: CartViewModel
    @State private var isSheetPresented = false
    @State private var isNeedToUseTokenizedCard = false
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - Init
    public init(
        orderId: String? = nil,
        items: [Product]? = nil
    ) {
        _viewModel = StateObject(
            wrappedValue: CartViewModel(
                orderId: orderId ?? CartViewModel.generateOrderId(),
                items: items ?? CartViewModel.generateMocData()
            )
        )
    }
    
    //MARK: - UI
    var body: some View {
        VStack(alignment: .leading) {
            titleView
            listView
            Spacer()
            shipmentView
            totalView
            Spacer()
            checkBoxView
            checkoutButton
        }
        .navigationBarTitle(Localization.cart_navigation_bar_title.description, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
        .fullScreenCover(isPresented: $isSheetPresented) {
            checkoutView
        }
        .customAlert(item: $viewModel.alertItem)
    }
}

//MARK: UI
private extension CartView {
    
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
            Images.arrowLeft.image()
                .foregroundColor(.primary)
        }
    }
    
    ///
    var checkoutButton: some View {
        Button(action: {
            isSheetPresented.toggle()
        }) {
            Text(Localization.cart_checkout_button_title.description)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .font(.headline)
                .foregroundColor(.white)
                .cornerRadius(Config.buttonCornerRadius)
        }
        .padding(.top, 20)
        .padding([.leading, .trailing])
    }
    
    ///
    var listView: some View {
        List(viewModel.items) { item in
            HStack {
                makeProductView(item)
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
    var totalView: some View {
        HStack {
            Text(Localization.cart_total_title.description)
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
            Text("\(viewModel.totalAmount, specifier: "%.2f")")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.green)
        }
        .padding([.leading, .trailing])
    }
    
    ///
    var shipmentView: some View {
        HStack {
            HStack {
                Text(Localization.cart_shipment_title.description)
                    .font(.subheadline)
                Spacer()
                Text(viewModel.shipment)
                    .font(.subheadline)
            }
            .padding([.leading, .trailing])
        }
    }
    
    ///
    var checkBoxView: some View {
        HStack {
            Toggle(isOn: $isNeedToUseTokenizedCard) {}
                .toggleStyle(
                    CheckBoxStyle(
                        colorOn: .green,
                        colorOff: .gray
                    )
                )
                .labelsHidden()
            
            Text(Localization.cart_use_tokenized_card.description)
                .font(.subheadline)
        }
        .padding()
    }
    
    struct CheckBoxStyle: ToggleStyle {
        let colorOn: Color
        let colorOff: Color
        
        func makeBody(configuration: Configuration) -> some View {
            return Button(action: {
                configuration.isOn.toggle()
            }) {
                Image(systemName: configuration.isOn ?
                      Images.checkmarkSquareFill.name :
                      Images.square.name
                )
                .resizable()
                .frame(width: 26, height: 26)
                .foregroundColor(
                    configuration.isOn ? colorOn : colorOff
                )
                .overlay(
                    Images.checkmark.image()
                        .foregroundColor(.white)
                        .opacity(
                            configuration.isOn ? 1 : 0
                        )
                        .padding(4)
                )
            }
        }
    }
    
    ///
    var checkoutView: some View {
        RozetkaPaySDK.PayView(
            paymentParameters: PaymentParameters(
                client: viewModel.clientParameters,
                themeConfigurator: RozetkaPayThemeConfigurator(),
                paymentType:
                    isNeedToUseTokenizedCard ?
                    .singleToken(
                        SingleTokenPayment(
                            token: viewModel.testCardToken
                        )
                    ) :
                    .regular(
                        RegularPayment(
                            viewParameters: PaymentViewParameters(
                                cardNameField: .none,
                                emailField: .none,
                                cardholderNameField: .none
                            ),
                            isAllowTokenization: true,
                            applePayConfig: viewModel.testApplePayConfig
                        )
                ),
                amountParameters:  AmountParameters(
                    amount: viewModel.totalNetAmountInCoins,
                    tax: viewModel.totalVatAmountInCoins,
                    total: viewModel.totalAmountInCoins,
                    currencyCode: Config.defaultCurrencyCode
                ),
                externalId: viewModel.orderId,
                callbackUrl: Config.exampleCallbackUrl
            )
            ,
            onResultCallback: { result in
                viewModel.handleResult(result)
                isSheetPresented.toggle()
            }
        )
    }
}

//MARK: Private Methods
private extension CartView {
    func makeProductView(_ item: Product) -> some View {
        return ProductView(
            name: item.name,
            price: item.price,
            quantity: item.quantity,
            amount: item.amount,
            imageName: item.image
        )
    }
}

//MARK: Preview
#Preview {
    CartView(
        orderId: CartViewModel.generateOrderId(),
        items: CartViewModel.generateMocData()
    )
}
