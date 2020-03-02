//
//  LeaderBoardTableViewCell.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 15.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//

import UIKit

class LeaderBoardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageCell.layer.borderWidth = 3
        imageCell.layer.borderColor = UIColor.black.cgColor
        imageCell.layer.cornerRadius = 10
        imageCell.clipsToBounds = true
        imageCell.layer.backgroundColor = UIColor.white.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
