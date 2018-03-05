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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //If the user isn't logged in, send them to log in before they can use this part of the app
        if !User.loggedIn() {
            let initialViewController = UIStoryboard.initialViewController(for: .login)
            if let window = view.window {
                window.rootViewController = initialViewController
                window.makeKeyAndVisible()
            }
            return
        }
        
        print(User.current.uid)
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
