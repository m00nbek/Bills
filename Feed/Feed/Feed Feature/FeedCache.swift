//
//  FeedCache.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/18/23.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedExpense], completion: @escaping (Result) -> Void)
}
