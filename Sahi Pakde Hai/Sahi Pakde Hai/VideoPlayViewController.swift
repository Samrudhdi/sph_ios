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

    override func viewDidLoad() {
        super.viewDidLoad()
        CommonUtil.setLandscapeOrientation()
        playVideo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playVideo() {
        if videoURl != nil {
            let player = AVPlayer(url: videoURl!)
            let playerPreview = AVPlayerLayer(player: player)
            playerPreview.frame = CGRect(x: 0, y: 0, width: self.view.frame.height, height: self.view.frame.width)
            self.view.layer.addSublayer(playerPreview)
            player.play()
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
