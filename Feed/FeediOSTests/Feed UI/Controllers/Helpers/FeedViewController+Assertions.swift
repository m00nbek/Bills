//
//  FeedViewController+Assertions.swift
//  FeediOSTests
//
//  Created by m00nbek Melikulov on 1/15/23.
//

import XCTest
import Feed
import FeediOS

extension FeedViewControllerTests {
    func assertThat(_ sut: FeedViewController, isRendering feed: [FeedExpense], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedFeedExpenseViews() == feed.count else {
            return XCTFail("Expected \(feed.count) expenses, got \(sut.numberOfRenderedFeedExpenseViews()) instead.", file: file, line: line)
        }
        
        feed.enumerated().forEach { index, expense in
            assertThat(sut, hasViewConfiguredFor: expense, at: index, file: file, line: line)
        }
    }
    
    func assertThat(_ sut: FeedViewController, hasViewConfiguredFor expense: FeedExpense, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.feedExpenseView(at: index)
        
        guard let cell = view as? FeedExpenseCell else {
            return XCTFail("Expected \(FeedExpenseCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(cell.titleText, expense.title, "Expected title text to be \(expense.title) for expense view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.costTextAsFloat, expense.cost, "Expected cost text to be \(expense.cost) for expense  view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.dateText, expense.timestamp.formatted(), "Expected date text to be \(expense.timestamp.formatted()) for expense view at index (\(index)", file: file, line: line)
    }
}
