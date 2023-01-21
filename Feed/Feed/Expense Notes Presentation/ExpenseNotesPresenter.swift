//
//  ExpenseNotesPresenter.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import Foundation

public final class ExpenseNotesPresenter {
    public static var title: String {
        NSLocalizedString("EXPENSE_NOTES_VIEW_TITLE",
                          tableName: "ExpenseNotes",
                          bundle: Bundle(for: Self.self),
                          comment: "Title for the expense notes view")
    }
}
