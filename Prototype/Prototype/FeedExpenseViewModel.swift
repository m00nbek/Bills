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
            FeedExpenseViewModel(title: "watch", timestamp: "Today", cost: 450, currency: "USD"),
            FeedExpenseViewModel(title: "apple", timestamp: "Today", cost: 3400, currency: "UZS"),
            FeedExpenseViewModel(title: "kawasaki ninja 400", timestamp: "Yesterday", cost: 5600, currency: "USD"),
            FeedExpenseViewModel(title: "Zero Two sticker pack", timestamp: "2 days ago", cost: 6, currency: "USD"),
            FeedExpenseViewModel(title: "cat with OCD", timestamp: "3 days ago", cost: 455, currency: "USD"),
            FeedExpenseViewModel(title: "keychron k6", timestamp: "Last week", cost: 100, currency: "USD"),
            FeedExpenseViewModel(title: "ZY EDC - MT-01", timestamp: "Last week", cost: 20, currency: "USD"),
            FeedExpenseViewModel(title: "Discord nitro for 1 year", timestamp: "3 weeks ago", cost: 99.99, currency: "USD")
        ]
    }
}
