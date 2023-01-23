//
//  Paginated.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/23/23.
//

import Foundation

public struct Paginated<Item> {
    // we're using `Self` here since it's the same type as `Paginated<Item>`
    public typealias LoadMoreCompletion = (Result<Self, Error>) -> Void
    
    public let items: [Item]
    public let loadMore: ((@escaping (LoadMoreCompletion)) -> Void)?
    
    public init(items: [Item], loadMore: ((@escaping (LoadMoreCompletion)) -> Void)? = nil) {
        self.items = items
        self.loadMore = loadMore
    }
}
