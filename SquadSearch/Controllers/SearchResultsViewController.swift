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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
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
