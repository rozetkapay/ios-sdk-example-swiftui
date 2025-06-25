//
//  RozetkaPay_Example_SwiftUIApp.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 18.08.2024.
//

import SwiftUI
import RozetkaPaySDK

@main
struct RozetkaPay_Example_SwiftUIApp: App {
    
    init() {
        AppConfiguration.initialize(with: .production)
        RozetkaPaySdk.initSdk(
            appContext: UIApplication.shared,
            mode: .production,
            enableLogging: true,
            validationRules: RozetkaPaySdkValidationRules()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
