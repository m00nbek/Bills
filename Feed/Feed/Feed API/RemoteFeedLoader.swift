//
//  RemoteFeedLoader.swift
//  Feed
//
//  Created by m00nbek Melikulov on 11/18/22.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                if response.statusCode == 200, let root = try? decoder.decode(Root.self, from: data) {
                    completion(.success(root.items.map { $0.item }))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

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

extension Currency: Decodable {}
