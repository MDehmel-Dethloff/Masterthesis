//
//  HomeTableViewCell.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 15.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//

import UIKit

// Sets the properties for the Cells used in the upper TableView in HomeViewController.swift
class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
