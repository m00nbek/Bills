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
    
    let localStoreURL = NSPersistentContainer
             .defaultDirectoryURL()
             .appendingPathComponent("feed-store.sqlite")
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        configureWindow()
    }
    
    func configureWindow() {
        let remoteURL = URL(string: "https://api.jsonbin.io/v3/b/63c6b96a01a72b59f24d25b7?meta=false")!
        
        let remoteClient = makeRemoteClient()
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
        
        let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        
        window?.rootViewController = UINavigationController(
            rootViewController: FeedUIComposer.feedComposedWith(
                feedLoader: FeedLoaderWithFallbackComposite(
                    primary: FeedLoaderCacheDecorator(
                        decoratee: remoteFeedLoader,
                        cache: localFeedLoader),
                    fallback: localFeedLoader))
        )
        window?.makeKeyAndVisible()
    }
    
    func makeRemoteClient() -> HTTPClient {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }
}
