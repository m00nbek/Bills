//
//  SharedTestHelpers.swift
//  AppTests
//
//  Created by m00nbek Melikulov on 1/18/23.
//

import Feed

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func uniqueFeed() -> [FeedExpense] {
    return [FeedExpense(id: UUID(), title: "any", timestamp: Date(), cost: 0, currency: .USD)]
}

private class DummyView: ResourceView {
    func display(_ viewModel: Any) {}
}

var loadError: String {
    LoadResourcePresenter<Any, DummyView>.loadError
}

var feedTitle: String {
    FeedPresenter.title
}

var notesTitle: String {
    ExpenseNotesPresenter.title
}
