//
//  ExpenseNoteCellController.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import UIKit
import Feed

public class ExpenseNoteCellController: CellController {
    private let model: ExpenseNoteViewModel
    
    public init(model: ExpenseNoteViewModel) {
        self.model = model
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: ExpenseNoteCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = model.message
        cell.dateLabel.text = model.date
        return cell
    }
}
