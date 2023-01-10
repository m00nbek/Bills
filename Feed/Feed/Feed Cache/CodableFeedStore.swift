//
//  CodableFeedStore.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/8/23.
//

import Foundation

public class CodableFeedStore: FeedStore {
    private struct Cache: Codable {
        let feed: [CodableFeedExpense]
        let timestamp: Date
        
        var localFeed: [LocalFeedExpense] {
            return feed.map { $0.local }
        }
    }
    
    private struct CodableFeedExpense: Codable {
        private let id: UUID
        private let title: String
        private let timestamp: Date
        private let cost: Float
        private let currency: Currency
        
        private enum Currency: String, Codable {
            case USD
            case UZS
        }
        
        init(_ expense: LocalFeedExpense) {
            id = expense.id
            title = expense.title
            timestamp = expense.timestamp
            cost = expense.cost
            currency = Currency(rawValue: expense.currency.rawValue)!
        }
        
        var local: LocalFeedExpense {
            return LocalFeedExpense(id: id, title: title, timestamp: timestamp, cost: cost, currency: LocalFeedExpense.Currency(rawValue: currency.rawValue)!)
        }
    }
    
    private let queue = DispatchQueue(label: "\(CodableFeedStore.self)Queue", qos: .userInitiated)
    
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let storeURL = self.storeURL
        queue.async {
            guard let data = try? Data(contentsOf: storeURL) else {
                completion(.empty)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let cache = try decoder.decode(Cache.self, from: data)
                completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ feed: [LocalFeedExpense], timestamp: Date, completion: @escaping InsertionCompletion) {
        let storeURL = self.storeURL
        queue.async {
            do {
                let encoder = JSONEncoder()
                let cache = Cache(feed: feed.map(CodableFeedExpense.init), timestamp: timestamp)
                let encoded = try encoder.encode(cache)
                try encoded.write(to: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        let storeURL = self.storeURL
        queue.async {
            guard FileManager.default.fileExists(atPath: storeURL.path) else {
                return completion(nil)
            }
            
            do {
                try FileManager.default.removeItem(at: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
