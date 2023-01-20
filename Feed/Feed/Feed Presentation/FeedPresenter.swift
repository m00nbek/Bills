//
//  FeedPresenter.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/17/23.
//

import Foundation

public final class FeedPresenter {
    public static var title: String {
        NSLocalizedString("FEED_VIEW_TITLE",
                          tableName: "Feed",
                          bundle: Bundle(for: FeedPresenter.self),
                          comment: "Title for the feed view")
    }
    
    public static func map(_ feed: [FeedExpense]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }
}

