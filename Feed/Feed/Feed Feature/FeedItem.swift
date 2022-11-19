//
//  FeedItem.swift
//  Feed
//
//  Created by m00nbek Melikulov on 11/18/22.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let title: String
    let timestamp: Date
    let cost: Float
    let currency: Currency
}

public enum Currency: String {
    case USD
    case UZS
}
