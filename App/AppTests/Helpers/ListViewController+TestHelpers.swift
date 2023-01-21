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
}

extension ListViewController {
    func numberOfRenderedNotes() -> Int {
        tableView.numberOfSections == 0 ? 0 :  tableView.numberOfRows(inSection: notesSection)
    }
    
    func noteMessage(at row: Int) -> String? {
        noteView(at: row)?.messageLabel.text
    }
    
    func noteDate(at row: Int) -> String? {
        noteView(at: row)?.dateLabel.text
    }
    
    private func noteView(at row: Int) -> ExpenseNoteCell? {
        guard numberOfRenderedNotes() > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: notesSection)
        return ds?.tableView(tableView, cellForRowAt: index) as? ExpenseNoteCell
    }
    
    private var notesSection: Int {
        return 0
    }
}

extension ListViewController {
    
    @discardableResult
    func simulateFeedExpenseViewVisible(at index: Int) -> FeedExpenseCell? {
        return feedExpenseView(at: index) as? FeedExpenseCell
    }
    
    func numberOfRenderedFeedExpenseViews() -> Int {
        tableView.numberOfSections == 0 ? 0 : tableView.numberOfRows(inSection: feedExpenseSection)
    }
    
    func feedExpenseView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedFeedExpenseViews() > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: feedExpenseSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var feedExpenseSection: Int {
        return 0
    }
}
