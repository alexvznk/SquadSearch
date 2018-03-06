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
    
    //Temporary hardcoding
    var gameList: [String] = ["Overwatch"]
    var avatarChanged: Bool = false
    let avatarHelper = SSPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarHelper.completionHandler = { image in
            self.avatarChanged = true
            self.avatarButton.setImage(image, for: .normal)
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
        
        realNameLabel.text = User.current.name
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
