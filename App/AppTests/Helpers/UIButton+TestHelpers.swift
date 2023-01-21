//
//  UIButton+TestHelpers.swift
//  AppTests
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
