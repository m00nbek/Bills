//
//  FeedStore.swift
//  Feed
//
//  Created by m00nbek Melikulov on 12/27/22.
//

import Foundation

public protocol FeedStore {
    typealias DeletingCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (Error?) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletingCompletion)
    func insert(_ feed: [LocalFeedExpense], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
