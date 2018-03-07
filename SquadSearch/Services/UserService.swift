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
import FirebaseStorage
import Kingfisher

typealias FIRUser = FirebaseAuth.User

struct UserService {
    static func create(_ firUser: FIRUser, completion: @escaping (User?) -> Void) {
        //Todo: Add stuff to database
        let ref = Database.database().reference().child(Constants.Database.users).child(firUser.uid)
        let defaultInfo: [String : Any?] = [Constants.Database.Users.username : nil,
                                            Constants.Database.Users.hide_name : true,
                                            Constants.Database.Users.discord_tag : nil,
                                            Constants.Database.Users.skype_tag : nil,
                                            Constants.Database.Users.steam_profile : nil]
        ref.setValue(defaultInfo) { (error, ref) in
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
    
    static func update(_ user: User, with: [String : Any], completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child(Constants.Database.users).child(user.uid)
        let newInfo: [String : Any?] = [Constants.Database.Users.username : with[Constants.Database.Users.username] as! String,
                                            Constants.Database.Users.hide_name : with[Constants.Database.Users.hide_name] as! Bool,
                                            Constants.Database.Users.discord_tag : with[Constants.Database.Users.discord_tag] as! String,
                                            Constants.Database.Users.skype_tag : with[Constants.Database.Users.skype_tag] as! String,
                                            Constants.Database.Users.steam_profile : with[Constants.Database.Users.steam_profile] as! String]
        ref.setValue(newInfo) { (error, ref) in
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
    
    static func avatar(of user: User, completion: @escaping (URL?) -> Void) {
        let ref = Database.database().reference().child(Constants.Database.avatars).child(user.uid)
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let dict = snapshot.value as? [String : Any],
                let imageURL = dict[Constants.Database.Avatars.image_url] as? String
            else {
                    return completion(nil)
            }
            let url = URL(string: imageURL)
            return completion(url)
        })
    }
    
    static func changeAvatar(of user: User, to image: UIImage, completion: @escaping (URL?) -> Void) {
        let imageRef = Storage.storage().reference().child(user.uid).child(String(NSDate().timeIntervalSince1970))
        StorageService.uploadImage(image, at: imageRef) { (img) in
            guard let img = img else {
                return completion(nil)
            }
            let ref = Database.database().reference().child(Constants.Database.avatars).child(user.uid)
            ref.setValue([Constants.Database.Avatars.image_url : img.absoluteString]) { (error, ref) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                return completion(img)
            }
        }
    }
}
