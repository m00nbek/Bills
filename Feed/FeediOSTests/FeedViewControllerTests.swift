//
//  FeedViewControllerTests.swift
//  FeediOSTests
//
//  Created by m00nbek Melikulov on 1/12/23.
//

import XCTest
import UIKit
import Feed
import FeediOS

final class FeedViewControllerTests: XCTestCase {
    
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a reload")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeFeedLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed")
    }
    
    func test_loadFeedCompletion_renderSuccessfullyLoadedFeed() {
        let expense0 = makeExpense(title: "a title", timestamp: Date(), cost: 47)
        let expense1 = makeExpense(title: "another title", timestamp: Date(), cost: 37)
        let expense2 = makeExpense(title: "ttitle with double Ts", timestamp: Date(), cost: 27)
        let expense3 = makeExpense(title: "title without an article", timestamp: Date(), cost: 17)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeFeedLoading(with: [expense0], at: 0)
        assertThat(sut, isRendering: [expense0])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoading(with: [expense0, expense1, expense2, expense3], at: 1)
        assertThat(sut, isRendering: [expense0, expense1, expense2, expense3])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func assertThat(_ sut: FeedViewController, isRendering feed: [FeedExpense], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedFeedExpenseViews() == feed.count else {
            return XCTFail("Expected \(feed.count) expenses, got \(sut.numberOfRenderedFeedExpenseViews()) instead.", file: file, line: line)
        }

        feed.enumerated().forEach { index, expense in
            assertThat(sut, hasViewConfiguredFor: expense, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: FeedViewController, hasViewConfiguredFor expense: FeedExpense, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.feedExpenseView(at: index)

        guard let cell = view as? FeedExpenseCell else {
            return XCTFail("Expected \(FeedExpenseCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertEqual(cell.titleText, expense.title, "Expected title text to be \(expense.title) for expense view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.costTextAsFloat, expense.cost, "Expected cost text to be \(expense.cost) for expense  view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.dateText, expense.timestamp.formatted(), "Expected date text to be \(expense.timestamp.formatted()) for expense view at index (\(index)", file: file, line: line)
    }
    
    private func makeExpense(title: String, timestamp: Date, cost: Float) -> FeedExpense {
        return FeedExpense(id: UUID(), title: title, timestamp: timestamp, cost: cost, currency: .USD)
    }
    
    class LoaderSpy: FeedLoader {
        private var completions = [(FeedLoader.Result) -> Void]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeFeedLoading(with feed: [FeedExpense] = [], at index: Int) {
            completions[index](.success(feed))
        }
    }
}

private extension FeedViewController {
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    func numberOfRenderedFeedExpenseViews() -> Int {
        return tableView.numberOfRows(inSection: feedExpenseSection)
    }
    
    func feedExpenseView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: feedExpenseSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var feedExpenseSection: Int {
        return 0
    }
}

private extension FeedExpenseCell {
    var titleText: String? {
        expenseTitleLabel.text
    }
    
    var costTextAsFloat: Float? {
        if let text = costLabel.text {
            return Float(text)
        }
        
        return nil
    }
    
    var dateText: String? {
        dateLabel.text
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

private extension Date {
    func formatted() -> String {
        let days = days(self)
        switch days {
        case 0:
            return "Today"
        case 1:
            return "Yesterday"
        default:
            return "\(days) days ago"
        }
    }
    
    private func days(_ start: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: Date()).day!
    }
}
