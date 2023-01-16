//
//  UIRefreshControl+Helpers.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/16/23.
//


import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
