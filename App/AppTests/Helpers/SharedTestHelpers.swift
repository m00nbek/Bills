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
