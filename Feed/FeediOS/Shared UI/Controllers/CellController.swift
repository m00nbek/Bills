//
//  CellController.swift
//  FeediOS
//
//  Created by m00nbek Melikulov on 1/21/23.
//

import UIKit

public struct CellController {
    let dataSource: UITableViewDataSource
    let delegate: UITableViewDelegate?
    
    public init(_ dataSource: UITableViewDataSource & UITableViewDelegate) {
        self.dataSource = dataSource
        self.delegate = dataSource
    }
    
    public init(_ dataSource: UITableViewDataSource) {
        self.dataSource = dataSource
        self.delegate = nil
    }
}
