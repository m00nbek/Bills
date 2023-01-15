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
        let feedViewModel = FeedViewModel(feedLoader: loader)
        let refreshController = FeedRefreshViewController(viewModel: feedViewModel)
        let feedController = FeedViewController(refreshController: refreshController)
        feedViewModel.onFeedLoad = adaptFeedToCellControllers(forwardingTo: feedController)
        return feedController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController) -> ([FeedExpense]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                FeedExpenseCellController(model: model)
            }
        }
    }
}
