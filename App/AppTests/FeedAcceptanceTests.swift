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
    }
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        let sharedStore = InMemoryFeedStore.empty
        let onlineFeed = launch(httpClient: .online(response), store: sharedStore)
        onlineFeed.simulateFeedExpenseViewVisible(at: 0)
        onlineFeed.simulateFeedExpenseViewVisible(at: 1)
        
        let offlineFeed = launch(httpClient: .offline, store: sharedStore)
        
        XCTAssertEqual(offlineFeed.numberOfRenderedFeedExpenseViews(), 2)
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
        switch url.absoluteString {
        case "/feed/v1/feed":
            return (makeFeedData(), response)
        case "/feed/v1/expense/2AB2AE66-A4B7-4A16-B374-51BBAC8DB086/notes":
            return (makeNotesData(), response)
        default:
            return (Data(), response)
        }
    }
    
    private func makeFeedData() -> Data {
        return try! JSONSerialization.data(withJSONObject: [
            "items": [
                [
                    "id": UUID().uuidString,
                    "title": "any title",
                    "timestamp": Date().ISO8601Format(),
                    "cost": 0,
                    "currency": "USD"
                ],
                [
                    "id": UUID().uuidString,
                    "title": "any title",
                    "timestamp": Date().ISO8601Format(),
                    "cost": 0,
                    "currency": "USD"
                ],
            ]
        ])
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
