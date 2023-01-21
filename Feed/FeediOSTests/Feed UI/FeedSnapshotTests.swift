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
    
    func test_emptyFeed() {
        let sut = makeSUT()
        
        sut.display(emptyFeed())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_FEED_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_FEED_dark")
    }
    
    func test_feedWithContent() {
        let sut = makeSUT()
        
        sut.display(feedWithContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FEED_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FEED_WITH_CONTENT_dark")
    }
    
    func test_feedWithErrorMessage() {
        let sut = makeSUT()
        
        sut.display(.error(message: "This is a\nmulti-line\nerror message"))
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FEED_WITH_ERROR_MESSAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "FEED_WITH_ERROR_MESSAGE_dark")
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
    
    private func emptyFeed() -> [FeedExpenseCellController] {
        return []
    }
    
    private func feedWithContent() -> [ExpenseStub] {
        return [
            ExpenseStub(title: "Exhaust pipes", timestamp: Date(), cost: 450, currency: .USD),
            ExpenseStub(title: "Spinny boy", timestamp: Date(), cost: 4900, currency: .USD)
        ]
    }
}

private extension ListViewController {
    func display(_ stubs: [ExpenseStub]) {
        let cells: [FeedExpenseCellController] = stubs.map { stub in
            let cellController = FeedExpenseCellController(viewModel: stub.viewModel)
            stub.controller = cellController
            return cellController
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
