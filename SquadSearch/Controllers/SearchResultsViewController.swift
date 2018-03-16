//
//  SearchResultsViewController.swift
//  SquadSearch
//
//  Created by swallis on 3/13/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var ads: [Ad]!
    var game: String!
    var location: (latitude: Double, longitude: Double)?
    var userSr: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        if let userAd = ads.first(where: { ad in
            guard User.loggedIn() else { return false }
            return ad.uid == User.current.uid
        }) {
            userSr = Int(userAd.sr)
        }
        ads = ads.filter({ ad in
            if User.loggedIn() && User.current.uid == ad.uid {
                return false
            }
            return true
        })
        ads.sort(by: { [unowned self] (ad1, ad2) in
            var ad1Weight = 1.0
            var ad2Weight = 1.0
            if let location = location {
                if let lat1 = ad1.latitude,
                    let lat2 = ad2.latitude,
                    let long1 = ad1.longitude,
                    let long2 = ad2.longitude {
                        ad1Weight *= 1 + log2(abs(abs(lat1 - location.latitude) - abs(long1 - location.longitude)))
                        ad2Weight *= 1 + log2(abs(abs(lat2 - location.latitude) - abs(long2 - location.longitude)))
                }
            }
            if User.loggedIn(),
                let sr = self.userSr,
                let ad1SR = Int(ad1.sr),
                let ad2SR = Int(ad2.sr) {
                    ad1Weight *= 1 + log10(Double(abs(sr - ad1SR)))
                    ad2Weight *= 1 + log10(Double(abs(sr - ad2SR)))
            }
            print(String(ad1Weight) + "<" + String(ad2Weight))
            return ad1Weight < ad2Weight
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func returnButtonPressed(_ sender: Any) {
        let initialViewController = UIStoryboard.initialViewController(for: .main)
        view.window?.rootViewController = initialViewController
        view.window?.makeKeyAndVisible()
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

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell", for: indexPath) as! ProfileInfoCell
        cell.ad = self.ads[indexPath.row]
        cell.game = self.game
        cell.controller = self.navigationController
        cell.updateAd()
        return cell
    }
}
