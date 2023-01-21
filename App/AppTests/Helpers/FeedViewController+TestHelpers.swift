//
//  FeedViewController+TestHelpers.swift
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
    
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func simulateErrorViewTap() {
        errorView.simulateTap()
    }
    
    var errorMessage: String? {
        return errorView.message
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
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
