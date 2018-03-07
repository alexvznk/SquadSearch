//
//  MyProfileViewController.swift
//  SquadSearch
//
//  Created by swallis on 3/1/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit
import FirebaseAuth

class MyProfileViewController: UIViewController {

    typealias FIRUser = FirebaseAuth.User
    
    @IBOutlet var avatarButton: UIButton!
    @IBOutlet var realNameLabel: UILabel!
    @IBOutlet var steamField: UITextField!
    @IBOutlet var skypeField: UITextField!
    @IBOutlet var discordField: UITextField!
    @IBOutlet var hideNameSwitch: UISwitch!
    @IBOutlet var usernameField: UITextField!
    
    //Temporary hardcoding
    var gameList: [String] = ["Overwatch"]
    var avatarChanged: Bool = false
    let avatarHelper = SSPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarHelper.completionHandler = { image in
            self.avatarChanged = true
            UserService.changeAvatar(of: User.current, to: image) { url in
                self.avatarButton.kf.setImage(with: url, for: .normal)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        avatarButton.contentHorizontalAlignment = .fill
        avatarButton.contentVerticalAlignment = .fill
        
        //If the user isn't logged in, send them to log in before they can use this part of the app
        if !User.loggedIn() {
            let initialViewController = UIStoryboard.initialViewController(for: .login)
            if let window = view.window {
                window.rootViewController = initialViewController
                window.makeKeyAndVisible()
            }
            return
        }
        
        UserService.avatar(of: User.current) { url in
            if let url = url {
                self.avatarButton.kf.setImage(with: url, for: .normal)
            }
        }
        realNameLabel.text = User.current.name
        hideNameSwitch.isOn = !User.current.hide_name
        usernameField.text = User.current.username
        discordField.text = User.current.discord
        skypeField.text = User.current.skype
        steamField.text = User.current.steam
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            User.logOut()
            let initialViewController = UIStoryboard.initialViewController(for: .login)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
        catch {
            print("Couldn't log out")
        }
    }
    
    @IBAction func avatarButtonPressed(_ sender: Any) {
        // Allow the user to change their avatar and save it on the server
        avatarHelper.presentActionSheet(from: self)
    }
    
    @IBAction func saveChangesButtonPressed(_ sender: Any) {
        let changesDict : [String: Any?] = [Constants.Database.Users.username : usernameField.text,
                                            Constants.Database.Users.hide_name : !hideNameSwitch.isOn,
                                            Constants.Database.Users.discord_tag : discordField.text,
                                            Constants.Database.Users.skype_tag : skypeField.text,
                                            Constants.Database.Users.steam_profile : steamField.text]
        UserService.update(User.current, with: changesDict) { user in
            if let user = user {
                User.setCurrent(user)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
