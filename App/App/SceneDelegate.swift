//
//  SceneDelegate.swift
//  App
//
//  Created by m00nbek Melikulov on 1/17/23.
//

import UIKit
import Feed
import FeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let url = URL(string: "https://api.jsonbin.io/v3/b/63c6b96a01a72b59f24d25b7?meta=false")!
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let feedLoader = RemoteFeedLoader(url: url, client: client)
        let feedViewController = FeedUIComposer.feedComposedWith(feedLoader: feedLoader)
        
        window?.rootViewController = feedViewController
        window?.makeKeyAndVisible()
    }

}

