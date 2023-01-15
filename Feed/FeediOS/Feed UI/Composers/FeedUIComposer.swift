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
    
    public static func feedComposedWith(feedLoader: FeedLoader) -> FeedViewController {
        let presenter = FeedPresenter()
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: feedLoader, presenter: presenter)
        let refreshController = FeedRefreshViewController(loadFeed: presentationAdapter.loadFeed)
        let feedController = FeedViewController(refreshController: refreshController)
        presenter.loadingView = WeakRefVirtualProxy(refreshController)
        presenter.feedView = FeedViewAdapter(controller: feedController)
        return feedController
    }
}

private final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}

private final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    
    init(controller: FeedViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            FeedExpenseCellController(viewModel: FeedExpenseViewModel(model: model))
        }
    }
}

private final class FeedLoaderPresentationAdapter {
    private let feedLoader: FeedLoader
    private let presenter: FeedPresenter

    init(feedLoader: FeedLoader, presenter: FeedPresenter) {
        self.feedLoader = feedLoader
        self.presenter = presenter
    }

    func loadFeed() {
        presenter.didStartLoadingFeed()

        feedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter.didFinishLoadingFeed(with: feed)

            case let .failure(error):
                self?.presenter.didFinishLoadingFeed(with: error)
            }
        }
    }
}
