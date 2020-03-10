//
//  TableSizeViewController.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 08.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//

import UIKit

// Sets the size for the upper TableView in HomeViewController.swift
class TableSizeViewController: UITableView {
    
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        
        var temp: CGFloat = CGFloat(LoginViewController.questsForResident!.count * 19)
        if temp == 0 {
            temp = 19
        }
        let height = min(contentSize.height + temp, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
    
    
}
