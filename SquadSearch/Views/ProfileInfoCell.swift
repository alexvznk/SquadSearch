//
//  ProfileInfoCell.swift
//  SquadSearch
//
//  Created by swallis on 3/13/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit

class ProfileInfoCell: UITableViewCell {

    @IBOutlet var role: UILabel!
    @IBOutlet var sr: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var avatar: UIImageView!
    var ad: Ad!
    var game: String!
    weak var controller: UINavigationController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateAd() {
        self.role.text = ad.role
        self.name.text = ad.name
        self.sr.text = ad.sr
        UserService.avatar(of: ad.uid) { [unowned self] url in
            if let url = url {
                self.avatar.kf.setImage(with: url)
            }
        }
    }

    @IBAction func gotoProfile(_ sender: Any) {
        let viewController = UIStoryboard.viewController(for: .search, identifier: "ReusableProfileController") as? ProfileViewController
        if let viewController = viewController {
            viewController.ad = self.ad
            viewController.game = self.game
            self.controller.pushViewController(viewController, animated: true)
        }
    }
}
