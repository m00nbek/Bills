//
//  FeedLocalizationTests.swift
//  FeediOSTests
//
//  Created by m00nbek Melikulov on 1/16/23.
//


import XCTest
import Feed

final class FeedLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
