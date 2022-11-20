//
//  FeedItemsMapper.swift
//  Feed
//
//  Created by m00nbek Melikulov on 11/20/22.
//

import Foundation

internal final class FeedItemsMapper {
    
    private struct Root: Decodable {
        let items: [Item]
    }

    private struct Item: Decodable {
        let id: UUID
        let title: String
        let timestamp: Date
        let cost: Float
        let currency: Currency
        
        var item: FeedItem {
            return FeedItem(id: id, title: title, timestamp: timestamp, cost: cost, currency: currency)
        }
    }
    
    private static var OK_200: Int { return 200 }

    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let root = try decoder.decode(Root.self, from: data)
        return root.items.map { $0.item }
    }
}

extension Currency: Decodable {}
