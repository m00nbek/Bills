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

class NotesUIIntegrationTests: FeedUIIntegrationTests {
    
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
        
        loader.completeNoteLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
        
        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeNoteLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }
    
    override func test_loadFeedCompletion_renderSuccessfullyLoadedFeed() {
        let expense0 = makeExpense(title: "a title", timestamp: Date(), cost: 47)
        let expense1 = makeExpense(title: "another title", timestamp: Date(), cost: 37)
        let expense2 = makeExpense(title: "ttitle with double Ts", timestamp: Date(), cost: 27)
        let expense3 = makeExpense(title: "title without an article", timestamp: Date(), cost: 17)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeNoteLoading(with: [expense0], at: 0)
        assertThat(sut, isRendering: [expense0])
        
        sut.simulateUserInitiatedReload()
        loader.completeNoteLoading(with: [expense0, expense1, expense2, expense3], at: 1)
        assertThat(sut, isRendering: [expense0, expense1, expense2, expense3])
    }
    
    override func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let expense0 = makeExpense(title: "title", timestamp: Date(), cost: 12)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeNoteLoading(with: [expense0], at: 0)
        assertThat(sut, isRendering: [expense0])
        
        sut.simulateUserInitiatedReload()
        loader.completeNoteLoadingWithError(at: 1)
        assertThat(sut, isRendering: [expense0])
    }
    
    override func test_loadFeedCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeNoteLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    override func test_loadFeedCompletion_rendersErrorMessageOnErrorUntilNextReload()  {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)
        
        loader.completeNoteLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    override func test_tapOnErrorView_hidesErrorMessage() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)
        
        loader.completeNoteLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)
        
        sut.simulateErrorViewTap()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: ListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = NotesUIComposer.notesComposedWith(notesLoader: loader.loadPublisher)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func makeExpense(title: String, timestamp: Date, cost: Float) -> FeedExpense {
        return FeedExpense(id: UUID(), title: title, timestamp: timestamp, cost: cost, currency: .USD)
    }
    
    private class LoaderSpy {
        private var requests = [PassthroughSubject<[FeedExpense], Error>]()
        
        var loadNotesCallCount: Int {
            return requests.count
        }
        
        func loadPublisher() -> AnyPublisher<[FeedExpense], Error> {
            let publisher = PassthroughSubject<[FeedExpense], Error>()
            requests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeNoteLoading(with feed: [FeedExpense] = [], at index: Int = 0) {
            requests[index].send(feed)
        }
        
        func completeNoteLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            requests[index].send(completion: .failure(error))
        }
    }
}
