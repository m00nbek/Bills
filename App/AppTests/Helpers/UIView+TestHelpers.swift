//
//  UIView+TestHelpers.swift
//  AppTests
//
//  Created by m00nbek Melikulov on 1/19/23.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
