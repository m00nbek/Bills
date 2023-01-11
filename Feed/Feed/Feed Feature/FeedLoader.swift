//
//  FeedLoader.swift
//  Feed
//
//  Created by m00nbek Melikulov on 11/20/22.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedExpense], Error>
    func load(completion: @escaping (Result) -> Void)
}
