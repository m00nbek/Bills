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
        case let .success(expenseFeed)?:
            XCTAssertEqual(expenseFeed.count, 8, "Exptected 8 expenses in the test account")
            
            XCTAssertEqual(expenseFeed[0], expectedExpense(at: 0))
            XCTAssertEqual(expenseFeed[1], expectedExpense(at: 1))
            XCTAssertEqual(expenseFeed[2], expectedExpense(at: 2))
            XCTAssertEqual(expenseFeed[3], expectedExpense(at: 3))
            XCTAssertEqual(expenseFeed[4], expectedExpense(at: 4))
            XCTAssertEqual(expenseFeed[5], expectedExpense(at: 5))
            XCTAssertEqual(expenseFeed[6], expectedExpense(at: 6))
            XCTAssertEqual(expenseFeed[7], expectedExpense(at: 7))
        case let .failure(error)?:
            XCTFail("Expected successful feed result, got \(error) instead")
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func getFeedResult(file: StaticString = #filePath, line: UInt = #line) -> FeedLoader.Result? {
        let testServerURL = URL(string: "https://api.jsonbin.io/v3/b/63c6b96a01a72b59f24d25b7?meta=false")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemoteLoader(url: testServerURL, client: client, mapper: FeedItemsMapper.map)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: FeedLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3.0)
        return receivedResult
    }
    
    private func expectedExpense(at index: Int) -> FeedExpense {
        return FeedExpense(id: id(at: index), title: title(at: index), timestamp: timestamp(at: index), cost: cost(at: index), currency: currency(at: index))
    }
    
    private func id(at index: Int) -> UUID {
        return [
            UUID(uuidString: "980B8431-6796-457D-8071-526E8FF4A624")!,
            UUID(uuidString: "DAB4F5D6-2302-4E63-AFD8-1BAC9163CE35")!,
            UUID(uuidString: "5699ED0F-DA7A-4BF6-8776-D86236302579")!,
            UUID(uuidString: "2F131F1C-479F-4E93-90AE-660E25EACAA9")!,
            UUID(uuidString: "AB0C2264-2A4E-4E69-BF5D-1F51E5F2A516")!,
            UUID(uuidString: "B79E88C4-5C11-478E-82E8-D29D7E63F027")!,
            UUID(uuidString: "D2E636D9-A1E8-4B4E-B92A-ACA6D1E8EEC5")!,
            UUID(uuidString: "9D55E88D-AB85-444C-9655-DB480D67B560")!
        ][index]
    }
    
    private func title(at index: Int) -> String {
        return [
            "keychron k6",
            "watch",
            "Zero Two sticker pack",
            "cat with OCD",
            "ZY EDC - MT-01",
            "Discord nitro for 1 year",
            "apple",
            "kawasaki ninja 400"
        ][index]
    }
    
    private func timestamp(at index: Int) -> Date {
        return try! [
            Date("2022-12-04T04:49:12Z", strategy: .iso8601),
            Date("2022-12-03T12:20:25Z", strategy: .iso8601),
            Date("2022-12-04T04:45:43Z", strategy: .iso8601),
            Date("2022-12-04T04:48:15Z", strategy: .iso8601),
            Date("2022-12-04T04:52:33Z", strategy: .iso8601),
            Date("2022-12-04T04:53:53Z", strategy: .iso8601),
            Date("2022-12-04T04:20:24Z", strategy: .iso8601),
            Date("2022-12-04T04:45:20Z", strategy: .iso8601)
        ][index]
    }
    
    private func cost(at index: Int) -> Float {
        return [100, 450, 6, 455, 20, 99.99, 3400, 5600][index]
    }
    
    private func currency(at index: Int) -> FeedExpense.Currency {
        return [.USD, .USD, .USD, .USD, .USD, .USD, .UZS, .USD][index]
    }
}
