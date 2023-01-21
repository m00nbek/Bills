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
    private weak var controller: ListViewController?
    
    init(controller: ListViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let view = FeedExpenseCellController(viewModel: FeedExpenseViewModel(model: model))
            
            return CellController(id: model, view)
        })
    }
}
