//
//  FeedPresenterTests.swift
//  FeedTests
//
//  Created by m00nbek Melikulov on 1/16/23.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}

class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendAnyMessageToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - Helpers
    private class ViewSpy {
        let messages = [Any]()
    }
}

