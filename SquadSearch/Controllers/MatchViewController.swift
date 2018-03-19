//
//  MatchViewController.swift
//  SquadSearch
//
//  Created by Alex on 3/13/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {
    
    var gamesData = [Games]()
    var currentGame = Int()
    var time = String()
    
    @IBOutlet weak var teamSecondLogo: UIImageView!
    @IBOutlet weak var teamFirstLogo: UIImageView!
    @IBOutlet weak var gameNameLbl: UILabel!
    @IBOutlet weak var leagueImg: UIImageView!
    @IBOutlet weak var leagueNameLbl: UILabel!
    @IBOutlet weak var teamFirstNameLbl: UILabel!
    @IBOutlet weak var teamSecondNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = gamesData[currentGame].name
        gameNameLbl.text = gamesData[currentGame].videogame.name
        leagueNameLbl.text = gamesData[currentGame].league.name
        
        if let imageUrl = gamesData[currentGame].league.image_url {
            let url = URL(string: imageUrl)!
            leagueImg.kf.setImage(with: url)
        }
        
        if gamesData[currentGame].opponents.count == 2 {
            teamFirstNameLbl.text = gamesData[currentGame].opponents[0].opponent.name
            teamSecondNameLbl.text = gamesData[currentGame].opponents[1].opponent.name
            if let imageUrl1 = gamesData[currentGame].opponents[0].opponent.image_url {
                let url = URL(string: imageUrl1)!
                teamFirstLogo.kf.setImage(with: url)
            }
            if let imageUrl2 = gamesData[currentGame].opponents[1].opponent.image_url {
                let url = URL(string: imageUrl2)!
                teamSecondLogo.kf.setImage(with: url)
            }
        } else {
            teamFirstNameLbl.text = "Not available"
            teamSecondNameLbl.text = "Not available"
        }
        
        timeLbl.text = time
        
    }
    
}

