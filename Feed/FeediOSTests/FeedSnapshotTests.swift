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
        
        record(snapshot: sut.snapshot(), named: "EMPTY_FEED")
    }
    
    func test_feedWithContent() {
        let sut = makeSUT()

        sut.display(feedWithContent())

        record(snapshot: sut.snapshot(), named: "FEED_WITH_CONTENT")
    }
    
    func test_feedWithErrorMessage() {
        let sut = makeSUT()
        
        sut.display(.error(message: "This is a\nmulti-line\nerror message"))
        
        record(snapshot: sut.snapshot(), named: "FEED_WITH_ERROR_MESSAGE")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! FeedViewController
        controller.loadViewIfNeeded()
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
    
    private func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        guard let snapshotData = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return
        }
        
        let snapshotURL = URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
        
        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            
            try snapshotData.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }
    
}

private extension FeedViewController {
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

extension UIViewController {
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { action in
            view.layer.render(in: action.cgContext)
        }
    }
}
