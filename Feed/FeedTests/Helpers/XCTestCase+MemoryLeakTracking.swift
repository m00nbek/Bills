//
//  XCTestCase+MemoryLeakTracking.swift
//  FeedTests
//
//  Created by m00nbek Melikulov on 11/30/22.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance shoulda been deallocated. Potential memory leak", file: file, line: line)
        }
    }
}
