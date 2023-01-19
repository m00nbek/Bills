//
//  SceneDelegate.swift
//  App
//
//  Created by m00nbek Melikulov on 1/17/23.
//

import UIKit
import Feed
import FeediOS
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: FeedStore = {
        try! CoreDataFeedStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("feed-store.sqlite"))
    }()
    
    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()
    
    convenience init(httpClient: HTTPClient, store: FeedStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        configureWindow()
    }
    
    func configureWindow() {
        let remoteURL = URL(string: "https://api.jsonbin.io/v3/b/63c6b96a01a72b59f24d25b7?meta=false")!
        
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: httpClient)
        
        window?.rootViewController = UINavigationController(
            rootViewController: FeedUIComposer.feedComposedWith(
                feedLoader: FeedLoaderWithFallbackComposite(
                    primary: FeedLoaderCacheDecorator(
                        decoratee: remoteFeedLoader,
                        cache: localFeedLoader),
                    fallback: localFeedLoader)))
        window!.makeKeyAndVisible()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        localFeedLoader.validateCache { _ in }
    }
}
