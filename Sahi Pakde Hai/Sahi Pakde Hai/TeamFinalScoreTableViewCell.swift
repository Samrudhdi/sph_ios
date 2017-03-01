//
//  TeamFinalScoreTableViewCell.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 28/02/17.
//  Copyright © 2017 Patronous Inc. All rights reserved.
//

import UIKit

class TeamFinalScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var team1Score: UILabel!
    
    @IBOutlet weak var team2Score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
