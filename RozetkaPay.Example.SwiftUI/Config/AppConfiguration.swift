//
//  AppConfiguration.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 09.06.2025.
//
import Foundation

final class AppConfiguration {
    private static var _shared: AppConfiguration = AppConfiguration()

    static var shared: AppConfiguration {
        return _shared
    }

    static func initialize(with environment: AppEnvironment) {
        _shared = AppConfiguration(environment: environment)
    }

    // MARK: - Instance
    let environment: AppEnvironment
    let credentials: Credentials.EnvironmentCredentials

    private init(environment: AppEnvironment = .development) {
        self.environment = environment
        self.credentials = Credentials.for(environment)
    }
}

enum AppEnvironment {
    case production
    case development
}
