//
//  FeedExpenseCell.swift
//  Prototype
//
//  Created by m00nbek Melikulov on 1/11/23.
//

import UIKit

final class FeedExpenseCell: UITableViewCell {
    @IBOutlet private(set) var title: UILabel!
    @IBOutlet private(set) var cost: UILabel!
    @IBOutlet private(set) var date: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentView.alpha = 0
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
            self.contentView.alpha = 1
        })
    }
}

