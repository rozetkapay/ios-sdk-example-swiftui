//
//  CartView.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 29.08.2024.
//

import OSLog
import SwiftUI
import RozetkaPaySDK

struct CartView: View {
    private enum Constants {
        static let buttonCornerRadius: CGFloat = 16
    }
    
    @StateObject private var viewModel: CartViewModel
    @State private var isSheetPresented = false
    @Environment(\.presentationMode) var presentationMode

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
    
    var body: some View {
        VStack(alignment: .leading) {
            cartView
            Spacer()
            shipmentView
            totalView
            Spacer()
            checkoutButton
        }
        .navigationBarTitle("Your cart", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
        }
        .fullScreenCover(isPresented: $isSheetPresented) {
            RozetkaPaySDK.PayView(
                parameters: PaymentParameters(
                    client: ClientAuthParameters(
                        token: Credentials.DEV_AUTH_TOKEN
                    ),
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
                    handleResult(result)
                    isSheetPresented.toggle()
                })
        }
    }
    
    private var checkoutButton: some View {
        Button(action: {
            isSheetPresented.toggle()
        }) {
            Text("Checkout")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .font(.headline)
                .foregroundColor(.white)
                .cornerRadius(Constants.buttonCornerRadius)
        }
        .padding(.top, 20)
        .padding([.leading, .trailing])
    }
    
    private var cartView: some View {
        List(viewModel.items) { item in
            HStack {
                Image(item.imageName)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text("\(item.quantity) x \(item.price, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("\(item.price * Double(item.quantity), specifier: "%.2f")")
                    .font(.body)
            }
            .padding(.vertical, 4)
        }
        .listStyle(PlainListStyle())
    }
    
    private var totalView: some View {
        HStack {
            Text("Total:")
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
    
    private var shipmentView: some View {
        HStack {
            HStack {
                Text("Shipment:")
                    .font(.subheadline)
                Spacer()
                Text(viewModel.shipment)
                    .font(.subheadline)
            }
            .padding([.leading, .trailing])
        }
    }
    
    private func handleResult(_ result: PaymentResult) {
        switch result {
        case let .pending(orderId, paymentId):
            Logger.payment.info("Payment pending")
        case let .complete(orderId, paymentId):
            Logger.payment.info("Payment complete")
        case let .failed(paymentId, message, errorDescription):
            if let message = message, !message.isEmpty {
                Logger.payment.warning(
                    "⚠️ WARNING: An error with message \"\(message)\", paymentId: \"\(paymentId ?? "")\". Please try again. ⚠️"
                )
            } else {
                Logger.payment.warning(
                    "⚠️ WARNING: An error occurred during payment process. Please try again. ⚠️"
                )
            }
        case .cancelled:
            Logger.payment.info("Payment was cancelled")
        }
    }
}

#Preview {
    CartView(orderId: "test", items: CartViewModel.mocData)
}
