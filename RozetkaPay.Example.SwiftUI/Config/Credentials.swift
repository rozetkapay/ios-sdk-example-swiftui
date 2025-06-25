//
//  Credentials.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 01.09.2024.
//

import Foundation

struct Credentials {
    //MARK: - Methods
    static func `for`(_ environment: AppEnvironment) -> EnvironmentCredentials {
        switch environment {
        case .development:
            Development()
        case .production:
            Production()
        }
    }

    //MARK: - Protocol
    protocol EnvironmentCredentials {
        var WIDGET_KEY: String { get }
        var LOGIN: String { get }
        var PASSWORD: String { get }
        var AUTH_TOKEN: String { get }
        var APPLE_PAY_MERCHANT_ID: String { get }
        var APPLE_PAY_MERCHANT_NAME: String { get }
        var TEST_CARD_TOKEN_1: String { get }
        var ERROR_CARD_TOKEN_1: String { get }
        var BATCH_API_KEY: String { get }
    }

    //MARK: - Development
    private struct Development: EnvironmentCredentials {
         let WIDGET_KEY = "GmX1ig/xQraUC9BAxQVIQ6Cc/me9lWbDWw5R8gYpXdaPem1389Lm57rYGymKJG+N"

         let LOGIN = "LOGIN.Example"
         let PASSWORD = "PASSWORD.Example"
         let AUTH_TOKEN = "MWE2NWY1OGEtMGZmMS00MmI2LTk0MGItZDA0MGM1MDU0ODQzOlNUVkVSRWREYnpWR01GcDFSRnB1VG5aSU5scHJiekZ4"
        
         let APPLE_PAY_MERCHANT_ID = "merchant.RozetkaPay.Example"
         let APPLE_PAY_MERCHANT_NAME = "Rozetka Pay Demo Merchant"
        
         let TEST_CARD_TOKEN_1 = "ZWMwM2M4MGNkOTQ1NDc5MDllM2I5Mjg4MDY5OTFjYzI6UXFLdGIzUzl5UWhld0w5MDFT"
         let ERROR_CARD_TOKEN_1 = "ZGVkMTAxOGRlMGEzNDAxMjk4YTA1MjIzNzFiMDMyZGY6N2F1QTczU0NzZFRMQm85N0Mw"
        
         let BATCH_API_KEY = "ef316c93-8dd5-4d86-8366-8174880ec52c"
    }

    //MARK: - Production
    private struct Production: EnvironmentCredentials {
        let WIDGET_KEY = "7zFsk43VTYaDZoF0iA7FLKl6l0Cj+6uMxiZmKS1guUt0XKYjSKvAOkUXFihVe60k"
        
        let LOGIN = "LOGIN.Example"
        let PASSWORD = "PASSWORD.Example"
        let AUTH_TOKEN = "ZWYzMTZjOTMtOGRkNS00ZDg2LTgzNjYtODE3NDg4MGVjNTJjOlUwZEhjRFZSV1dWQmNtWjRNbTB4T1ROTWNYbHNja2RG"
        
        let APPLE_PAY_MERCHANT_ID = "merchant.RozetkaPay.Example"
        let APPLE_PAY_MERCHANT_NAME = "Rozetka Pay Demo Merchant"
        
        let TEST_CARD_TOKEN_1 = "ZWMwM2M4MGNkOTQ1NDc5MDllM2I5Mjg4MDY5OTFjYzI6UXFLdGIzUzl5UWhld0w5MDFT"
        let ERROR_CARD_TOKEN_1 = "ZGVkMTAxOGRlMGEzNDAxMjk4YTA1MjIzNzFiMDMyZGY6N2F1QTczU0NzZFRMQm85N0Mw"
        
        let BATCH_API_KEY = "ef316c93-8dd5-4d86-8366-8174880ec52c"
    }
}
