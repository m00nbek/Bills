//
//  NotesUIComposer.swift
//  App
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import UIKit
import Feed
import FeediOS
import Combine

public final class NotesUIComposer {
    private init() {}
    
    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<[FeedExpense], FeedViewAdapter>
    
    public static func notesComposedWith(
        notesLoader: @escaping () -> AnyPublisher<[FeedExpense], Error>
    ) -> ListViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: notesLoader)
        
        let feedController = makeFeedViewController(title: ExpenseNotesPresenter.title)
        feedController.onRefresh = presentationAdapter.loadResource
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(controller: feedController),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: FeedPresenter.map)
        
        return feedController
    }
    
    private static func makeFeedViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! ListViewController
        feedController.title = title
        return feedController
    }
}
