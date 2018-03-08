//
//  GameSelectionCell.swift
//  SquadSearch
//
//  Created by swallis on 3/8/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit

class GameSelectionCell: UITableViewCell {

    @IBOutlet var gameButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func gameButtonPressed(_ sender: Any) {
        let initialViewController = UIStoryboard.initialViewController(for: .profile) as! ReusableGameAdController
        initialViewController.game = gameButton.title(for: .normal)
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }

}
