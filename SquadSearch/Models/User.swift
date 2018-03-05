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

class User: NSObject {
    private static var _current: User?
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: Current user doesn't exist.")
        }
        return currentUser
    }
    static func loggedIn() -> Bool {
        return _current != nil
    }
    static func setCurrent(_ user: User) {
        _current = user
    }
    static func clearCurrent() {
        _current = nil
    }
    
    let uid: String
    
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
    }
    
    init(uid: String, username: String) {
        self.uid = uid
        
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let _ = snapshot.value as? [String : Any]
            else { return nil }
        self.uid = snapshot.key
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String
            else { return nil }
        self.uid = uid
        
        super.init()
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
    }
}
