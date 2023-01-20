//
//  RemoteFeedLoader.swift
//  Feed
//
//  Created by m00nbek Melikulov on 11/18/22.
//

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedExpense]>

public extension RemoteFeedLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map)
    }
}
