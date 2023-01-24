//
//  ListViewController+TestHelpers.swift
//  FeediOSTests
//
//  Created by m00nbek Melikulov on 1/15/23.
//

import UIKit
import FeediOS

extension ListViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
        tableView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    }
    
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    func simulateErrorViewTap() {
        errorView.simulateTap()
    }
    
    var errorMessage: String? {
        return errorView.message
    }
    
    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }
    
    func cell(row: Int, section: Int) -> UITableViewCell? {
        guard numberOfRows(in: section) > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: section)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
}

extension ListViewController {
    func numberOfRenderedNotes() -> Int {
        numberOfRows(in: notesSection)
    }
    
    func noteMessage(at row: Int) -> String? {
        noteView(at: row)?.messageLabel.text
    }
    
    func noteDate(at row: Int) -> String? {
        noteView(at: row)?.dateLabel.text
    }
    
    private func noteView(at row: Int) -> ExpenseNoteCell? {
        cell(row: row, section: notesSection) as? ExpenseNoteCell
    }
    
    private var notesSection: Int { 0 }
}

extension ListViewController {
    
    func simulateTapOnFeedExpense(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedExpenseSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    func simulateLoadMoreFeedAction() {
        guard let view = loadMoreFeedCell() else { return }
        
        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: feedLoadMoreSection)
        delegate?.tableView?(tableView, willDisplay: view, forRowAt: index)
    }
    
    func simulateTapOnLoadMoreFeedError() {
        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: feedLoadMoreSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    var isShowingLoadMoreFeedIndicator: Bool {
        return loadMoreFeedCell()?.isLoading == true
    }
    
    var loadMoreFeedErrorMessage: String? {
        return loadMoreFeedCell()?.message
    }
    
    var canLoadMoreFeed: Bool {
        loadMoreFeedCell() != nil
    }
    
    private func loadMoreFeedCell() -> LoadMoreCell? {
        cell(row: 0, section: feedLoadMoreSection) as? LoadMoreCell
    }
    
    @discardableResult
    func simulateFeedExpenseViewVisible(at index: Int) -> FeedExpenseCell? {
        return feedExpenseView(at: index) as? FeedExpenseCell
    }
    
    func numberOfRenderedFeedExpenseViews() -> Int {
        numberOfRows(in: feedExpenseSection)
    }
    
    func feedExpenseView(at row: Int) -> UITableViewCell? {
        cell(row: row, section: feedExpenseSection)
    }
    
    private var feedExpenseSection: Int { 0 }
    private var feedLoadMoreSection: Int { 1 }
}
