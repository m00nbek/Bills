//
//  ExpenseNotesPresenter.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import Foundation

public struct ExpenseNotesViewModel {
    public let notes: [ExpenseNoteViewModel]
}

public struct ExpenseNoteViewModel: Equatable {
    public let message: String
    public let date: String

    public init(message: String, date: String) {
        self.message = message
        self.date = date
    }
}

public final class ExpenseNotesPresenter {
    public static var title: String {
        NSLocalizedString("EXPENSE_NOTES_VIEW_TITLE",
                          tableName: "ExpenseNotes",
                          bundle: Bundle(for: Self.self),
                          comment: "Title for the expense notes view")
    }
    
    public static func map(
        _ notes: [ExpenseNote],
        currentDate: Date = Date(),
        calender: Calendar = .current,
        locale: Locale = .current
    ) -> ExpenseNotesViewModel {
        let formatter = RelativeDateTimeFormatter()
        formatter.calendar = calender
        formatter.locale = locale

        return ExpenseNotesViewModel(notes: notes.map { note in
            ExpenseNoteViewModel(
                message: note.message,
                date: formatter.localizedString(for: note.createdAt, relativeTo: currentDate))
        })
    }
}
