//
//  FeedViewController.swift
//  Prototype
//
//  Created by m00nbek Melikulov on 1/11/23.
//

import UIKit

final class FeedViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "FeedExpenseCell")!
    }
}