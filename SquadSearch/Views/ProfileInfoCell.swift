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

}
