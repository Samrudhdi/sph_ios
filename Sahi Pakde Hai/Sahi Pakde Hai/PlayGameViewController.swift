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

class PlayGameViewController: UIViewController {

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
        threeTwoOneTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(threeTwoOneCounter), userInfo: nil, repeats: true)
        
        
        
        // Do any additional setup after loading the view.
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
                
                print(data.attitude)
                let x = data.userAcceleration.x
                let y = data.userAcceleration.y
                let z = data.userAcceleration.z
                
                
//                userAcceleration
                
//                let angle = atan2(y, x) + M_PI_2          // in radians
//                let angleDegrees = angle * 180.0 / M_PI   // in degrees
//                
//                let ans = Float(x*x) + Float(y*y) + Float(z*z)
//                let r = sqrtf(Float(ans))
                print("***********************")
                print(x)
                print(y)
                print(z)
                
//                self.isMiddle(x: x, y: y, z: z)
                
                if self.isMiddle(x: x, y: y, z: z){
                    self.middle = 2
                }
//
//                if self.isTiltDownward(x: x, y: y, z: z){
////                    self.upward = 1
////                    self.downward = 1
////                    self.middle = 2
//                }
//                
//                if self.isTiltUpward(x: x, y: y, z: z){
////                    self.upward = 1
////                    self.downward = 1
////                    self.middle = 2
//                }
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
            wordLabel.text = "Word"
            timerLabel.text = "\(count + 1)"
            threeTwoOneTimer?.invalidate()
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
                motionManager.stopAccelerometerUpdates()
                playSound(sound: "round_end_buzzer", ofType: "mp3")
            }
            timerLabel.text = "\(countText)"
            count -= 1
        }else {
            timer?.invalidate()
        }
    }


    
    func isTiltUpward(x:Double, y:Double, z:Double) -> Bool {
        if (((x <= -0.7) && (y >= -0.5 && y <= 0.5) && (z >= -0.5 && z <= 0.6)) && middle == 0){
            print("upward")
            return true
        }else {
            return false
        }
    }

    func isTiltDownward(x:Double, y:Double, z:Double) -> Bool {
        if (x <= 3 && (y >= 0.0 && y <= 3.0) && (z >= -11.0 && z <= -4.0) && downward == 2){
            print("downward")
            return true
        }else {
            return false
        }
    }
    
    func isMiddle(x:Double, y:Double, z:Double) -> Bool {
        
        if (((x <= -0.7) && (y >= -0.5 && y <= 0.5) && (z >= -0.5 && z <= 0.6)) && middle == 0){
            print("place on forehead")
            return true
        }else if (((x <= -0.6) && (y >= -0.5 && y <= 0.5) && (z >= -0.5 && z <= 0.6)) && middle == 0){
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
