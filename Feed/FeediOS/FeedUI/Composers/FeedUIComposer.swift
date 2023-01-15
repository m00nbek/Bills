//
//  FeedUIComposer.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/15/23.
//

import Foundation
import Feed

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(loader: FeedLoader) -> FeedViewController {
        let refreshController = FeedRefreshViewController(feedLoader: loader)
        let feedController = FeedViewController(refreshController: refreshController)
        refreshController.onRefresh = { [weak feedController] feed in
            feedController?.tableModel = feed.map { model in
                FeedExpenseCellController(model: model)
            }
        }
        return feedController
    }
}
