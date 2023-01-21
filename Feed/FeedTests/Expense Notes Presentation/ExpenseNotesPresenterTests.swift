//
//  ExpenseNotesPresenterTests.swift
//  FeedTests
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import XCTest
import Feed

class ExpenseNotesPresenterTests: XCTestCase {
    func test_title_isLocalized() {
        XCTAssertEqual(ExpenseNotesPresenter.title, localized("EXPENSE_NOTES_VIEW_TITLE"))
    }
    
    // MARK: - Helpers
    
    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "ExpenseNotes"
        let bundle = Bundle(for: ExpenseNotesPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
