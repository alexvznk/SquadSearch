//
//  Constants.swift
//  SquadSearch
//
//  Created by swallis on 3/5/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import Foundation

struct Constants {
    struct Controllers {
        static let search = "Search"
        static let profile = "Profile"
        static let groups = "Groups"
        static let favorites = "Favorites"
    }
    struct UserDefaults {
        static let currentUser = "currentUser"
        static let uid = "uid"
        static let username = "username"
        static let hide_name = "hide_name"
        static let discord_tag = "discord_tag"
        static let skype_tag = "skype_tag"
        static let steam_profile = "steam_profile"
    }
    struct Database {
        static let users = "users"
        static let avatars = "avatars"
        static let ads = "ads"
        struct Avatars {
            static let image_url = "image_url"
        }
        struct Users {
            static let username = "username"
            static let hide_name = "hide_name"
            static let discord_tag = "discord_tag"
            static let skype_tag = "skype_tag"
            static let steam_profile = "steam_profile"
        }
        struct Ads {
            static let skill_rating = "skill_rating"
            static let role = "role"
            static let commitment = "desired_commitment"
        }
    }
}
