//
//  TeamPlayViewController.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 24/02/17.
//  Copyright © 2017 Patronous Inc. All rights reserved.
//

import UIKit

class TeamPlayViewController: UIViewController {
    
    var selectedRound = 3

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var round3Button: UIButton!

    @IBOutlet weak var round4Button: UIButton!
    
    @IBOutlet weak var round5Button: UIButton!
    
    @IBAction func back(_ sender: AnyObject) {
        GoogleAnalyticsUtil().trackEvent(action:Constant.ACT_CANCEL, category: Constant.CAT_TEAM_PLAY, label: "")
        TeamPlayUtil.setIsTeamPlay(isTeamPlay: false)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseCategory(_ sender: AnyObject) {
        GoogleAnalyticsUtil().trackEvent(action: "\(Constant.ACT_NUMBER_OF_ROUNDS) \(selectedRound)", category: Constant.CAT_TEAM_PLAY, label: "")
        GoogleAnalyticsUtil().trackEvent(action:Constant.ACT_CHOOSE_CATEGORY, category: Constant.CAT_TEAM_PLAY, label: "")
        TeamPlayUtil.setIsTeamPlay(isTeamPlay: true)
        TeamPlayUtil.setTotalRounds(round: self.selectedRound)
//        TeamPlayUtil.setTotalTeamScore(teamScore: Array<Int>())
//        TeamPlayUtil.setTeam1Score(team1Score: Array<Int>())
//        TeamPlayUtil.setTeam2Score(team2Score: Array<Int>())
        showCategoryPage()
    }
    
    @IBAction func round3Selected(_ sender: AnyObject) {
        print("selected round 3")
        selectedRound = 3
        setUnselectedBackgroundColor()
        setBackgroundColor(button: sender as! UIButton, color: Constant.selected_round_bg_color)
    }
    
    @IBAction func round4Selected(_ sender: AnyObject) {
        print("selected round 4")
        selectedRound = 4
        setUnselectedBackgroundColor()
        setBackgroundColor(button: sender as! UIButton, color: Constant.selected_round_bg_color)
    }
    
    @IBAction func round5Selected(_ sender: AnyObject) {
        print("selected round 5")
        selectedRound = 5
        setUnselectedBackgroundColor()
        setBackgroundColor(button: sender as! UIButton, color: Constant.selected_round_bg_color)
    }
    
    func setUnselectedBackgroundColor() {
        setBackgroundColor(button: round3Button, color: Constant.unselected_round_bg_color)
        setBackgroundColor(button: round4Button, color: Constant.unselected_round_bg_color)
        setBackgroundColor(button: round5Button, color: Constant.unselected_round_bg_color)
    }
    
    func setBackgroundColor(button:UIButton, color:UIColor)  {
        button.backgroundColor = color
    }
    
    func showCategoryPage() {
        if self.storyboard?.instantiateViewController(withIdentifier: "CATEGORY_VIEW") is CategorySelectionViewController {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "CATEGORY_VIEW") as! CategorySelectionViewController
            present(controller, animated: true, completion: {})
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
