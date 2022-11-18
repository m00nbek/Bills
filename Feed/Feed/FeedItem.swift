//
//  FeedItem.swift
//  Feed
//
//  Created by m00nbek Melikulov on 11/18/22.
//

import Foundation

struct FeedItem {
    let id: UUID
    let title: String
    let timestamp: Date
    let cost: Float
    let currency: Currency
}

enum Currency {
    case USD
    case UZS
    
    var stringValue: String {
        switch self {
        case .USD:
            return "USD"
        case .UZS:
            return "UZS"
        }
    }
}
