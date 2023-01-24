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
        
        func loadPublisher() -> AnyPublisher<Paginated<FeedExpense>, Error> {
            let publisher = PassthroughSubject<Paginated<FeedExpense>, Error>()
            feedRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            feedRequests[index].send(completion: .failure(anyNSError()))
        }

        func completeFeedLoading(with feed: [FeedExpense] = [], at index: Int = 0) {
            feedRequests[index].send(Paginated(items: feed, loadMorePublisher: { [weak self] in
                self?.loadMorePublisher() ?? Empty().eraseToAnyPublisher()
            }))
        }
        
        // MARK: - LoadMoreFeedLoader

        private var loadMoreRequests = [PassthroughSubject<Paginated<FeedExpense>, Error>]()

        var loadMoreCallCount: Int {
            return loadMoreRequests.count
        }

        func loadMorePublisher() -> AnyPublisher<Paginated<FeedExpense>, Error> {
            let publisher = PassthroughSubject<Paginated<FeedExpense>, Error>()
            loadMoreRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeLoadMore(with feed: [FeedExpense] = [], lastPage: Bool = false, at index: Int = 0) {
            loadMoreRequests[index].send(Paginated(
                items: feed,
                loadMorePublisher: lastPage ? nil : { [weak self] in
                    self?.loadMorePublisher() ?? Empty().eraseToAnyPublisher()
                }))
        }
        
        func completeLoadMoreWithError(at index: Int = 0) {
            loadMoreRequests[index].send(completion: .failure(anyNSError()))
        }
    }
}

