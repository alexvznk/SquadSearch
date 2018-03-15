//
//  FavoritesController.swift
//  SquadSearch
//
//  Created by swallis on 3/15/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit

class FavoritesController: UIViewController {

    @IBOutlet var favoritesTable: UITableView!
    
    var favorites: [String : [String : Bool]] = [:]
    var listings: [(String, String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTable.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        FavoritesService.all() { [unowned self] favorites in
            self.favorites = favorites
            for game in favorites {
                for uid in game.value.keys {
                    self.listings.append((game.key, uid))
                }
            }
            self.favoritesTable.reloadData()
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

extension FavoritesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !User.loggedIn() {
            return 1
        }
        if self.favorites.isEmpty {
            return 1
        }
        return self.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier = "ProfileInfoCell"
        if !User.loggedIn() {
            identifier = "NotLoggedInCell"
        } else if favorites.isEmpty {
            identifier = "NoFavoritesCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if !favorites.isEmpty,
            let cell = cell as? ProfileInfoCell {
            AdService.fetch(for: listings[indexPath.row].1, in: listings[indexPath.row].0) { ad in
                cell.ad = ad
                cell.game = self.listings[indexPath.row].0
                cell.controller = self.navigationController
                cell.updateAd()
            }
        }
        return cell
    }
}
