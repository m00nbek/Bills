//
//  FeedItemsMapperTests.swift
//  FeedTests
//
//  Created by m00nbek Melikulov on 1/20/23.
//

import XCTest
import Feed

class FeedItemsMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try FeedItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        
        let result = try FeedItemsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: UUID(),
            title: "A title",
            timestamp: Date(timeIntervalSinceReferenceDate: Date.timeIntervalSinceReferenceDate.rounded()),
            cost: 45,
            currency: .USD)
        
        let item2 = makeItem(
            id: UUID(),
            title: "Another title",
            timestamp: Date(timeIntervalSinceReferenceDate: Date.timeIntervalSinceReferenceDate.rounded()),
            cost: 23000,
            currency: .UZS)
        
        let json = makeItemsJSON([item1.json, item2.json])
        
        let result = try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // MARK: - Helpers
    
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
    }
    
    private func makeItem(id: UUID, title: String, timestamp: Date, cost: Float, currency: FeedExpense.Currency) -> (model: FeedExpense, json: [String: Any]) {
        let item = FeedExpense(id: id, title: title, timestamp: timestamp, cost: cost, currency: currency)
        
        let json: [String: Any] = [
            "id": item.id.uuidString,
            "title": item.title,
            "timestamp": item.timestamp.ISO8601Format(),
            "cost": item.cost,
            "currency": item.currency.rawValue
        ]
        
        return (item, json)
    }
}
