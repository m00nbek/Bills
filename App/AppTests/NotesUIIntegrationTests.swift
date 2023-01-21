//
//  NotesUIIntegrationTests.swift
//  AppTests
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import XCTest
import UIKit
import Combine
import Feed
import FeediOS
import App

class NotesUIIntegrationTests: XCTestCase {
    
    func notesView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, notesTitle)
    }
    
    func test_loadNotesActions_requestNotesFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadNotesCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadNotesCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadNotesCallCount, 2, "Expected another loading request once user initiates a reload")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadNotesCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadingNotesIndicator_isVisibleWhileLoadingNotes() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeNotesLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
        
        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeNoteLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }
    
    func test_loadnotesCompletion_rendersSuccessfullyLoadednotes() {
        let note0 = makeNote(message: "a message")
        let note1 = makeNote(message: "another message")
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [ExpenseNote]())
        
        loader.completeNotesLoading(with: [note0], at: 0)
        assertThat(sut, isRendering: [note0])
        
        sut.simulateUserInitiatedReload()
        loader.completeNotesLoading(with: [note0, note1], at: 1)
        assertThat(sut, isRendering: [note0, note1])
    }
    func test_loadnotesCompletion_rendersSuccessfullyLoadedEmptynotesAfterNonEmptynotes() {
        let note = makeNote()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeNotesLoading(with: [note], at: 0)
        assertThat(sut, isRendering: [note])
        
        sut.simulateUserInitiatedReload()
        loader.completeNotesLoading(with: [], at: 1)
        assertThat(sut, isRendering: [ExpenseNote]())
    }
    
    func test_loadnotesCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let note = makeNote()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeNotesLoading(with: [note], at: 0)
        assertThat(sut, isRendering: [note])
        
        sut.simulateUserInitiatedReload()
        loader.completeNoteLoadingWithError(at: 1)
        assertThat(sut, isRendering: [note])
    }
    
    func test_loadNotesCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeNotesLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadNotesCompletion_rendersErrorMessageOnErrorUntilNextReload() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)
        
        loader.completeNoteLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    func test_tapOnErrorView_hidesErrorMessage() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)
        
        loader.completeNoteLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)
        
        sut.simulateErrorViewTap()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    func test_deinit_cancelsRunningRequest() {
        var cancelCallCount = 0
        
        var sut: ListViewController?
        
        autoreleasepool {
            sut = NotesUIComposer.notesComposedWith(notesLoader: {
                PassthroughSubject<[ExpenseNote], Error>()
                    .handleEvents(receiveCancel: {
                        cancelCallCount += 1
                    }).eraseToAnyPublisher()
            })
            
            sut?.loadViewIfNeeded()
        }
        
        XCTAssertEqual(cancelCallCount, 0)
        
        sut = nil
        
        XCTAssertEqual(cancelCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = NotesUIComposer.notesComposedWith(notesLoader: loader.loadPublisher)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func makeNote(message: String = "any message") -> ExpenseNote {
        return ExpenseNote(id: UUID(), message: message, createdAt: Date())
    }
    
    private func assertThat(_ sut: ListViewController, isRendering notes: [ExpenseNote], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(sut.numberOfRenderedNotes(), notes.count, "notes count", file: file, line: line)
        
        let viewModel = ExpenseNotesPresenter.map(notes)
        
        viewModel.notes.enumerated().forEach { index, note in
            XCTAssertEqual(sut.noteMessage(at: index), note.message, "message at \(index)", file: file, line: line)
            XCTAssertEqual(sut.noteDate(at: index), note.date, "date at \(index)", file: file, line: line)
        }
    }
    
    private class LoaderSpy {
        private var requests = [PassthroughSubject<[ExpenseNote], Error>]()
        
        var loadNotesCallCount: Int {
            return requests.count
        }
        
        func loadPublisher() -> AnyPublisher<[ExpenseNote], Error> {
            let publisher = PassthroughSubject<[ExpenseNote], Error>()
            requests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeNotesLoading(with notes: [ExpenseNote] = [], at index: Int = 0) {
            requests[index].send(notes)
        }
        
        func completeNoteLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            requests[index].send(completion: .failure(error))
        }
    }
}
