//
//  RemoteFeedItem.swift
//  Feed
//
//  Created by m00nbek Melikulov on 12/27/22.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let title: String
    internal let timestamp: Date
    internal let cost: Float
    internal let currency: Currency
    internal enum Currency: String, Decodable {
        case USD
        case UZS
    }
}
