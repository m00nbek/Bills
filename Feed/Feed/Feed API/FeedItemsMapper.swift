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
        
        var feed: [FeedItem] {
            return items.map { $0.item }
        }
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

    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard response.statusCode == OK_200,
              let root = try? decoder.decode(Root.self, from: data)
        else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        
        return .success(root.feed)
    }
}

extension Currency: Decodable {}
