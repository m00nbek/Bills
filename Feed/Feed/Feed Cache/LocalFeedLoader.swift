//
//  LocalFeedLoader.swift
//  Feed
//
//  Created by m00nbek Melikulov on 12/27/22.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public typealias SaveResult = Error?
    public typealias LoadResult = LoadFeedResult
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ feed: [FeedExpense], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self else { return }
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(feed, with: completion)
            }
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .found(feed, _):
                completion(.success(feed.toModels()))
            case .empty:
                completion(.success([]))
            }
        }
    }
    
    private func cache(_ feed: [FeedExpense], with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate(), completion: { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        })
    }
}

private extension Array where Element == FeedExpense {
    func toLocal() -> [LocalFeedExpense] {
        map { LocalFeedExpense(id: $0.id,
                            title: $0.title,
                            timestamp: $0.timestamp,
                            cost: $0.cost,
                            currency: LocalFeedExpense.Currency.init(rawValue: $0.currency.rawValue)!) }
    }
}

private extension Array where Element == LocalFeedExpense {
    func toModels() -> [FeedExpense] {
        map { FeedExpense(id: $0.id,
                            title: $0.title,
                            timestamp: $0.timestamp,
                            cost: $0.cost,
                            currency: FeedExpense.Currency.init(rawValue: $0.currency.rawValue)!) }
    }
}
