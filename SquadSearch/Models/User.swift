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
    
    init(uid: String, name: String) {
        self.uid = uid
        self.name = name
        
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let _ = snapshot.value as? [String : Any]
            else { return nil }
        self.uid = snapshot.key
        self.name = (Auth.auth().currentUser?.displayName)!
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String
            else { return nil }
        self.uid = uid
        self.name = (Auth.auth().currentUser?.displayName)!
        
        super.init()
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
    }
}
