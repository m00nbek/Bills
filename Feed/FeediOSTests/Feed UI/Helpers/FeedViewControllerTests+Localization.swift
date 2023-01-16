//
//  FeedViewControllerTests+Localization.swift
//  FeediOSTests
//
//  Created by m00nbek Melikulov on 1/16/23.
//


import Foundation
import XCTest
import FeediOS

extension FeedUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
