//
//  HomeController.swift
//  Bills
//
//  Created by m00nbek Melikulov on 10/30/22.
//

import UIKit

class HomeController: UIViewController {
    
    let _view = HomeView()
    
    override func loadView() {
        view = _view
    }
}
