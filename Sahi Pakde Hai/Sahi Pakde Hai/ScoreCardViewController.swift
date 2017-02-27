//
//  ScoreCardViewController.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 22/12/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import UIKit
import AVFoundation

class ScoreCardViewController: BaseUIViewController,UITableViewDataSource,UITableViewDelegate {

    var deckResultArray:Array<DeckResult> = []
    var animateDeckResult:Array<DeckResult> = []
    var selectedCategory = Category()
    var videoUrl:URL?
    var totalCorrect = 0
    enum ButtonType{
        case PLAY_AGAIN
        case CONTINUE
        case FINAL_SCORE
        case BUY
    }
    var  buttonType = ButtonType.PLAY_AGAIN
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playSameCategoryButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var videoThumbnailImageView: UIImageView!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoViewConstrain: NSLayoutConstraint!
    
    var playingTeam:Int?
    var playingRound:Int?
    var totalTeams:Int?
    var totalRounds:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoView(hide: false)
        self.videoThumbnailImageView.layoutIfNeeded()
        self.videoThumbnailImageView.setNeedsDisplay()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultTableViewCell")
        self.setFace()
        self.setupPlayButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GoogleAnalyticsUtil().trackScreen(screenName: Constant.SCREEN_SCORE_CARD)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        print("support orientation");
        return UIInterfaceOrientationMask.portrait
    }
    
    @IBAction func playSameCategory(_ sender: AnyObject) {
        self.setupPlayButtonClick()
    }
    
    
    func showPlayGameController() {
        if self.storyboard?.instantiateViewController(withIdentifier: "PLAY_GAME_VIEW") is PlayGameViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "PLAY_GAME_VIEW") as! PlayGameViewController
            controller.selectedCategory = self.selectedCategory
            present(controller, animated: true, completion: {})
        }

    }
    
    @IBAction func back(_ sender: AnyObject) {
        if self.storyboard?.instantiateViewController(withIdentifier: "CATEGORY_VIEW") is CategorySelectionViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "CATEGORY_VIEW") as! CategorySelectionViewController
            present(controller, animated: true, completion: {})
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckResultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as! ResultTableViewCell
        let label:UILabel = cell.resultLabel
        let deckResult = deckResultArray[indexPath.row]
        label.text = deckResult.word
        if deckResult.isCorrect {
            label.textColor = UIColor.white
//            increaseScoreByOne()
        }else {
            label.textColor = UIColor.red
        }
        
        return cell
    }
    
    func setFace() {
        for deckResult in deckResultArray {
            if deckResult.isCorrect {
                totalCorrect += 1
            }
        }
        
        scoreLabel.text = "Score \(totalCorrect)"
        if totalCorrect >= 4 {
            self.faceImageView.image? = UIImage.init(named: "user_happy_face")!
        }else {
            self.faceImageView.image? = UIImage.init(named: "user_sad_face")!
        }
    }
    
    func increaseScoreByOne() {
        totalCorrect += 1
        scoreLabel.text = "Score \(totalCorrect)"
    }
    
    func setThumbnail() {
        print(videoUrl)
        if videoUrl != nil {
//            playVideo(url: videoUrl!)
            let image = CommonUtil.getThumbnail(url: videoUrl!)
            if image != nil {
                self.videoThumbnailImageView.image = image
            }
        }
    }
    
    func setResultWordOneByOne() {
        for index in 0...deckResultArray.count {
            let indexPath:IndexPath = IndexPath(row: index, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func animateTable() {
        
//        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI))
        
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        var index = 0
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
//            cell.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            index += 1
        }
        
        index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
//            UIView.animateWithDuration(1.5, delay: (0.05 * index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
//                cell.transform = CGAffineTransformMakeTranslation(0, 0)
//                }, completion: nil)
            
//            let indexPath = IndexPath(row: 5, section: 0)
//            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
//            tableView.tableViewScrollToBottom(animated: true)
                UIView.animate(withDuration: 0.5, delay: 1 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
            
            index += 1
        }
    }
    
    @IBAction func playVideo(_ sender: AnyObject) {
        
        if self.storyboard?.instantiateViewController(withIdentifier: "VIDEO_PLAY_VIEW") is VideoPlayViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "VIDEO_PLAY_VIEW") as! VideoPlayViewController
            controller.videoURl = self.videoUrl
            controller.deckResultArray = self.deckResultArray
            controller.selectedCategory = self.selectedCategory
            
            present(controller, animated: true, completion: {})
        }

    }
    
    func setupVideoView(hide:Bool) {
        if hide {
            videoView.isHidden = true
            videoViewConstrain.constant = 10
        }else {
            videoView.isHidden = false
            self.setThumbnail()
        }
    }
    
    func setButtonText(text:String){
        playSameCategoryButton.setTitle(text, for: .normal)
    }

    func setupPlayButton() {
        if PreviewUtil.isPreviewPlay {
            setButtonText(text: "Buy@ Rs.59.00")
            buttonType = ButtonType.BUY
        }else {
            if TeamPlayUtil.isTeamPlay {
                var teamScore = TeamPlayUtil.totalTeamScore
                var team1 = TeamPlayUtil.team1Score
                var team2 = TeamPlayUtil.team2Score
                
                playingTeam = TeamPlayUtil.playingTeam
                playingRound = TeamPlayUtil.playingRound
                totalTeams = TeamPlayUtil.totalTeams
                totalRounds = TeamPlayUtil.totalRounds
                
                let playingTeamIndex = playingTeam! - 1
                
                if (teamScore.count) >= totalTeams! {
                    
                    print("Team Score \(teamScore[playingTeamIndex])")
                     teamScore[playingTeamIndex] += totalCorrect
                    TeamPlayUtil.setTotalTeamScore(teamScore: teamScore)
                }else {
                    teamScore.insert(totalCorrect, at: playingTeamIndex)
                    TeamPlayUtil.setTotalTeamScore(teamScore: teamScore)
                }
                
                if (playingTeam == 1){
                    team1.append(totalCorrect)
                    TeamPlayUtil.setTeam1Score(team1Score: team1)
                }else {
                    team2.append(totalCorrect)
                    TeamPlayUtil.setTeam2Score(team2Score: team2)
                }
                
                if (totalRounds == playingRound && totalTeams == playingTeam){
                    let finalScore = TeamPlayUtil.totalTeamScore
                    let team1Score = TeamPlayUtil.team1Score
                    let team2Score = TeamPlayUtil.team2Score
                    print("final Score \(finalScore)")
                    print("Team 1 Score \(team1Score)")
                    print("Team 2 Score \(team2Score)")
                    setButtonText(text: "FINAL SCORE")
                    buttonType = ButtonType.FINAL_SCORE
                }else {
                    if (TeamPlayUtil.totalTeams == TeamPlayUtil.playingTeam) {
                        TeamPlayUtil.playingRound = TeamPlayUtil.playingRound + 1
                        TeamPlayUtil.playingTeam = 1
                    } else {
                        TeamPlayUtil.playingTeam = TeamPlayUtil.playingTeam + 1
                    }

                    setButtonText(text: "CONTINUE")
                    buttonType = ButtonType.CONTINUE
                }
            }else {
                setButtonText(text: "PLAY SAME CATEGORY")
                buttonType = ButtonType.PLAY_AGAIN
            }
        }
    }
    
    func setupPlayButtonClick() {
        switch buttonType {
        case .PLAY_AGAIN:
            showPlayGameController()
            break
            
        case .CONTINUE:
            showPlayGameController()
            break
            
        case .FINAL_SCORE:
            
            break
            
        case .BUY:
            
            break
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
