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
    
    @IBOutlet weak var segmentedCntrl: UISegmentedControl!
    
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
       
        switch(segmentedCntrl.selectedSegmentIndex) {
        case 0:
            return returnGameArray(forGame: "Dota 2").count
        case 1:
            return returnGameArray(forGame: "Overwatch").count
        case 2:
            return returnGameArray(forGame: "LoL").count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = gameTable.dequeueReusableCell(withIdentifier: "matchCell") as? MatchCell {
            cell.selectionStyle = .none
            
            let dota2Games = returnGameArray(forGame: "Dota 2")
            let overwatchGames = returnGameArray(forGame: "Overwatch")
            let lolGames = returnGameArray(forGame: "LoL")
            
            switch(segmentedCntrl.selectedSegmentIndex) {
            case 0:
                return updateCell(for: cell, cellIndex: indexPath.row, andGameArray: dota2Games)
            case 1:
                return updateCell(for: cell, cellIndex: indexPath.row, andGameArray: overwatchGames)
            case 2:
                return updateCell(for: cell, cellIndex: indexPath.row, andGameArray: lolGames)
                
            default:
                return MatchCell()
            }
        }
        
        return MatchCell()
    }
    
    
    
    func returnGameArray (forGame gameName: String) -> [Games] {
        
        var gameArray = [Games]()
        
        for game in games {
            if game.videogame.name == gameName {
            gameArray.append(game)
            }
        }
      return gameArray
    }
    
    
    func updateCell(for cell: MatchCell, cellIndex index: Int, andGameArray gameArray: [Games] ) -> MatchCell {
        
        
        cell.gameName.text = gameArray[index].name
        cell.gameDate.text = convertString(string: gameArray[index].begin_at)
        
        if gameArray[index].opponents.count == 2 {
            
            if let imageUrl1 = gameArray[index].opponents[0].opponent.image_url{
                let url = URL(string: imageUrl1)!
                cell.teamFirstLogo.kf.setImage(with: url)
            }
            if let imageUrl2 = gameArray[index].opponents[1].opponent.image_url{
                let url = URL(string: imageUrl2)!
                cell.teamSecondLogo.kf.setImage(with: url)
            }
        } else {
            cell.teamFirstLogo.image = nil
            cell.teamSecondLogo.image = nil
        }
        
       return cell
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
    
   
    @IBAction func segmentedCntrlChanged(_ sender: Any) {
        gameTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "matchVC", sender: indexPath.row)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let matchVC = segue.destination as? MatchViewController {
        switch(segmentedCntrl.selectedSegmentIndex) {
        case 0:
            matchVC.gamesData = returnGameArray(forGame: "Dota 2")
            matchVC.time = convertString(string: returnGameArray(forGame: "Dota 2")[sender as! Int].begin_at)
        case 1:
            matchVC.gamesData = returnGameArray(forGame: "Overwatch")
            matchVC.time = convertString(string: returnGameArray(forGame: "Overwatch")[sender as! Int].begin_at)
        case 2:
            matchVC.gamesData = returnGameArray(forGame: "LoL")
            matchVC.time = convertString(string: returnGameArray(forGame: "LoL")[sender as! Int].begin_at)
        default:
            break
        }
            matchVC.currentGame = sender as! Int
        }
    }
    
}


