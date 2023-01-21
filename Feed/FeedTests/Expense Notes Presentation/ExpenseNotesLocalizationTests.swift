//
//  ExpenseNotesLocalizationTests.swift
//  FeedTests
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import XCTest
import Feed

final class ExpenseNotesLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ExpenseNotes"
        let bundle = Bundle(for: ExpenseNotesPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
