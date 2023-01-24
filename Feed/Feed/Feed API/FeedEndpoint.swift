//
//  FeedEndpoint.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import Foundation

public enum FeedEndpoint {
    case get(after: FeedExpense? = nil)
    
    public func url(baseURL: URL) -> URL {
        switch self {
            
        case let .get(expense):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v1/feed"
            components.queryItems = [
                URLQueryItem(name: "limit", value: "10"),
                expense.map { URLQueryItem(name: "after_id", value: $0.id.uuidString) },
            ].compactMap { $0 }
            return components.url!
        }
    }
}
