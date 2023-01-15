//
//  FeedViewController.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/12/23.
//

import UIKit
import Feed

final public class FeedViewController: UITableViewController {
    private var refreshController: FeedRefreshViewController?
    var tableModel = [FeedExpenseCellController]() {
        didSet { tableView.reloadData() }
    }
    
    convenience init(refreshController: FeedRefreshViewController) {
        self.init()
        self.refreshController = refreshController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(forRowAt: indexPath).view()
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedExpenseCellController {
        return tableModel[indexPath.row]
    }
}
