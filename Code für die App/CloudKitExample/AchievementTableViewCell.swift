//
//  AchievementTableViewCell.swift
//  CloudKitExample
//
//  Created by Marko Dehmel-Dethloff on 22.08.19.
//  Copyright © 2019 Marko Dehmel-Dethloff. All rights reserved.
//

class AchievementTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var rewardLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
