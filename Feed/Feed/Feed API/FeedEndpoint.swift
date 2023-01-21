//
//  FeedEndpoint.swift
//  Feed
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import Foundation

public enum FeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
