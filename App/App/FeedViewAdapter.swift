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
    private let currentFeed: [FeedExpense: CellController]
    
    private typealias LoadMorePresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedExpense>, FeedViewAdapter>
    
    init(currentFeed: [FeedExpense: CellController] = [:], controller: ListViewController, selection: @escaping (FeedExpense) -> Void) {
        self.currentFeed = currentFeed
        self.controller = controller
        self.selection = selection
    }
    
    func display(_ viewModel: Paginated<FeedExpense>) {
        guard let controller = controller else { return }

        var currentFeed = self.currentFeed
        
        let feed: [CellController] = viewModel.items.map { model in
            if let controller = currentFeed[model] {
                return controller
            }
            
            let view = FeedExpenseCellController(
                viewModel: FeedExpenseViewModel(model: model),
                selection: { [selection] in
                    selection(model)
                })
            
            let controller = CellController(id: model, view)
            currentFeed[model] = controller
            return controller
        }
        
        guard let loadMorePublisher = viewModel.loadMorePublisher else {
            controller.display(feed)
            return
        }
        
        let loadMoreAdapter = LoadMorePresentationAdapter(loader: loadMorePublisher)
        let loadMore = LoadMoreCellController(callback: loadMoreAdapter.loadResource)
        
        loadMoreAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                currentFeed: currentFeed,
                controller: controller,
                selection: selection
            ),
            loadingView: WeakRefVirtualProxy(loadMore),
            errorView: WeakRefVirtualProxy(loadMore)
        )
        
        
        let loadMoreSection = [CellController(id: UUID(), loadMore)]
        
        controller.display(feed, loadMoreSection)
    }
}
