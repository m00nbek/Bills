//
//  FeedUIIntegrationTests+LoaderSpy.swift
//  FeediOSTests
//
//  Created by m00nbek Melikulov on 1/15/23.
//

import UIKit
import Feed
import FeediOS
import Combine

extension FeedUIIntegrationTests {
    class LoaderSpy {
        private var feedRequests = [PassthroughSubject<Paginated<FeedExpense>, Error>]()
        
        var loadFeedCallCount: Int {
            return feedRequests.count
        }
        
        private(set) var loadMoreCallCount = 0
        
        func loadPublisher() -> AnyPublisher<Paginated<FeedExpense>, Error> {
            let publisher = PassthroughSubject<Paginated<FeedExpense>, Error>()
            feedRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }

        func completeFeedLoading(with feed: [FeedExpense] = [], at index: Int = 0) {
            feedRequests[index].send(Paginated(items: feed, loadMore: { [weak self] _ in
                self?.loadMoreCallCount += 1
            }))
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0, userInfo: nil)
            feedRequests[index].send(completion: .failure(error))
        }
    }
}

