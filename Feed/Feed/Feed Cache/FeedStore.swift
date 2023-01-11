//
//  FeedStore.swift
//  Feed
//
//  Created by m00nbek Melikulov on 12/27/22.
//

import Foundation

public typealias CachedFeed = (feed: [LocalFeedExpense], timestamp: Date)

public protocol FeedStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed
    func insert(_ feed: [LocalFeedExpense], timestamp: Date, completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed
    func retrieve(completion: @escaping RetrievalCompletion)
}
