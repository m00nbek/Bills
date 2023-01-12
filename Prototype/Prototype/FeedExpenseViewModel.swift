//
//  FeedExpenseViewModel.swift
//  Prototype
//
//  Created by m00nbek Melikulov on 1/11/23.
//

import Foundation

extension FeedExpenseViewModel {
    static var prototypedFeed: [FeedExpenseViewModel] {
        [
            FeedExpenseViewModel(title: "Apple Watch series 4", timestamp: Date(timeIntervalSince1970: 1673507587), cost: 450),
            FeedExpenseViewModel(title: "apple", timestamp: Date(timeIntervalSince1970: 1673410192), cost: 1),
            FeedExpenseViewModel(title: "kawasaki ninja 400", timestamp: Date(timeIntervalSince1970: 1673316768), cost: 5600),
            FeedExpenseViewModel(title: "Zero Two sticker pack", timestamp: Date(timeIntervalSince1970: 1673316768), cost: 6),
            FeedExpenseViewModel(title: "cat with OCD", timestamp: Date(timeIntervalSince1970: 1673230368), cost: 455),
            FeedExpenseViewModel(title: "keychron k6", timestamp: Date(timeIntervalSince1970: 1673230368), cost: 100),
            FeedExpenseViewModel(title: "ZY EDC - MT-01", timestamp: Date(timeIntervalSince1970: 1673143968), cost: 20),
            FeedExpenseViewModel(title: "Discord nitro for 1 year", timestamp: Date(timeIntervalSince1970: 1673143968), cost: 99.99)
        ]
    }
}
