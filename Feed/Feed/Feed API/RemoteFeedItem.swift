//
//  RemoteFeedItem.swift
//  Feed
//
//  Created by m00nbek Melikulov on 12/27/22.
//

import Foundation

 struct RemoteFeedItem: Decodable {
     let id: UUID
     let title: String
     let timestamp: Date
     let cost: Float
     let currency: Currency
     enum Currency: String, Decodable {
        case USD
        case UZS
    }
}
