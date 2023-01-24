//
//  FeedAcceptanceTests.swift
//  AppTests
//
//  Created by m00nbek Melikulov on 1/19/23.
//

import XCTest
import Feed
import FeediOS
@testable import App

class FeedAcceptanceTests: XCTestCase {
    
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let feed = launch(httpClient: .online(response), store: .empty)
        
        XCTAssertEqual(feed.numberOfRenderedFeedExpenseViews(), 2)
        XCTAssertTrue(feed.canLoadMoreFeed)
        
        feed.simulateLoadMoreFeedAction()
        
        XCTAssertEqual(feed.numberOfRenderedFeedExpenseViews(), 3)
        XCTAssertTrue(feed.canLoadMoreFeed)
        
        feed.simulateLoadMoreFeedAction()
        
        XCTAssertEqual(feed.numberOfRenderedFeedExpenseViews(), 3)
        XCTAssertFalse(feed.canLoadMoreFeed)
    }
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        let sharedStore = InMemoryFeedStore.empty
        let onlineFeed = launch(httpClient: .online(response), store: sharedStore)
        onlineFeed.simulateFeedExpenseViewVisible(at: 0)
        onlineFeed.simulateFeedExpenseViewVisible(at: 1)
        
        onlineFeed.simulateLoadMoreFeedAction()
        onlineFeed.simulateFeedExpenseViewVisible(at: 2)
        
        let offlineFeed = launch(httpClient: .offline, store: sharedStore)
        
        XCTAssertEqual(offlineFeed.numberOfRenderedFeedExpenseViews(), 3)
    }
    
    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() {
        let feed = launch(httpClient: .offline, store: .empty)
        
        XCTAssertEqual(feed.numberOfRenderedFeedExpenseViews(), 0)
    }
    
    func test_onEnteringBackground_deletesExpiredFeedCache() {
        let store = InMemoryFeedStore.withExpiredFeedCache
        
        enterBackground(with: store)
        
        XCTAssertNil(store.feedCache, "Expected to delete expired cache")
    }
    
    func test_onEnteringBackground_keepsNonExpiredFeedCache() {
        let store = InMemoryFeedStore.withNonExpiredFeedCache
        
        enterBackground(with: store)
        
        XCTAssertNotNil(store.feedCache, "Expected to keep non-expired cache")
    }
    
    func test_onFeedExpenseSelection_displaysNotes() {
        let notes = showNotesForFirstExpense()
        
        XCTAssertEqual(notes.numberOfRenderedNotes(), 1)
        XCTAssertEqual(notes.noteMessage(at: 0), makeNoteMessage())
    }
    
    // MARK: - Helpers
    
    private func launch(httpClient: HTTPClientStub = .offline, store: InMemoryFeedStore = .empty) -> ListViewController {
        let sut = SceneDelegate(httpClient: httpClient, store: store)
        sut.window = UIWindow()
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! ListViewController
    }
    
    private func enterBackground(with store: InMemoryFeedStore) {
        let sut = SceneDelegate(httpClient: HTTPClientStub.offline, store: store)
        sut.sceneWillResignActive(UIApplication.shared.connectedScenes.first!)
    }
    
    private func showNotesForFirstExpense() -> ListViewController {
        let feed = launch(httpClient: .online(response), store: .empty)

        feed.simulateTapOnFeedExpense(at: 0)
        RunLoop.current.run(until: Date())

        let nav = feed.navigationController
        return nav?.topViewController as! ListViewController
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.path {
        case "/bills/v1/feed" where url.query?.contains("after_id") == false:
            return makeFirstFeedPageData()

        case "/bills/v1/feed" where url.query?.contains("after_id=A28F5FE3-27A7-44E9-8DF5-53742D0E4A5A") == true:
            return makeSecondFeedPageData()

        case "/bills/v1/feed" where url.query?.contains("after_id=166FCDD7-C9F4-420A-B2D6-CE2EAFA3D82F") == true:
            return makeLastEmptyFeedPageData()

        case "/bills/v1/expense/2AB2AE66-A4B7-4A16-B374-51BBAC8DB086/notes":
            return makeNotesData()

        default:
            return Data()
        }
    }
    
    private func makeFirstFeedPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": "2AB2AE66-A4B7-4A16-B374-51BBAC8DB086", "image": "http://feed.com/image-0"],
            ["id": "A28F5FE3-27A7-44E9-8DF5-53742D0E4A5A", "image": "http://feed.com/image-1"]
        ]])
    }
    
    private func makeSecondFeedPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": "166FCDD7-C9F4-420A-B2D6-CE2EAFA3D82F", "image": "http://feed.com/image-2"],
        ]])
    }
    
    private func makeLastEmptyFeedPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": []])
    }
    
    private func makeNotesData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            [
                "id": UUID().uuidString,
                "message": makeNoteMessage(),
                "created_at": "2020-05-20T11:24:59+0000"
            ],
        ]])
    }

    private func makeNoteMessage() -> String {
        "a message"
    }
}
