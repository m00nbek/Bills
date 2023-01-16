//
//  FeedViewController+TestHelpers.swift
//  FeediOSTests
//
//  Created by m00nbek Melikulov on 1/15/23.
//

import UIKit
import FeediOS

extension FeedViewController {
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var errorMessage: String? {
        return errorView?.message
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
