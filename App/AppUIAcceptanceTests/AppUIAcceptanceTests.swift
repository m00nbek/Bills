//
//  AppUIAcceptanceTests.swift
//  AppUIAcceptanceTests
//
//  Created by m00nbek Melikulov on 1/18/23.
//

import XCTest

final class AppUIAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        
        app.launch()
        
        let feedCells = app.cells.matching(identifier: "feed-expense-cell")
        XCTAssertEqual(feedCells.count, 8)
    }
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        let onlineApp = XCUIApplication()
        onlineApp.launch()
        
        let offlineApp = XCUIApplication()
        offlineApp.launchArguments = ["-connectivity", "offline"]
        offlineApp.launch()
        
        let cachedFeedCells = offlineApp.cells.matching(identifier: "feed-expense-cell")
        XCTAssertEqual(cachedFeedCells.count, 8)
    }
}
