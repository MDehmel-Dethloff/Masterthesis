//
//  EventTableSizeViewController.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 09.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//

import UIKit

class EventTableSizeViewController: UITableView {
    
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = max(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
    
    
}
