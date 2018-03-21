//
//  ProfileViewController.swift
//  SquadSearch
//
//  Created by swallis on 3/15/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit
import Kingfisher
import MapKit

class ProfileViewController: UIViewController {
    var ad: Ad!
    var game: String!
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var desiredCommitmentLabel: UILabel!
    @IBOutlet var roleLabel: UILabel!
    @IBOutlet var srLabel: UILabel!
    @IBOutlet var steamLabel: UILabel!
    @IBOutlet var skypeLabel: UILabel!
    @IBOutlet var discordLabel: UILabel!
    
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var realNameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserService.fetch(ad.uid) { [unowned self] user in
            if let user = user {
                self.usernameLabel.text = user.username
                if !user.hide_name {
                    self.realNameLabel.text = "  "+user.name
                }
                self.discordLabel.text = user.discord
                if user.discord == nil || user.discord == "" {
                    self.discordLabel.text = "N/A"
                }
                self.skypeLabel.text = user.skype
                if user.skype == nil || user.skype == "" {
                    self.skypeLabel.text = "N/A"
                }
                self.steamLabel.text = user.steam
                if user.steam == nil || user.steam == "" {
                    self.steamLabel.text = "N/A"
                }
            }
        }
        UserService.avatar(of: ad.uid) { [unowned self] url in
            if let url = url {
                self.avatarImageView.kf.setImage(with: url)
            }
        }
        srLabel.text = ad.sr
        roleLabel.text = ad.role
        desiredCommitmentLabel.text = ad.commitment
        FavoritesService.get(for: ad.uid, in: game) { [unowned self] favorited in
            if favorited {
                self.favoriteButton.setImage(UIImage(named: "favoritesSelected"), for: .normal)
            }
        }
        if let latitude = ad.latitude,
            let longitude = ad.longitude {
                var adLocation = CLLocationCoordinate2D()
                adLocation.latitude = latitude
                adLocation.longitude = longitude
                let viewRegion = MKCoordinateRegionMakeWithDistance(adLocation, 10000, 10000)
                mapView.setRegion(viewRegion, animated: true)
        } else {
            mapView.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func favoriteButtonPressed(_ sender: Any) {
        FavoritesService.get(for: ad.uid, in: game) { [unowned self] favorited in
            FavoritesService.set(self.ad.uid, in: self.game, to: !favorited) { [unowned self] nowFavorited in
                if nowFavorited {
                    self.favoriteButton.setImage(UIImage(named: "favoritesSelected"), for: .normal)
                } else {
                    self.favoriteButton.setImage(UIImage(named: "favorites"), for: .normal)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
