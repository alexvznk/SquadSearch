//
//  TournamentsViewController.swift
//  SquadSearch
//
//  Created by Alex on 3/13/18.
//  Copyright © 2018 CS125. All rights reserved.
//

import UIKit
import Kingfisher

struct Games: Decodable {
    let name: String
    let begin_at: String
    let league: League
    let videogame: Videogame
    let opponents: [Opponents]
}

struct League: Decodable {
    let id: Int
    let image_url: String?
    let url: String?
    let name: String
    let slug: String
}

struct Videogame: Decodable {
    let id: Int
    let name: String
    let slug: String
}

struct Opponents: Decodable {
    let id: Int
    let type: String
    let opponent: Opponent
}

struct Opponent: Decodable {
    let id: Int
    let name: String
    let acronym: String?
    let image_url: String?
}

class TournamentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let refreshControl = UIRefreshControl()
    
    
    @IBOutlet weak var gameTable: UITableView!
    
    
    var games = [Games]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameTable.dataSource = self
        gameTable.delegate = self
        refreshControl.attributedTitle = NSAttributedString(string: "Updating upcoming matches")
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        gameTable.addSubview(refreshControl)
        fetchData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = gameTable.dequeueReusableCell(withIdentifier: "matchCell") as? MatchCell {
            cell.selectionStyle = .none
            cell.gameName.text = games[indexPath.row].name
            cell.gameDate.text = convertString(string: games[indexPath.row].begin_at)
            
            if games[indexPath.row].opponents.count == 2 {
                
                if let imageUrl1 = games[indexPath.row].opponents[0].opponent.image_url{
                    let url = URL(string: imageUrl1)!
                    cell.teamFirstLogo.kf.setImage(with: url)
                }
                if let imageUrl2 = games[indexPath.row].opponents[1].opponent.image_url{
                    let url = URL(string: imageUrl2)!
                    cell.teamSecondLogo.kf.setImage(with: url)
                }
            }
            
            return cell
        }
        return MatchCell()
    }
    
    
    
    @objc func fetchData() {
        
        let url = URL(string: "https://api.pandascore.co/matches/upcoming?token=Sw1aSFLdQ2ounpkjUIjNsOtcRh0IeKsl8zQ7B-fZPmE5ZH4IXRs")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print("Error has occured: \(error)")
            } else if let _ = response, let data = data {
                do {
                    self.games = try JSONDecoder().decode([Games].self, from: data)
                } catch let error {
                    print("Unable to decode")
                    print(error)
                }
                DispatchQueue.main.async {
                    self.gameTable.reloadData()
                }
            }
            }.resume()
        
        refreshControl.endRefreshing()
    }
    
    
    func convertString(string date: String) -> String {
        
        let formatter = ISO8601DateFormatter()
        let dateISO = formatter.date(from: date)
        if dateISO != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy, HH:mm"
            return dateFormatter.string(from: dateISO!)
        }
        return date
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "matchVC", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let matchVC = segue.destination as? MatchViewController {
            matchVC.gamesData = games
            matchVC.currentGame = sender as! Int
            matchVC.time = convertString(string: games[sender as! Int].begin_at)
        }
    }
}


