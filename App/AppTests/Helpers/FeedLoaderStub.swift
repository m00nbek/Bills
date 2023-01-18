//
//  FeedLoaderStub.swift
//  AppTests
//
//  Created by m00nbek Melikulov on 1/18/23.
//

import Feed

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
