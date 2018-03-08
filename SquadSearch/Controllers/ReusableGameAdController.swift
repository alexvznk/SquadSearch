//
//  ReusableGameAdController.swift
//  SquadSearch
//
//  Created by swallis on 3/8/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit

class ReusableGameAdController: UIViewController {
    var game: String!
    
    @IBOutlet var desiredCommitmentField: UITextField!
    @IBOutlet var roleField: UITextField!
    @IBOutlet var srField: UITextField!
    @IBOutlet var gameTitleLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameTitleLabel.text = game
        AdService.fetch(for: User.current, in: game) { [unowned self] ad in
            if let ad = ad {
                self.srField.text = ad.sr
                self.roleField.text = ad.role
                self.desiredCommitmentField.text = ad.commitment
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveChangesPressed(_ sender: Any) {
        let data : [String : Any?] = [Constants.Database.Ads.skill_rating : srField.text,
                                    Constants.Database.Ads.role : roleField.text,
                                    Constants.Database.Ads.commitment : desiredCommitmentField.text]
        AdService.postAd(for: User.current, in: game, contents: data)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let initialViewController = UIStoryboard.initialViewController(for: .main) as! UITabBarController
        initialViewController.selectedIndex = 1
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
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
