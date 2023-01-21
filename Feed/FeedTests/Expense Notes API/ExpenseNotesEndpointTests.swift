//
//  ExpenseNotesEndpointTests.swift
//  FeedTests
//
//  Created by m00nbek Melikulov on 1/21/23.
//


import XCTest
import Feed

class ExpenseNotesEndpointTests: XCTestCase {
    
    func test_expenseNotes_endpointURL() {
        let expenseID = UUID(uuidString: "2239CBA2-CB35-4392-ADC0-24A37D38E010")!
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = ExpenseNotesEndpoint.get(expenseID).url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/v1/expense/2239CBA2-CB35-4392-ADC0-24A37D38E010/notes")!
        
        XCTAssertEqual(received, expected)
    }
}
