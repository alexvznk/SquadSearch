//
//  FavoritesService.swift
//  SquadSearch
//
//  Created by swallis on 3/15/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FavoritesService {
    static func set(_ uid: String, in game: String, to value: Bool, completion: @escaping (Bool) -> Void) {
        guard User.loggedIn() else {
            return
        }
        let ref = Database.database().reference().child(Constants.Database.favorites).child(User.current.uid).child(game).child(uid)
        ref.setValue(value) { (error, snapshot) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(value)
            }
            ref.observeSingleEvent(of: .value, with: { snapshot in
                return completion(snapshot.value as! Bool)
            })
        }
    }
    
    static func get(for uid: String, in game: String, completion: @escaping (Bool) -> Void) {
        guard User.loggedIn() else {
            return
        }
        let ref = Database.database().reference().child(Constants.Database.favorites).child(User.current.uid).child(game).child(uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let val = snapshot.value as? Bool {
                return completion(val)
            }
            return completion(false)
        })
    }
    
    static func all(completion: @escaping ([String : [String : Bool]]) -> Void) {
        guard User.loggedIn() else {
            return completion([:])
        }
        let ref = Database.database().reference().child(Constants.Database.favorites).child(User.current.uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let gameDict = snapshot.value as? [String : [String : Bool]] else {
                return completion([:])
            }
            var favorites: [String : [String : Bool]] = [:]
            for game in gameDict.keys {
                favorites[game] = gameDict[game]!.filter({ uid in
                    return uid.value
                })
            }
            print(favorites)
            return completion(favorites)
        })
    }
}
