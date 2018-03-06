//
//  UserService.swift
//  SquadSearch
//
//  Created by swallis on 3/5/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

struct UserService {
    static func create(_ firUser: FIRUser, completion: @escaping (User?) -> Void) {
        //Todo: Add stuff to database
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(["registered" : true]) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                return completion(user)
            })
        }
    }
    
    static func avatar(_ firUser: FIRUser, completion: @escaping (UIImage?) -> Void) {
        let ref = Database.database().reference().child("avatars").child(firUser.uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String : Any],
                let imageURL = dict["image_url"] as? String,
                let imageHeight = dict["image_height"] as? CGFloat
            else {
                    return completion(nil)
            }
            //Todo
            return completion(nil)
        })
    }
}
