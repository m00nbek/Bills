//
//  FeedViewAdapter.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/16/23.
//

import Foundation
import Feed
import FeediOS

final class FeedViewAdapter: ResourceView {
    private weak var controller: FeedViewController?
    
    init(controller: FeedViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            FeedExpenseCellController(viewModel: FeedExpenseViewModel(model: model))
        })
    }
}
