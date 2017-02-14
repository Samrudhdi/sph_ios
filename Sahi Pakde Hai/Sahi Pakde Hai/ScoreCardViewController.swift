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
    var score = 0
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playSameCategoryButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var videoThumbnailImageView: UIImageView!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoViewConstrain: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideVideoView(hide: false)
        self.videoThumbnailImageView.layoutIfNeeded()
        self.videoThumbnailImageView.setNeedsDisplay()
        
        CommonUtil.setPortraitOrientation()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultTableViewCell")
        
//        tableView.reloadData()
        self.setFace()
        self.setThumbnail()
//        self.setResultWordOneByOne()
    
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CommonUtil.setPortraitOrientation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func playSameCategory(_ sender: AnyObject) {
//        performSegue
        if self.storyboard?.instantiateViewController(withIdentifier: "PLAY_GAME_VIEW") is PlayGameViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "PLAY_GAME_VIEW") as! PlayGameViewController
            controller.selectedCategory = self.selectedCategory
            present(controller, animated: true, completion: {})
        }

    }
    
    @IBAction func back(_ sender: AnyObject) {
//        self.navigationController?.popToRootViewController(animated: true)
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
        var totalCorrect:Int = 0
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
        score += 1
        scoreLabel.text = "Score \(score)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayGameViewController" {
            let controller = segue.destination as! PlayGameViewController
            controller.selectedCategory = self.selectedCategory
        }
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
        
//        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI));
        
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        var index = 0
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
//            cell.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
            index += 1
        }
        
        index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
//            UIView.animateWithDuration(1.5, delay: (0.05 * index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
//                cell.transform = CGAffineTransformMakeTranslation(0, 0);
//                }, completion: nil)
            
//            let indexPath = IndexPath(row: 5, section: 0)
//            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
//            tableView.tableViewScrollToBottom(animated: true)
                UIView.animate(withDuration: 0.5, delay: 1 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    @IBAction func playVideo(_ sender: AnyObject) {
        
        if self.storyboard?.instantiateViewController(withIdentifier: "VIDEO_PLAY_VIEW") is VideoPlayViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "VIDEO_PLAY_VIEW") as! VideoPlayViewController
            controller.videoURl = self.videoUrl
            controller.deckResultArray = self.deckResultArray
            
            present(controller, animated: true, completion: {})
        }

    }
    
    func hideVideoView(hide:Bool) {
        if hide {
            videoView.isHidden = true
            videoViewConstrain.constant = 10
        }else {
            videoView.isHidden = false
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
