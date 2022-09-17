//
//  CheckViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 17.09.2022.
//

import UIKit

class CheckViewController: UIViewController {
    
    private let tablewView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        table.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}
