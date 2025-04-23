//
//  AlertItem.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 11.04.2025.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let type: AlertType
    let title: String
    let message: String
}


enum AlertType {
    case success
    case error
    case info
    case soon
    case warning
    case custom(emoji: String)
    
    var color: Color {
        switch self {
        case .success:
            return .green
        case .error:
            return .red
        case .info:
            return .blue
        case .soon:
            return .blue
        case .custom:
            return .white
        case .warning:
            return .orange
        }
    }
    
    var textColor: Color {
        switch self {
        case .success:
            return .white
        case .error:
            return .white
        case .info:
            return .white
        case .soon:
            return .white
        case .custom:
            return .black
        case .warning:
            return .black
        }
    }
    
    var buttonColor: Color {
        switch self {
        case .success:
            return .white
        case .error:
            return .white
        case .info:
            return .white
        case .soon:
            return .white
        case .custom:
            return .green
        case .warning:
            return .white
        }
    }
    
    var emoji: String {
        switch self {
        case .success:
            return "✅"
        case .error:
            return "❌"
        case .info:
            return "ℹ️"
        case .soon:
            return "🔜"
        case .custom(let emoji):
            return emoji
        case .warning:
            return "⚠️"
        }
    }
    
    var circleColor: Color {
        switch self {
        case .success:
            return .white
        case .error:
            return .white
        case .info:
            return .white
        case .soon:
            return .white
        case .custom:
            return .gray
        case .warning:
            return .white
        }
    }
}
