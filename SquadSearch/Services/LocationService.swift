//
//  LocationService.swift
//  SquadSearch
//
//  Created by swallis on 3/8/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct LocationService {
    static func updateLocation(_ user: User, with: [String : Double]) {
        let ref = Database.database().reference().child(Constants.Database.location).child(user.uid)
        ref.setValue(with)
    }
    
    static func getLocation(_ uid: String, completion: @escaping ([String : Double]?) -> Void) {
        let ref = Database.database().reference().child(Constants.Database.location).child(uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let locationDict = snapshot.value as? [String : Double] {
                return completion(locationDict)
            }
            return completion(nil)
        })
    }
}
