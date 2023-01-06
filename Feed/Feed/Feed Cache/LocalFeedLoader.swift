//
//  LocalFeedLoader.swift
//  Feed
//
//  Created by m00nbek Melikulov on 12/27/22.
//

import Foundation

private final class FeedCachePolicy {
    private let calender = Calendar(identifier: .gregorian)
   
    private var maxCacheAgeInDays: Int {
        return 7
    }
    
    func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calender.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else { return false }
        return date < maxCacheAge
    }
}


public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    private let cachePolicy = FeedCachePolicy()
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalFeedLoader {
    public typealias SaveResult = Error?

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
    
    private func cache(_ feed: [FeedExpense], with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate(), completion: { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        })
    }
}

extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = LoadFeedResult

    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .found(feed, timestamp) where self.cachePolicy.validate(timestamp, against: self.currentDate()):
                completion(.success(feed.toModels()))
            case .found, .empty:
                completion(.success([]))
            }
        }
    }
}

extension LocalFeedLoader {
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCachedFeed { _ in }
            case let .found(_, timestamp) where !self.cachePolicy.validate(timestamp, against: self.currentDate()):
                self.store.deleteCachedFeed { _ in }
            case .empty, .found:
                break
            }
        }
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
