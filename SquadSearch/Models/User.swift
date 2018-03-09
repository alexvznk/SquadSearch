//
//  User.swift
//  SquadSearch
//
//  Created by swallis on 3/5/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class User: NSObject {
    private static var _current: User?
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: Current user doesn't exist.")
        }
        return currentUser
    }
    class func loggedIn() -> Bool {
        return _current != nil
    }
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        _current = user
    }
    class func logOut(writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            UserDefaults.standard.set(nil, forKey: Constants.UserDefaults.currentUser)
        }
        _current = nil
    }
    
    let uid: String
    let name: String
    var username: String?
    var hide_name: Bool = true
    var discord: String?
    var skype: String?
    var steam: String?
    var latitude: Float?
    var longitude: Float?
    
    init(uid: String, name: String) {
        self.uid = uid
        self.name = name
        
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any?],
            let hide_name = dict[Constants.Database.Users.hide_name] as? Bool
            else { return nil }
        self.uid = snapshot.key
        self.name = (Auth.auth().currentUser?.displayName)!
        self.hide_name = hide_name
        self.username = dict[Constants.Database.Users.username] as? String
        self.discord = dict[Constants.Database.Users.discord_tag] as? String
        self.skype = dict[Constants.Database.Users.skype_tag] as? String
        self.steam = dict[Constants.Database.Users.steam_profile] as? String
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String
            else { return nil }
        self.uid = uid
        self.name = (Auth.auth().currentUser?.displayName)!
        self.username = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String
        self.hide_name = aDecoder.decodeBool(forKey: Constants.UserDefaults.hide_name)
        self.discord = aDecoder.decodeObject(forKey: Constants.UserDefaults.discord_tag) as? String
        self.skype = aDecoder.decodeObject(forKey: Constants.UserDefaults.skype_tag) as? String
        self.steam = aDecoder.decodeObject(forKey: Constants.UserDefaults.steam_profile) as? String
        
        super.init()
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
        aCoder.encode(hide_name, forKey: Constants.UserDefaults.hide_name)
        aCoder.encode(discord, forKey: Constants.UserDefaults.discord_tag)
        aCoder.encode(skype, forKey: Constants.UserDefaults.skype_tag)
        aCoder.encode(steam, forKey: Constants.UserDefaults.steam_profile)
    }
}
