//
//  SharedTestHelpers.swift
//  FeedTests
//
//  Created by m00nbek Melikulov on 1/5/23.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 1)
}

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    let json = ["items": items]
    return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: URL(string: "any-url.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
