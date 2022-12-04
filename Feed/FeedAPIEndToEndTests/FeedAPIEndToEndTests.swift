//
//  FeedAPIEndToEndTests.swift
//  FeedAPIEndToEndTests
//
//  Created by m00nbek Melikulov on 12/4/22.
//

import XCTest
import Feed

final class FeedAPIEndToEndTests: XCTestCase {
    
    func test_endToEndTestServerGETFeedResult_matchesFixedTestAccountData() {
        switch getFeedResult() {
        case let .success(items)?:
            XCTAssertEqual(items.count, 8, "Exptected 8 items in the test account")
            
            XCTAssertEqual(items[0], expectedItem(at: 0))
            XCTAssertEqual(items[1], expectedItem(at: 1))
            XCTAssertEqual(items[2], expectedItem(at: 2))
            XCTAssertEqual(items[3], expectedItem(at: 3))
            XCTAssertEqual(items[4], expectedItem(at: 4))
            XCTAssertEqual(items[5], expectedItem(at: 5))
            XCTAssertEqual(items[6], expectedItem(at: 6))
            XCTAssertEqual(items[7], expectedItem(at: 7))
        case let .failure(error)?:
            XCTFail("Expected successful feed result, got \(error) instead")
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func getFeedResult(file: StaticString = #filePath, line: UInt = #line) -> LoadFeedResult? {
        let testServerURL = URL(string: "http://127.0.0.1:8080/test-feed")!
        let client = URLSessionHTTPClient()
        let loader = RemoteFeedLoader(url: testServerURL, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: LoadFeedResult?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 7.0)
        return receivedResult
    }
    
    private func expectedItem(at index: Int) -> FeedItem {
        return FeedItem(id: id(at: index), title: title(at: index), timestamp: timestamp(at: index), cost: cost(at: index), currency: currency(at: index))
    }
    
    private func id(at index: Int) -> UUID {
        return [
            UUID(uuidString: "DAB4F5D6-2302-4E63-AFD8-1BAC9163CE35")!,
            UUID(uuidString: "D2E636D9-A1E8-4B4E-B92A-ACA6D1E8EEC5")!,
            UUID(uuidString: "9D55E88D-AB85-444C-9655-DB480D67B560")!,
            UUID(uuidString: "5699ED0F-DA7A-4BF6-8776-D86236302579")!,
            UUID(uuidString: "2F131F1C-479F-4E93-90AE-660E25EACAA9")!,
            UUID(uuidString: "980B8431-6796-457D-8071-526E8FF4A624")!,
            UUID(uuidString: "AB0C2264-2A4E-4E69-BF5D-1F51E5F2A516")!,
            UUID(uuidString: "B79E88C4-5C11-478E-82E8-D29D7E63F027")!
        ][index]
    }
    
    private func title(at index: Int) -> String {
        return [
            "watch",
            "apple",
            "kawasaki ninja 400",
            "Zero Two sticker pack",
            "cat with OCD",
            "keychron k6",
            "ZY EDC - MT-01",
            "Discord nitro for 1 year"
        ][index]
    }
    
    private func timestamp(at index: Int) -> Date {
        return try! [
            Date("2022-12-03T12:20:25Z", strategy: .iso8601),
            Date("2022-12-04T04:20:24Z", strategy: .iso8601),
            Date("2022-12-04T04:45:20Z", strategy: .iso8601),
            Date("2022-12-04T04:45:43Z", strategy: .iso8601),
            Date("2022-12-04T04:48:15Z", strategy: .iso8601),
            Date("2022-12-04T04:49:12Z", strategy: .iso8601),
            Date("2022-12-04T04:52:33Z", strategy: .iso8601),
            Date("2022-12-04T04:53:53Z", strategy: .iso8601)
        ][index]
    }
    
    private func cost(at index: Int) -> Float {
        return [450, 3400, 5600, 6, 455, 100, 20, 99.99][index]
    }
    
    private func currency(at index: Int) -> Currency {
        return [.USD, .UZS, .USD, .USD, .USD, .USD, .USD, .USD][index]
    }
}
