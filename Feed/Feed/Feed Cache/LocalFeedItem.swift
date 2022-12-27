//
//  LocalFeedItem.swift
//  Feed
//
//  Created by m00nbek Melikulov on 12/27/22.
//

import Foundation

public struct LocalFeedItem: Equatable {
    public let id: UUID
    public let title: String
    public let timestamp: Date
    public let cost: Float
    public let currency: Currency
    
    public init(id: UUID, title: String, timestamp: Date, cost: Float, currency: Currency) {
        self.id = id
        self.title = title
        self.timestamp = timestamp
        self.cost = cost
        self.currency = currency
    }
    
    public enum Currency: String {
        case USD
        case UZS
    }
}
