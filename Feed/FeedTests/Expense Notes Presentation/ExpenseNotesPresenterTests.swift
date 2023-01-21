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
    
    func test_map_createsViewModels() {
        let now = Date()
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        
        let notes = [
            ExpenseNote(
                id: UUID(),
                message: "a message",
                createdAt: now.adding(minutes: -5, calendar: calendar)),
            ExpenseNote(
                id: UUID(),
                message: "another message",
                createdAt: now.adding(days: -1, calendar: calendar))
        ]

        let viewModel = ExpenseNotesPresenter.map(
            notes,
            currentDate: now,
            calender: calendar,
            locale: locale
        )

        XCTAssertEqual(viewModel.notes, [
            ExpenseNoteViewModel(
                message: "a message",
                date: "5 minutes ago"
            ),
            ExpenseNoteViewModel(
                message: "another message",
                date: "1 day ago"
            )
        ])
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
