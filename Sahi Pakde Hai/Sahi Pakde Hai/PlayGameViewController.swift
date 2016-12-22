//
//  PlayGameViewController.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 06/12/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class PlayGameViewController: UIViewController,UINavigationControllerDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var teamPlayLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    
    var count = 58
    var threeTwoOneCount = 4
    var timer:Timer? = nil
    var threeTwoOneTimer:Timer? = nil
    
    var upward:Int = 0
    var downward:Int = 0
    var middle:Int = 0
    var isGameStarted:Bool = false
    
    var motionManager: CMMotionManager!
    var avPlayer:AVAudioPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAccelerometer()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(Int(UIInterfaceOrientation.landscapeRight.rawValue), forKey: "orientation")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    
    func setupAccelerometer() {
        
        // trigger values - a gap so there isn't a flicker zone
        
        motionManager = CMMotionManager()
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.01
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {
                data,error in
//                fasdjfl
//                if let gravity = deviceMotion?.gravity {
//                    let rotation = atan2(gravity.x, gravity.y) - M_PI
//                    
//                    self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
//                }
                
//                if (deviceMotion?.userAcceleration.x)! < Double(floatLiteral: -2.5) {
//                    self.navigationController?.popViewController(animated: true)
//                }
                
                guard let data = data else { return }
                print("***********************")
//                
//                print("pitch \(data.attitude.pitch)")
//                print("roll \(data.attitude.roll)")
//                print("yaw \(data.attitude.yaw)")
//                print(data.attitude.pitch * 180.0/M_PI)
                let rollAngle = data.attitude.roll * 180.0/M_PI
                print(rollAngle)
//                print(data.attitude.yaw * 180.0/M_PI)
                
//                let x = data.userAcceleration.x
//                let y = data.userAcceleration.y
//                let z = data.userAcceleration.z
//
//                print("x \(x)")
//                print("y \(y)")
//                print("z \(z)")
                
                if self.isMiddle(roll: rollAngle){
                    self.middle = 1
                    if !self.isGameStarted {
                    
                        self.threeTwoOneTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.threeTwoOneCounter), userInfo: nil, repeats: true)
                        
                    }else {
                        self.setBackgroundColor(color: Constant.blackColor)
                        self.setTextOnWordLabel(word: "Word")
                        self.downward = 2
                        self.upward = 2
                    }
                }else if self.isTiltDownward(roll: rollAngle){
                    self.setBackgroundColor(color: Constant.correctColor)
                    self.upward = 1
                    self.downward = 1
                    self.middle = 2
                    self.setTextOnWordLabel(word: "सही पकड़े है!")
                     self.playSound(sound: "correct", ofType: "mp3")
                    
                }else if self.isTiltUpward(roll: rollAngle){
                    self.setBackgroundColor(color: Constant.wrongColor)
                    self.upward = 1
                    self.downward = 1
                    self.middle = 2
                    self.setTextOnWordLabel(word: "हाय दैया!")
                    self.playSound(sound: "pass", ofType: "mp3")
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // get magnitude of vector via Pythagorean theorem
    func magnitudeFromAttitude(attitude: CMAttitude) -> Double {
        return sqrt(pow(attitude.roll, 2) + pow(attitude.yaw, 2) + pow(attitude.pitch, 2))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        motionManager.stopAccelerometerUpdates()
    }
    
    func threeTwoOneCounter() {
        if threeTwoOneCount > 0 {
            
            if threeTwoOneCount == 4 {
                print("threeTwoOneCount \(threeTwoOneCount)")
                playSound(sound: "get_ready", ofType: "mp3")
                wordLabel.text = "GET READY!"
            }else {
                print("threeTwoOneCount \(threeTwoOneCount)")
                playSound(sound: "three_two_one", ofType: "mp3")
                wordLabel.text = "\(threeTwoOneCount)"
            }
            threeTwoOneCount -= 1
        }else {
            print(threeTwoOneCount)
            threeTwoOneTimer?.invalidate()
            self.upward = 2;
            self.downward = 2;
            isGameStarted = true
            wordLabel.text = "Word"
            timerLabel.text = "\(count + 1)"
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        }
    }
    
    func counter() {
        if count >= 0 {
            var countText = "\(count)"
            if count < 10 {
                playSound(sound: "time_low_loop", ofType: "mp3")
            }
            
            if count == 0 {
                wordLabel.text = "TIME'S UP"
                countText = ""
                motionManager.stopDeviceMotionUpdates()
                playSound(sound: "round_end_buzzer", ofType: "mp3")
            }
            timerLabel.text = "\(countText)"
            count -= 1
        }else {
            timer?.invalidate()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        threeTwoOneTimer?.invalidate()
        timer?.invalidate()
        motionManager.stopDeviceMotionUpdates()
    }


//    Wrong
    func isTiltUpward(roll:Double) -> Bool {
        
        if ((roll >= -50) && upward == 2){
            print("upward")
            return true
        }else {
            return false
        }
    }

//    Correct
    func isTiltDownward(roll:Double) -> Bool {
        if ((roll <= -121) && downward == 2){
            print("downward")
            return true
        }else {
            return false
        }
    }
    
    func isMiddle(roll:Double) -> Bool {
        
        if ((roll <= -60 && roll >= -110) && middle == 0){
            print("place on forehead")
            
            return true
        }else if ((roll <= -51 && roll >= -120) && middle == 2){
            print("middle")
            return true
        }else {
            return false
        }
    }

    func playSound(sound:String,ofType:String) {
       avPlayer = CommonUtil.playSound(sound: sound, ofType: ofType)
        if avPlayer != nil{
            avPlayer?.play()
        }
    }
    
    func setBackgroundColor(color:UIColor) {
        self.view.backgroundColor = color
    }
    
    func setTextOnWordLabel(word:String) {
        self.wordLabel.text = word
    }
}

