//
//  FeedSnapshotTests.swift
//  FeediOSTests
//
//  Created by m00nbek Melikulov on 1/19/23.
//

import XCTest
import FeediOS
@testable import Feed

class FeedSnapshotTests: XCTestCase {
    
    func test_feedWithContent() {
        let sut = makeSUT()
        
        sut.display(feedWithContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FEED_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FEED_WITH_CONTENT_dark")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light, contentSize: .extraExtraExtraLarge)), named: "FEED_WITH_CONTENT_light_extraExtraExtraLarge")
    }
    
    func test_feedWithLoadMoreIndicator() {
        let sut = makeSUT()
        
        sut.display(feedWithLoadMoreIndicator())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FEED_WITH_LOAD_MORE_INDICATOR_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FEED_WITH_LOAD_MORE_INDICATOR_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func feedWithContent() -> [ExpenseStub] {
        return [
            ExpenseStub(title: "Exhaust pipes", timestamp: Date(), cost: 450, currency: .USD),
            ExpenseStub(title: "Spinny boy", timestamp: Date(), cost: 4900, currency: .USD)
        ]
    }
    
    private func feedWithLoadMoreIndicator() -> [CellController] {
        let stub = feedWithContent().first!
        let cellController = FeedExpenseCellController(viewModel: stub.viewModel, selection: {})
        stub.controller = cellController
        
        let loadMore = LoadMoreCellController()
        loadMore.display(ResourceLoadingViewModel(isLoading: true))
        
        return [
            CellController(id: UUID(), cellController),
            CellController(id: UUID(), loadMore)
        ]
    }
}

private extension ListViewController {
    func display(_ stubs: [ExpenseStub]) {
        let cells: [CellController] = stubs.map { stub in
            let cellController = FeedExpenseCellController(viewModel: stub.viewModel, selection: {})
            stub.controller = cellController
            return CellController(id: UUID(), cellController)
        }
        
        display(cells)
    }
}

private class ExpenseStub {
    let viewModel: FeedExpenseViewModel
    weak var controller: FeedExpenseCellController?
    
    init(title: String, timestamp: Date, cost: Float, currency: FeedExpense.Currency) {
        viewModel = FeedExpenseViewModel(
            model: FeedExpense(
                id: UUID(),
                title: title,
                timestamp: timestamp,
                cost: cost,
                currency: currency)
        )
    }
}
