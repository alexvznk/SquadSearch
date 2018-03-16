//
//  SearchController.swift
//  SquadSearch
//
//  Created by swallis on 3/8/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit
import CoreLocation

class SearchController: UIViewController {

    @IBOutlet var gamePicker: UIPickerView!
    var locationManager: CLLocationManager?
    var ads: [Ad]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        if let sender = sender as? UIButton {
            sender.setTitle("Searching...", for: .normal)
        }
        AdService.all(for: Constants.gameList[gamePicker.selectedRow(inComponent: 0)]) { [unowned self] ads in
            self.ads = ads
            if self.locationManager == nil && CLLocationManager.locationServicesEnabled() {
                self.locationManager = CLLocationManager.init()
            }
            if let locationManager = self.locationManager {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                locationManager.distanceFilter = 500
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestLocation()
            }
        }
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
extension SearchController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.gameList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.gameList[row]
    }
}
extension SearchController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        let initialViewController = UIStoryboard.initialViewController(for: .search) as! UINavigationController
        (initialViewController.visibleViewController as! SearchResultsViewController).ads = self.ads
        (initialViewController.visibleViewController as! SearchResultsViewController).game = Constants.gameList[self.gamePicker.selectedRow(inComponent: 0)]
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let initialViewController = UIStoryboard.initialViewController(for: .search) as! UINavigationController
        (initialViewController.visibleViewController as! SearchResultsViewController).ads = self.ads
        (initialViewController.visibleViewController as! SearchResultsViewController).game = Constants.gameList[self.gamePicker.selectedRow(inComponent: 0)]
        if let coords = locations.first?.coordinate {
            (initialViewController.visibleViewController as! SearchResultsViewController).location = (coords.latitude, coords.longitude)
        }
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
    }
}
