//
//  Ad.swift
//  SquadSearch
//
//  Created by swallis on 3/8/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Ad {
    let uid: String
    let sr: String
    let role: String
    let commitment: String
    var name: String
    var longitude: Double?
    var latitude: Double?
    
    init?(_ snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any?],
            let name = dict[Constants.Database.Users.username] as? String,
            let sr = dict[Constants.Database.Ads.skill_rating] as? String,
            let role = dict[Constants.Database.Ads.role] as? String,
            let commitment = dict[Constants.Database.Ads.commitment] as? String else {
                return nil
        }
        self.uid = snapshot.key
        self.name = name
        self.sr = sr
        self.role = role
        self.commitment = commitment
        if let longitude = dict[Constants.Database.Location.longitude] as? Double,
            let latitude = dict[Constants.Database.Location.latitude] as? Double {
                self.longitude = longitude
                self.latitude = latitude
        }
    }
}
