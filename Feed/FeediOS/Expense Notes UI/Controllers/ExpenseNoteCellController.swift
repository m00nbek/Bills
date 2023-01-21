//
//  ExpenseNoteCellController.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import UIKit
import Feed

public class ExpenseNoteCellController: NSObject, CellController {
    private let model: ExpenseNoteViewModel
    
    public init(model: ExpenseNoteViewModel) {
        self.model = model
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExpenseNoteCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = model.message
        cell.dateLabel.text = model.date
        return cell
    }
}
