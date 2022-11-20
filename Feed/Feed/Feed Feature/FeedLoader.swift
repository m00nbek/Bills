//
//  FeedLoader.swift
//  Feed
//
//  Created by m00nbek Melikulov on 11/20/22.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
