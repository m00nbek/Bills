//
//  FeedExpenseCell+Helpers.swift
//  FeediOSTests
//
//  Created by m00nbek Melikulov on 1/15/23.
//

import UIKit
import FeediOS

extension FeedExpenseCell {
    var titleText: String? {
        expenseTitleLabel.text
    }
    
    var costTextAsFloat: Float? {
        if let text = costLabel.text {
            return Float(text)
        }
        
        return nil
    }
    
    var dateText: String? {
        dateLabel.text
    }
}
