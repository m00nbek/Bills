//
//  FeedUIIntegrationTests.swift
//  FeediOSTests
//
//  Created by m00nbek Melikulov on 1/12/23.
//

import XCTest
import UIKit
import Feed
import FeediOS
import App

class FeedUIIntegrationTests: XCTestCase {
    
    func test_feedView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, feedTitle)
    }
    
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadFeedCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadFeedCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadFeedCallCount, 2, "Expected another loading request once user initiates a reload")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadFeedCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadMoreActions_requestMoreFromLoader() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeFeedLoading()

        XCTAssertEqual(loader.loadMoreCallCount, 0, "Expected no requests before until load more action")

        sut.simulateLoadMoreFeedAction()
        XCTAssertEqual(loader.loadMoreCallCount, 1, "Expected load more request")
        
        sut.simulateLoadMoreFeedAction()
        XCTAssertEqual(loader.loadMoreCallCount, 1, "Expected no request while loading more")
        
        loader.completeLoadMore(lastPage: false, at: 0)
        sut.simulateLoadMoreFeedAction()
        XCTAssertEqual(loader.loadMoreCallCount, 2, "Expected request after load more completed with more pages")

        loader.completeLoadMoreWithError(at: 1)
        sut.simulateLoadMoreFeedAction()
        XCTAssertEqual(loader.loadMoreCallCount, 3, "Expected request after load more failure")

        loader.completeLoadMore(lastPage: true, at: 2)
        sut.simulateLoadMoreFeedAction()
        XCTAssertEqual(loader.loadMoreCallCount, 3, "Expected no request after loading all pages")
    }
    
    func test_loadingMoreIndicator_isVisibleWhileLoadingMore() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.isShowingLoadMoreFeedIndicator, "Expected no loading indicator once view is loaded")

        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadMoreFeedIndicator, "Expected no loading indicator once loading completes successfully")

        sut.simulateLoadMoreFeedAction()
        XCTAssertTrue(sut.isShowingLoadMoreFeedIndicator, "Expected loading indicator on load more action")

        loader.completeLoadMore(at: 0)
        XCTAssertFalse(sut.isShowingLoadMoreFeedIndicator, "Expected no loading indicator once user initiated loading completes successfully")

        sut.simulateLoadMoreFeedAction()
        XCTAssertTrue(sut.isShowingLoadMoreFeedIndicator, "Expected loading indicator on second load more action")

        loader.completeLoadMoreWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadMoreFeedIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
        
        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeFeedLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }
    
    func test_loadFeedCompletion_renderSuccessfullyLoadedFeed() {
        let expense0 = makeExpense(title: "a title", timestamp: Date(), cost: 47)
        let expense1 = makeExpense(title: "another title", timestamp: Date(), cost: 37)
        let expense2 = makeExpense(title: "ttitle with double Ts", timestamp: Date(), cost: 27)
        let expense3 = makeExpense(title: "title without an article", timestamp: Date(), cost: 17)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeFeedLoading(with: [expense0, expense1], at: 0)
        assertThat(sut, isRendering: [expense0, expense1])
        
        sut.simulateLoadMoreFeedAction()
        loader.completeLoadMore(with: [expense0, expense1, expense2, expense3], at: 0)
        assertThat(sut, isRendering: [expense0, expense1, expense2, expense3])
        
        sut.simulateUserInitiatedReload()
        loader.completeFeedLoading(with: [expense0, expense1], at: 1)
        assertThat(sut, isRendering: [expense0, expense1])
    }
    
    func test_loadFeedCompletion_rendersSuccessfullyLoadedEmptyFeedAfterNonEmptyFeed() {
        let expense0 = makeExpense(title: "a title", timestamp: Date(), cost: 47)
        let expense1 = makeExpense(title: "another title", timestamp: Date(), cost: 37)

        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [expense0], at: 0)
        assertThat(sut, isRendering: [expense0])

        sut.simulateLoadMoreFeedAction()
        loader.completeLoadMore(with: [expense0, expense1], at: 0)
        assertThat(sut, isRendering: [expense0, expense1])

        sut.simulateUserInitiatedReload()
        loader.completeFeedLoading(with: [], at: 1)
        assertThat(sut, isRendering: [])
    }
    
    func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let expense0 = makeExpense(title: "title", timestamp: Date(), cost: 12)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [expense0], at: 0)
        assertThat(sut, isRendering: [expense0])
        
        sut.simulateUserInitiatedReload()
        loader.completeFeedLoadingWithError(at: 1)
        assertThat(sut, isRendering: [expense0])
    }
    
    func test_loadFeedCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeFeedLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadMoreCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(at: 0)
        sut.simulateLoadMoreFeedAction()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeLoadMore()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadFeedCompletion_rendersErrorMessageOnErrorUntilNextReload()  {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)
        
        loader.completeFeedLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    func test_tapOnErrorView_hidesErrorMessage() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)

        loader.completeFeedLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)

        sut.simulateErrorViewTap()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    func test_loadMoreCompletion_rendersErrorMessageOnError() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeFeedLoading()

        sut.simulateLoadMoreFeedAction()
        XCTAssertEqual(sut.loadMoreFeedErrorMessage, nil)

        loader.completeLoadMoreWithError()
        XCTAssertEqual(sut.loadMoreFeedErrorMessage, loadError)

        sut.simulateLoadMoreFeedAction()
        XCTAssertEqual(sut.loadMoreFeedErrorMessage, nil)
    }
    
    func test_expenseSelection_notifiesHandler() {
        let expense0 = makeExpense()
        let expense1 = makeExpense()
        var selectedExpenses = [FeedExpense]()
        let (sut, loader) = makeSUT(selection: { selectedExpenses.append($0) })

        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [expense0, expense1], at: 0)

        sut.simulateTapOnFeedExpense(at: 0)
        XCTAssertEqual(selectedExpenses, [expense0])

        sut.simulateTapOnFeedExpense(at: 1)
        XCTAssertEqual(selectedExpenses, [expense0, expense1])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        selection: @escaping (FeedExpense) -> Void = { _ in },
        file: StaticString = #file,
        line: UInt = #line)
    -> (sut: ListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedUIComposer.feedComposedWith(
            feedLoader: loader.loadPublisher,
            selection: selection
        )
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }    
    
    private func makeExpense(title: String = "", timestamp: Date = Date(), cost: Float = 0) -> FeedExpense {
        return FeedExpense(id: UUID(), title: title, timestamp: timestamp, cost: cost, currency: .USD)
    }
}
