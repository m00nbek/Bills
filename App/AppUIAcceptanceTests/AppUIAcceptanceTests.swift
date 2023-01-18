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
        
        XCTAssertEqual(app.cells.count, 8)
    }
}
