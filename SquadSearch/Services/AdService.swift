//
//  AdService.swift
//  SquadSearch
//
//  Created by swallis on 3/8/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct AdService {
    static func postAd(for user: User, in game: String, contents: [String : Any?], completion: @escaping () -> Void) {
        let ref = Database.database().reference().child(Constants.Database.ads).child(game).child(user.uid)
        ref.setValue(contents)
        return completion()
    }
    
    static func fetch(for user: User, in game: String, completion: @escaping (Ad?) -> Void) {
        let ref = Database.database().reference().child(Constants.Database.ads).child(game).child(user.uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            return completion(Ad(snapshot))
        })
    }
    
    static func all(for game: String, completion: @escaping ([Ad]) -> Void) {
        let ref = Database.database().reference().child(Constants.Database.ads).child(game)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var ads: [Ad] = []
            let adList = snapshot.children
            while let child = adList.nextObject() as? DataSnapshot {
                if let ad = Ad(child) {
                    ads.append(ad)
                }
            }
            return completion(ads)
        })
    }
}
