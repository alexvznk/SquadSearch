//
//  LoginViewController.swift
//  SquadSearch
//
//  Created by swallis on 3/1/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        //Create the login popup and present it to the user
        guard let authUI = FUIAuth.defaultAuthUI() else { return }
        authUI.delegate = self
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
    @IBAction func returnButtonTapped(_ sender: Any) {
        let initialViewController = UIStoryboard.initialViewController(for: .main)
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
        return
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

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        guard let result = authDataResult else {
            assertionFailure("Could not get authDataResult after signing in")
            return
        }
        let firUser = result.user
        
        let userRef = Database.database().reference().child("users").child(firUser.uid)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = User(snapshot: snapshot) {
                User.setCurrent(user, writeToUserDefaults: true)
            } else {
                UserService.create(firUser) { (user) in
                    guard let user = user else { return }
                    User.setCurrent(user, writeToUserDefaults: true)
                }
            }
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            if let tabController = initialViewController as? UITabBarController {
                tabController.selectedIndex = 1
            }
            self.view.window?.makeKeyAndVisible()
        })
    }
}
