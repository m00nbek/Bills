//
//  FeedEndpointTests.swift
//  FeedTests
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import XCTest
import Feed

class FeedEndpointTests: XCTestCase {
    
    func test_feed_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = FeedEndpoint.get.url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/v1/feed")!
        
        XCTAssertEqual(received, expected)
    }
}
