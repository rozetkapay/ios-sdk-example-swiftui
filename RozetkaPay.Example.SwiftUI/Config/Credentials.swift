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
    
    // MARK: - Token Generator
   private static func makeAuthToken(login: String, password: String) -> String {
        let credentials = "\(login):\(password)"
        let token = Data(credentials.utf8).base64EncodedString()
       print(token)
       return token
    }
    
    //MARK: - Protocol
    protocol EnvironmentCredentials {
        var WIDGET_KEY: String { get }
        
        var LOGIN: String { get }
        var PASSWORD: String { get }
        var AUTH_TOKEN: String { get }
        
        var LOGIN_BATCH: String { get }
        var PASSWORD_BATCH: String { get }
        var AUTH_TOKEN_BATCH: String { get }
        var BATCH_API_KEY: String { get }
        
        var APPLE_PAY_MERCHANT_ID: String { get }
        var APPLE_PAY_MERCHANT_NAME: String { get }
        
        var TEST_CARD_TOKEN_1: String { get }
        var ERROR_CARD_TOKEN_1: String { get }
    }
    
    //MARK: - Development
    private struct Development: EnvironmentCredentials {
        let WIDGET_KEY = "GmX1ig/xQraUC9BAxQVIQ6Cc/me9lWbDWw5R8gYpXdaPem1389Lm57rYGymKJG+N"
        
        let LOGIN = "7e5ba9f2-572b-4fb9-af69-d243c5ab56a6"
        let PASSWORD = "ZE9lcjdnWng5S0RKRHFhR2tQYTRWSnRa"
        var AUTH_TOKEN: String {
            Credentials.makeAuthToken(login: LOGIN, password: PASSWORD)
        }
        
        let LOGIN_BATCH = "LOGIN.Example"
        let PASSWORD_BATCH = "PASSWORD.Example"
        var AUTH_TOKEN_BATCH: String {
            Credentials.makeAuthToken(login: LOGIN_BATCH, password: PASSWORD_BATCH)
        }

        let BATCH_API_KEY = "ef316c93-8dd5-4d86-8366-8174880ec52c"
        
        let APPLE_PAY_MERCHANT_ID = "merchant.RozetkaPay.Example"
        let APPLE_PAY_MERCHANT_NAME = "Rozetka Pay Demo Merchant"
        
        let TEST_CARD_TOKEN_1 = "ZWMwM2M4MGNkOTQ1NDc5MDllM2I5Mjg4MDY5OTFjYzI6UXFLdGIzUzl5UWhld0w5MDFT"
        let ERROR_CARD_TOKEN_1 = "ZGVkMTAxOGRlMGEzNDAxMjk4YTA1MjIzNzFiMDMyZGY6N2F1QTczU0NzZFRMQm85N0Mw"
    }
    
    //MARK: - Production
    private struct Production: EnvironmentCredentials {
        let WIDGET_KEY = "Bujzvr5EQd+cP9QeimLcMDjwtqVBXUSQxhs2ACpzYaR2mDmBlHPpLp8y5skjVrYg"
        
        let LOGIN = "06e8f3be-be44-41df-9c3f-d41e8a62dc30"
        let PASSWORD = "VE50V0ZMY0RsRTdzeFl1QzJQdXpFQ3d1"
        
        var AUTH_TOKEN: String {
            Credentials.makeAuthToken(login: LOGIN, password: PASSWORD)
        }

        let LOGIN_BATCH = "ef316c93-8dd5-4d86-8366-8174880ec52c"
        let PASSWORD_BATCH = "U0dHcDVRWWVBcmZ4Mm0xOTNMcXlsckdF"
        var AUTH_TOKEN_BATCH: String {
            Credentials.makeAuthToken(login: LOGIN_BATCH, password: PASSWORD_BATCH)
        }

        let BATCH_API_KEY = "ef316c93-8dd5-4d86-8366-8174880ec52c"
        
        let APPLE_PAY_MERCHANT_ID = "merchant.RozetkaPay.Example"
        let APPLE_PAY_MERCHANT_NAME = "Rozetka Pay Demo Merchant"
        
        let TEST_CARD_TOKEN_1 = "ZWMwM2M4MGNkOTQ1NDc5MDllM2I5Mjg4MDY5OTFjYzI6UXFLdGIzUzl5UWhld0w5MDFT"
        let ERROR_CARD_TOKEN_1 = "ZGVkMTAxOGRlMGEzNDAxMjk4YTA1MjIzNzFiMDMyZGY6N2F1QTczU0NzZFRMQm85N0Mw"
        
    }
}
