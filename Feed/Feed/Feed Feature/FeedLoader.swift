//
//  FeedLoader.swift
//  Feed
//
//  Created by m00nbek Melikulov on 11/18/22.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
