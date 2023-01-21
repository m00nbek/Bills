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
    private let selection: (FeedExpense) -> Void
    
    init(controller: ListViewController, selection: @escaping (FeedExpense) -> Void) {
        self.controller = controller
        self.selection = selection
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let view = FeedExpenseCellController(
                viewModel: FeedExpenseViewModel(model: model),
                selection: { [selection] in
                    selection(model)
                })
            
            return CellController(id: model, view)
        })
    }
}
