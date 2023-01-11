//
//  FeedViewController.swift
//  Prototype
//
//  Created by m00nbek Melikulov on 1/11/23.
//

import UIKit

struct FeedExpenseViewModel {
    let title: String
    let timestamp: String
    let cost: Float
}

final class FeedViewController: UITableViewController {
    private var feed = [FeedExpenseViewModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
        tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: false)
    }
    
    @IBAction func refresh() {
        refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.feed.isEmpty {
                self.feed = FeedExpenseViewModel.prototypedFeed
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedExpenseCell") as! FeedExpenseCell
        let model = feed[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

extension FeedExpenseCell {
    func configure(with model: FeedExpenseViewModel) {
        title.text = model.title
        cost.text = "-$\(model.cost)"
        date.text = model.timestamp
        
        fadeIn()
    }
}
