//
//  TeamFinalScoreCardViewController.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 27/02/17.
//  Copyright © 2017 Patronous Inc. All rights reserved.
//

import UIKit

class TeamFinalScoreCardViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var team1FaceImageView: UIImageView!
    @IBOutlet weak var team2FaceImageView: UIImageView!
    
    var selectedCategory = Category()
    
    var teamScoreArray:Array<TeamPlayScore>? = nil
    var team1Total:Int = 0
    var team2Total:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        teamScoreArray = TeamPlayUtil.getTeamScore()
        calculateTotalScore()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TeamFinalScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamFinalScoreTableViewCell")
        tableView.register(UINib(nibName: "TotalScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "TotalScoreTableViewCell")
        setFace()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: AnyObject) {
        TeamPlayUtil.isTeamPlay = false;
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func teamPlayAgain(_ sender: AnyObject) {
        TeamPlayUtil.isTeamPlay = true
        TeamPlayUtil.playingRound = 1
        TeamPlayUtil.playingTeam = 1
        TeamPlayUtil.initTeamScore()
        showPlayGameController()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamScoreArray!.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if indexPath.row < (teamScoreArray?.count)! {
            let teamPlayScore = teamScoreArray?[indexPath.row]
            let team1 = teamPlayScore?.team1Score
            let team2 = teamPlayScore?.team2Score
            cell = getScoreCell(indexPath: indexPath, team1Score: team1!, team2Score: team2!)
        }else {
            cell = getTotalScoreCell(indexPath: indexPath)
        }
        
        return cell!
    }
    
    func getScoreCell(indexPath:IndexPath,team1Score:Int,team2Score:Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamFinalScoreTableViewCell", for: indexPath) as! TeamFinalScoreTableViewCell
        cell.team1Score.text = "\(team1Score)"
        cell.team2Score.text = "\(team2Score)"
        return cell
    }
    
    func getTotalScoreCell(indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TotalScoreTableViewCell", for: indexPath) as! TotalScoreTableViewCell
        cell.team1TotalScore.text = "\(team1Total)"
        cell.team2TotalScore.text = "\(team2Total)"
        if team1Total > team2Total {
            cell.team1CupImage.isHidden = false
            cell.team2CupImage.isHidden = true
        }else if team1Total <  team2Total {
            cell.team1CupImage.isHidden = true
            cell.team2CupImage.isHidden = false
        }else {
            cell.team1CupImage.isHidden = false
            cell.team2CupImage.isHidden = false
        }
        return cell
    }

    func showPlayGameController() {
        if self.storyboard?.instantiateViewController(withIdentifier: "PLAY_GAME_VIEW") is PlayGameViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "PLAY_GAME_VIEW") as! PlayGameViewController
            controller.selectedCategory = self.selectedCategory
            present(controller, animated: true, completion: {})
        }
        
    }

    func calculateTotalScore() {
        for teamPlayScore in teamScoreArray! {
            team1Total += teamPlayScore.team1Score
            team2Total += teamPlayScore.team2Score
        }
    }
    
    func setFace() {
        if team1Total > team2Total {
            team1FaceImageView.image = UIImage(named: "user_happy_face")
            team2FaceImageView.image = UIImage(named: "user_sad_face")
        }else if team1Total <  team2Total {
            team1FaceImageView.image = UIImage(named: "user_sad_face")
            team2FaceImageView.image = UIImage(named: "user_happy_face")
        }else {
            team1FaceImageView.image = UIImage(named: "user_happy_face")
            team2FaceImageView.image = UIImage(named: "user_happy_face")
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
