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
    
    private typealias NotesPresentationAdapter = LoadResourcePresentationAdapter<[ExpenseNote], NotesViewAdapter>
    
    public static func notesComposedWith(
        notesLoader: @escaping () -> AnyPublisher<[ExpenseNote], Error>
    ) -> ListViewController {
        let presentationAdapter = NotesPresentationAdapter(loader: notesLoader)
        
        let notesController = makeNotesViewController(title: ExpenseNotesPresenter.title)
        notesController.onRefresh = presentationAdapter.loadResource
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: NotesViewAdapter(controller: notesController),
            loadingView: WeakRefVirtualProxy(notesController),
            errorView: WeakRefVirtualProxy(notesController),
            mapper: { ExpenseNotesPresenter.map($0) })
        
        return notesController
    }
    
    private static func makeNotesViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ExpenseNotes", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.title = title
        return controller
    }
}

final class NotesViewAdapter: ResourceView {
    private weak var controller: ListViewController?

    init(controller: ListViewController) {
        self.controller = controller
    }

    func display(_ viewModel: ExpenseNotesViewModel) {
        controller?.display(viewModel.notes.map { viewModel in
            CellController(id: viewModel, ExpenseNoteCellController(model: viewModel))
        })
    }
}
