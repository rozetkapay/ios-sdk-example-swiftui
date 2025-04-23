//
//  CustomAlertView.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 11.04.2025.
//

import SwiftUI

struct CustomAlertView: View {
    let item: AlertItem
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(item.title)
                .font(.headline)
                .foregroundColor(item.type.textColor)
                .padding(.top, 16)
            ZStack {
                Circle()
                    .fill(item.type.circleColor)
                    .frame(width: 60, height: 60)
                Text(item.type.emoji)
                    .font(.title)
            }
            Text(item.message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(item.type.textColor)
                .padding(.top, 16)

            Button(Localization.ok_button_title.description) {
                onDismiss()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .font(.headline)
            .background(item.type.buttonColor)
            .foregroundColor(item.type.color)
            .cornerRadius(Config.buttonCornerRadius)
        }
        .padding(20)
        .frame(maxWidth: 300)
        .background(item.type.color)
        .cornerRadius(16)
        .shadow(radius: 8)
    }
}

struct CustomAlertModifier: ViewModifier {
    @Binding var item: AlertItem?
   
    func body(content: Content) -> some View {
        ZStack {
            content
            if let item = item {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                CustomAlertView(item: item) {
                        self.item = nil
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

extension View {
    func customAlert(item: Binding<AlertItem?>) -> some View {
        self.modifier(CustomAlertModifier(item: item))
    }
}

#Preview {
    CustomAlertView(
        item: AlertItem(
            type: .error,
            title: "Oops!",
            message: "Something went wrong"
        ),
        onDismiss: {
        }
    )
}
