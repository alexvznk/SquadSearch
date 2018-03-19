//
//  MatchCell.swift
//  SquadSearch
//
//  Created by Alex on 3/13/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit

class MatchCell: UITableViewCell {
    
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var teamFirstLogo: UIImageView!
    @IBOutlet weak var teamSecondLogo: UIImageView!
    @IBOutlet weak var gameDate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

