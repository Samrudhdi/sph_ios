//
//  VideoPlayViewController.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 31/01/17.
//  Copyright © 2017 Patronous Inc. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayViewController: UIViewController {
    
    var videoURl:URL? = nil
    @IBOutlet weak var videoView: UIView!
    
    var count = 5900//580
    var threeTwoOneCount = 5
    var timer:Timer? = nil
    var threeTwoOneTimer:Timer? = nil
    var questionAtPosition:Int = 0

    @IBOutlet weak var labelTop: UILabel!
    @IBOutlet weak var labelMiddle: UILabel!
    
    var deckResultArray:Array<DeckResult> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonUtil.setLandscapeOrientation()
        playVideo()
        self.threeTwoOneTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.threeTwoOneCounter), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playVideo() {
        if videoURl != nil {
            videoView.layoutIfNeeded()
            let player = AVPlayer(url: videoURl!)
            let playerPreview = AVPlayerLayer(player: player)
            playerPreview.frame = CGRect(x: 0, y: 0, width: self.videoView.frame.height, height: self.videoView.frame.width)
            playerPreview.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.videoView.layer.addSublayer(playerPreview)
            player.play()
        }
    }

    @IBAction func back(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveVideo(_ sender: AnyObject) {
        
    }
    
    @IBAction func shareOnFacebook(_ sender: AnyObject) {
        
    }
    
    func threeTwoOneCounter() {
        if threeTwoOneCount > 0 {
            
            if threeTwoOneCount == 5 {
                labelMiddle.text = "GET READY!"
            }else if threeTwoOneCount <= 3{
                labelMiddle.text = "\(threeTwoOneCount)"
            }
            threeTwoOneCount -= 1
        }else {
            print(threeTwoOneCount)
            threeTwoOneTimer?.invalidate()
            labelMiddle.text = ""
            labelTop.text = self.deckResultArray[questionAtPosition].word
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(counter60), userInfo: nil, repeats: true)
        }
    }
    
    func counter60() {
        if count >= 0 {
            if questionAtPosition < deckResultArray.count{
                let questionAskedTime = deckResultArray[questionAtPosition].questionAskedTime
                let questionAnsweredTime = deckResultArray[questionAtPosition].questionAnsweredTime
                let currentTime = count
                
                if (questionAskedTime >= currentTime){
                    labelTop.text = deckResultArray[questionAtPosition].word
                    labelMiddle.text = ""
                }
                
                if (questionAnsweredTime >= currentTime) {
                    if (deckResultArray[questionAtPosition].isCorrect) {
                        labelMiddle.text = "सही पकड़े है!"
                    }else {
                        labelMiddle.text = "हाय दैया!"
                    }
                    labelTop.text = ""
                    questionAtPosition += 1
                }
                
            }
            count -= 1
        }else {
            timer?.invalidate()
            labelMiddle.text = "TIME'S UP"
            labelTop.text = ""
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
