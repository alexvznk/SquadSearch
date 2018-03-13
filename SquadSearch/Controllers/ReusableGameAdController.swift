//
//  ReusableGameAdController.swift
//  SquadSearch
//
//  Created by swallis on 3/8/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit
import CoreLocation

class ReusableGameAdController: UIViewController {
    var game: String!
    var locationManager: CLLocationManager?
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var desiredCommitmentField: UITextField!
    @IBOutlet var roleField: UITextField!
    @IBOutlet var srField: UITextField!
    @IBOutlet var gameTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.roleField.delegate = self
        self.srField.delegate = self
        self.desiredCommitmentField.delegate = self
    }
    
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
        if (User.current.username == nil || User.current.username == "") && User.current.hide_name {
            let alertController = UIAlertController(title: "No name available", message: "You must either provide a username in your profile, or allow your real name to be shown, in order to post an ad.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
            return
        }
        if User.current.username == "" {
            User.current.username = nil
        }
        if locationManager == nil && CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager.init()
        }
        if let locationManager = locationManager {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.distanceFilter = 500
            locationManager.requestLocation()
            saveButton.setTitle("Saving...", for: .normal)
        } else {
            let data : [String : Any?] = [Constants.Database.Users.username : (User.current.username ?? User.current.name),
                                          Constants.Database.Ads.skill_rating : srField.text,
                                          Constants.Database.Ads.role : roleField.text,
                                          Constants.Database.Ads.commitment : desiredCommitmentField.text]
            saveButton.setTitle("Saving...", for: .normal)
            AdService.postAd(for: User.current, in: game, contents: data) { [unowned self] in
                self.saveButton.setTitle("Save Changes", for: .normal)
            }
        }
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

extension ReusableGameAdController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if let loc = location {
            let data : [String : Any?] = [Constants.Database.Users.username : (User.current.username ?? User.current.name),
                                          Constants.Database.Ads.skill_rating : srField.text,
                                          Constants.Database.Ads.role : roleField.text,
                                          Constants.Database.Ads.commitment : desiredCommitmentField.text,
                                          Constants.Database.Location.latitude : loc.coordinate.latitude as Double,
                                          Constants.Database.Location.longitude : loc.coordinate.longitude as Double]
            AdService.postAd(for: User.current, in: game, contents: data) { [unowned self] in
                self.saveButton.setTitle("Save Changes", for: .normal)
            }
            LocationService.updateLocation(User.current, with: [Constants.Database.Location.latitude : loc.coordinate.latitude as Double,
                                                                Constants.Database.Location.longitude : loc.coordinate.longitude as Double])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        saveButton.setTitle("Save Failed", for: .normal)
    }
}

extension ReusableGameAdController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
