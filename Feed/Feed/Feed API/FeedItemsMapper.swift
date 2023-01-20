//
//  FeedItemsMapper.swift
//  Feed
//
//  Created by m00nbek Melikulov on 11/20/22.
//

import Foundation

final class FeedItemsMapper {
    
    private struct Root: Decodable {
        private let items: [RemoteFeedItem]
        
        private struct RemoteFeedItem: Decodable {
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
        
        var expenses: [FeedExpense] {
            items.map { FeedExpense(
                id: $0.id,
                title: $0.title,
                timestamp: $0.timestamp,
                cost: $0.cost,
                currency: .init(rawValue: $0.currency.rawValue)!)
            }
        }
    }
    
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [FeedExpense] {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard response.statusCode == OK_200,
              let root = try? decoder.decode(Root.self, from: data)
        else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.expenses
    }
}
