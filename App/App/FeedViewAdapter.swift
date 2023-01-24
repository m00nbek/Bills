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
    private typealias LoadMorePresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedExpense>, FeedViewAdapter>
    
    init(controller: ListViewController, selection: @escaping (FeedExpense) -> Void) {
        self.controller = controller
        self.selection = selection
    }
    
    func display(_ viewModel: Paginated<FeedExpense>) {
        let feed: [CellController] = viewModel.items.map { model in
            let view = FeedExpenseCellController(
                viewModel: FeedExpenseViewModel(model: model),
                selection: { [selection] in
                    selection(model)
                })
            
            return CellController(id: model, view)
        }
        
        guard let loadMorePublisher = viewModel.loadMorePublisher else {
            controller?.display(feed)
            return
        }
        
        let loadMoreAdapter = LoadMorePresentationAdapter(loader: loadMorePublisher)
        let loadMore = LoadMoreCellController(callback: loadMoreAdapter.loadResource)
        
        loadMoreAdapter.presenter = LoadResourcePresenter(
            resourceView: self,
            loadingView: WeakRefVirtualProxy(loadMore),
            errorView: WeakRefVirtualProxy(loadMore)
        )
        
        
        let loadMoreSection = [CellController(id: UUID(), loadMore)]
        
        controller?.display(feed, loadMoreSection)
    }
}
