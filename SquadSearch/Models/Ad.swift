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
    let sr: String
    let role: String
    let commitment: String
    
    init?(_ snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any?],
            let sr = dict[Constants.Database.Ads.skill_rating] as? String,
            let role = dict[Constants.Database.Ads.role] as? String,
            let commitment = dict[Constants.Database.Ads.commitment] as? String else {
                return nil
        }
        self.sr = sr
        self.role = role
        self.commitment = commitment
    }
}
