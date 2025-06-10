//
//  BatchCartView.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 29.05.2025.
//
import SwiftUI
import RozetkaPaySDK

struct BatchCartView: View {
    //MARK: - Properties
    @StateObject private var viewModel: BatchCartViewModel
    @State private var isSheetPresented = false
    @State private var isNeedToUseTokenizedCard = false
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - Init
    public init(
        externalId: String? = nil,
        orders: [Order]? = nil
    ) {
        _viewModel = StateObject(
            wrappedValue: BatchCartViewModel(
                externalId: externalId ?? BatchCartViewModel.generateExternalId(),
                orders: orders ?? BatchCartViewModel.mocData
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
        .navigationBarTitle(Localization.batch_cart_navigation_bar_title.description, displayMode: .inline)
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
private extension BatchCartView {
    
    ///
    var titleView: some View {
        Text(Localization.batch_cart_title.description)
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
            Text(Localization.batch_cart_checkout_button_title.description)
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
        List {
            ForEach(viewModel.orders.indices, id: \.self) { index in
                
                let order = viewModel.orders[index]
                
                Section(
                    header:
                        HStack {
                            Text("\(Localization.batch_cart_group_order_title.description) \(index + 1)")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Spacer()

                            Text("\(Localization.batch_cart_group_order_total_title.description): \(order.totalAmount, format: .currency(code: order.products.first?.currency ?? Config.defaultCurrencyCode))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.systemGroupedBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                        )
                ) {
                    ForEach(order.products.indices, id: \.self) { productIndex in
                        let product = order.products[productIndex]
                        HStack {
                            makeProductView(product)
                        }
                        .listRowSeparator(.hidden)
                    }
                    if index == viewModel.orders.count - 1 {
                        Spacer().frame(height: 16)
                    }
                }
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
            Text(Localization.batch_cart_total_title.description)
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
                Text(Localization.batch_cart_shipment_title.description)
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
            
            Text(Localization.batch_cart_use_tokenized_card.description)
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
            batchPaymentParameters: BatchPaymentParameters(
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
                externalId: viewModel.externalId,
                callbackUrl: Config.exampleCallbackUrl,
                resultUrl: Config.exampleResultUrl,
                orders: viewModel.orders.mapToBatchOrder()
            ),
            onResultCallback: { result in
                viewModel.handleResult(result)
                isSheetPresented.toggle()
            }
        )
    }
    
}

//MARK: Private Methods
private extension BatchCartView {
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
    BatchCartView(
        externalId: "test",
        orders: BatchCartViewModel.mocData
    )
}
