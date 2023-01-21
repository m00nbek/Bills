//
//  FeedCacheTestHelpers.swift
//  FeedTests
//
//  Created by m00nbek Melikulov on 1/5/23.
//

import Foundation
import Feed


func uniqueExpense() -> FeedExpense {
    return FeedExpense(id: UUID(), title: "any", timestamp: Date.now, cost: 0, currency: .USD)
}

func uniqueExpenseFeed() -> (models: [FeedExpense], local: [LocalFeedExpense]) {
    let models = [uniqueExpense(), uniqueExpense()]
    let local = models.map { LocalFeedExpense(id: $0.id,
                                              title: $0.title,
                                              timestamp: $0.timestamp,
                                              cost: $0.cost,
                                              currency: LocalFeedExpense.Currency.init(rawValue: $0.currency.rawValue)!)
    }
    
    return (models, local)
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
}
