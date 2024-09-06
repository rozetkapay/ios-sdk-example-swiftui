//
//  LoggerExtensions.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 01.09.2024.
//

import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier ?? "RozetkaPay.Example.SwiftUI"

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
    
    /// All logs related to tracking and analytics.
    static let network = Logger(subsystem: subsystem, category: "network")
    
    /// All logs related to tracking and analytics.
    static let tokenizedCard = Logger(subsystem: subsystem, category: "tokenizedCard")
}
