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
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - Init
    public init(
        orderId: String,
        items: [Product]
    ) {
        _viewModel = StateObject(
            wrappedValue: CartViewModel(
                orderId: orderId,
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
            shipmentView
            totalView
            Spacer()
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
            Image(systemName: "chevron.left")
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
            Text("\(viewModel.totalPrice, specifier: "%.2f")")
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
    var checkoutView: some View {
        RozetkaPaySDK.PayView(
            parameters: PaymentParameters(
                client: viewModel.clientParameters,
                viewParameters: PaymentViewParameters(
                    cardNameField: .none,
                    emailField: .none,
                    cardholderNameField: .none
                ),
                themeConfigurator: RozetkaPayThemeConfigurator(),
                amountParameters:  PaymentParameters.AmountParameters(
                    amount: viewModel.totalAmount,
                    tax: viewModel.totalTax,
                    total: viewModel.totalPrice,
                    currencyCode: Config.defaultCurrencyCode
                ),
                orderId: viewModel.orderId,
                callbackUrl: Config.exampleCallbackUrl,
                isAllowTokenization: true,
                applePayConfig: viewModel.testApplePayConfig)
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
        ProductView(
            name: item.name,
            price: item.price,
            quantity: item.quantity,
            imageName: item.imageName
        )
    }
    
}

//MARK: Preview
#Preview {
    CartView(orderId: "test", items: CartViewModel.mocData)
}
