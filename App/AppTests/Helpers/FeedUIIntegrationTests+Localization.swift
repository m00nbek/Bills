//
//  FeedUIIntegrationTests+Localization.swift
//  FeediOSTests
//
//  Created by m00nbek Melikulov on 1/16/23.
//


import Foundation
import XCTest
import Feed

extension FeedUIIntegrationTests {
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }
    
    var loadError: String {
        LoadResourcePresenter<Any, DummyView>.loadError
    }
    
    var feedTitle: String {
        FeedPresenter.title
    }
}
