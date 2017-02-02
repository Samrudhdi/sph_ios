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

class PlayGameViewController: UIViewController,UINavigationControllerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureFileOutputRecordingDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var teamPlayLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    
    var count = 5900//580
    var threeTwoOneCount = 5
    var timer:Timer? = nil
    var threeTwoOneTimer:Timer? = nil
    
    var upward:Int = 0
    var downward:Int = 0
    var middle:Int = 0
    var isGameStarted:Bool = false
    
    var motionManager: CMMotionManager!
    var avPlayer:AVAudioPlayer? = nil
    var dataOutput:AVCaptureMovieFileOutput? = nil
    
    var selectedCategory = Category()
    var deckArray:Array<Deck> = []
    var deckResultArray:Array<DeckResult> = []
    var deckResult = DeckResult()
    var deckQuestionAtPosition = 0;
    
    var deckId:Int = 0
    var outputvideofileURL:URL? = nil
    
    var isTimsUP = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("viewDidLoad")
        
        CommonUtil.setLandscapeOrientation()
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        
        setupCameraSession()
        setupAccelerometer()
        deckId = selectedCategory.categoryId
        getSelectedCategoryList(categoryId: deckId)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("viewWillAppear")
    }
    
    func willEnterForeground(){
//        print("willEnterForeground")
//        self.navigationController?.popViewController(animated: false)
    }
    
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.landscapeRight
    }
//
//    
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
//                print("***********************")
//
//                print("pitch \(data.attitude.pitch)")
//                print("roll \(data.attitude.roll)")
//                print("yaw \(data.attitude.yaw)")
//                print(data.attitude.pitch * 180.0/M_PI)
                let rollAngle = data.attitude.roll * 180.0/M_PI
                let yawAngle = data.attitude.roll * 180.0/M_PI
                let pitchAngle = data.attitude.pitch * 180.0/M_PI
                
//                print("rollAngle \(rollAngle)")
//                print("yaw \(yawAngle)")
//                print("pitch \(pitchAngle)")
//                print(data.attitude.yaw * 180.0/M_PI)
                
//                let x = data.userAcceleration.x
//                let y = data.userAcceleration.y
//                let z = data.userAcceleration.z
//
//                print("x \(x)")
//                print("y \(y)")
//                print("z \(z)")
                
                if self.isMiddle(roll: rollAngle,pitch: pitchAngle){
                    self.middle = 1
                    if !self.isGameStarted {
                    
                        self.threeTwoOneTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.threeTwoOneCounter), userInfo: nil, repeats: true)
                        
                    }else {
                        if self.deckQuestionAtPosition < self.deckArray.count {
                            self.deckResult = DeckResult()
                            let word = self.deckArray[self.deckQuestionAtPosition].word
                            self.deckResult.word = word
                            self.deckResult.questionAskedTime = self.count
                            self.deckResult.deckId = (self.deckId);
                            self.deckResultArray.append(self.deckResult)
                            self.setBackgroundColor(color: Constant.blackColor)
                            self.setTextOnWordLabel(word: word)
                            self.downward = 2
                            self.upward = 2
                        }else {
                            let question = "No more words are available."
                            self.deckResult = DeckResult()
                            self.deckResult.word = question
                            self.deckResult.questionAskedTime = self.count
                            self.setTextOnWordLabel(word: question)
                            self.downward = 1
                            self.upward = 1
                        }
                    }
                }else if self.isTiltDownward(roll: rollAngle,pitch: pitchAngle){
                    if self.isGameStarted {
                        self.upward = 1
                        self.downward = 1
                        self.middle = 2
                        self.setBackgroundColor(color: Constant.correctColor)
                        self.setTextOnWordLabel(word: "सही पकड़े है!")
                        self.playSound(sound: "correct", ofType: "mp3")
                        self.deckResultArray[self.deckResultArray.endIndex - 1].questionAnsweredTime = self.count
                        self.deckResultArray[self.deckResultArray.endIndex - 1].isCorrect = true
                        self.deckQuestionAtPosition += 1
                    }
                }else if self.isTiltUpward(roll: rollAngle,pitch: pitchAngle){
                    if self.isGameStarted {
                        self.setBackgroundColor(color: Constant.wrongColor)
                        self.upward = 1
                        self.downward = 1
                        self.middle = 2
                        self.setTextOnWordLabel(word: "हाय दैया!")
                        self.playSound(sound: "pass", ofType: "mp3")
                        self.deckResultArray[self.deckResultArray.endIndex - 1].questionAnsweredTime = self.count
                        self.deckResultArray[self.deckResultArray.endIndex - 1].isCorrect = false
                        self.deckQuestionAtPosition += 1
                    }
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
            
            if threeTwoOneCount == 5 {
                startVideoRecording()
//                print("threeTwoOneCount \(threeTwoOneCount)")
                playSound(sound: "get_ready", ofType: "mp3")
                wordLabel.text = "GET READY!"
            }else if threeTwoOneCount <= 3{
//                print("threeTwoOneCount \(threeTwoOneCount)")
                playSound(sound: "three_two_one", ofType: "mp3")
                wordLabel.text = "\(threeTwoOneCount)"
            }
            threeTwoOneCount -= 1
        }else {
            print(threeTwoOneCount)
            threeTwoOneTimer?.invalidate()
            if deckArray.count > 0{
                self.upward = 2;
                self.downward = 2;
                isGameStarted = true
                let firstWord = deckArray[deckQuestionAtPosition].word
                wordLabel.text = firstWord.capitalized
                timerLabel.text = "\(count / 100)"
                deckResult = DeckResult()
                deckResult.word = firstWord
                deckResult.questionAskedTime = self.count
                deckResult.deckId = (deckId);
                deckResultArray.append(deckResult)
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(counter60), userInfo: nil, repeats: true)
            }
        }
    }
    
    func counter60() {
        if count >= 0 {
            if (count / 100 <= 10) && (count % 100) == 0 {
                playSound(sound: "time_low_loop", ofType: "mp3")
            }
            
            if count / 100 >= 1 {
                timerLabel.text = "\(count / 100)"
                print(count)
            }
            count -= 1
            
        }else {
            timer?.invalidate()
            print(count)
            print("TIME'S UP")
            wordLabel.text = "TIME'S UP"
            timerLabel.text = ""
            motionManager.stopDeviceMotionUpdates()
            playSound(sound: "round_end_buzzer", ofType: "mp3")
            stopVideoRecording()
            updateIsPlayedFlag()
            perform(#selector(goToScoreCardController), with: nil, afterDelay: 1.0)
//            performSegue(withIdentifier: "ScoreCardViewController", sender: self)
//            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func goToScoreCardController() {
        if self.storyboard?.instantiateViewController(withIdentifier: "SCORE_CARD_VIEW") is ScoreCardViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SCORE_CARD_VIEW") as! ScoreCardViewController
            
            controller.deckResultArray = self.deckResultArray
            controller.selectedCategory = self.selectedCategory
            controller.videoUrl = self.outputvideofileURL
            
            present(controller, animated: true, completion: {})
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        threeTwoOneTimer?.invalidate()
        timer?.invalidate()
        motionManager.stopDeviceMotionUpdates()
    }


//    Wrong
    func isTiltUpward(roll:Double,pitch:Double) -> Bool {
        
        if (((roll >= -50) && (pitch <= 25.0 && pitch >= -25.0)) && upward == 2){
            print("upward")
            return true
        }else {
            return false
        }
    }

//    Correct
    func isTiltDownward(roll:Double,pitch:Double) -> Bool {
        if (((roll <= -121) && (pitch <= 25.0 && pitch >= -25.0)) && downward == 2){
            print("downward")
            return true
        }else {
            return false
        }
    }
    
    func isMiddle(roll:Double, pitch:Double) -> Bool {
        
        if (((roll <= -60 && roll >= -110) && (pitch <= 25.0 && pitch >= -25.0)) && middle == 0){
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
       avPlayer = CommonUtil().playSound(sound: sound, ofType: ofType)
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
    
    
    
//    :camera
    lazy var cameraSession: AVCaptureSession = {
        let s = AVCaptureSession()
        s.sessionPreset = AVCaptureSessionPresetLow
        return s
    }()
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
//        preview?.bounds = CGRect(x: 0, y: 0, width: self.videoView.bounds.width, height: self.view.bounds.height)
//        preview?.position = CGPoint(x: 0, y: self.view.frame.height)
        preview?.frame = CGRect(x: 0, y: 0, width: self.view.frame.height, height: self.view.frame.width)

//        preview?.frame = self.videoView.bounds
        preview?.connection.videoOrientation = .landscapeRight
        preview?.videoGravity = AVLayerVideoGravityResize
        return preview!
    }()

    func setupCameraSession() {
        
        var captureDevice:AVCaptureDevice
        if #available(iOS 10.0, *) {
            captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front) as AVCaptureDevice
        } else {
            // Fallback on earlier versions
            captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            let devices = AVCaptureDevice.devices()
            for device in devices! {
                let tmp = device as! AVCaptureDevice
                if tmp.hasMediaType(AVMediaTypeVideo){
                    if tmp.position == AVCaptureDevicePosition.front {
                        captureDevice = tmp
                    }
                    
                }
            }
            
        }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)

            cameraSession.beginConfiguration()
            
            if (cameraSession.canAddInput(deviceInput) == true) {
                cameraSession.addInput(deviceInput)
            }
            
            // Add audio device to the recording
            let audioDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
            do {
                let audioInput: AVCaptureDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
                self.cameraSession.addInput(audioInput)
                
            } catch {
                print("Unable to add audio device to the recording.")
            }
            
            cameraSession.commitConfiguration()
            
            videoView.layer.addSublayer(previewLayer)
            cameraSession.startRunning()
            
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        // Here you collect each frame and process it
        print(captureOutput.description)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        // Here you can count how many frames are dopped
    }
    
    func startVideoRecording() {
        
//        checking camera permission
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == AVAuthorizationStatus.authorized {
            
            dataOutput = AVCaptureMovieFileOutput()
            let fileName = "mysavefile.mp4"
            
            if (cameraSession.canAddOutput(dataOutput) == true) {
                cameraSession.addOutput(dataOutput)
            }
            
            var videoConnection:AVCaptureConnection? = nil
            
            for connection in (dataOutput?.connections)! {
                let conn = connection as! AVCaptureConnection
                print(connection)
                for port in conn.inputPorts {
                    let p = port as! AVCaptureInputPort
                    if p.mediaType == AVMediaTypeVideo{
                        videoConnection = conn
                        break
                    }
                }
            }
            
            if videoConnection != nil {
                if (videoConnection?.isVideoOrientationSupported)!{
                    videoConnection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                }
                
                if (videoConnection?.isVideoMirroringSupported)! {
                    videoConnection?.isVideoMirrored = true
                }
            }
            
            let documentURl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = documentURl.appendingPathComponent(fileName)
            
            dataOutput?.startRecording(toOutputFileURL: filePath, recordingDelegate: self)
        }
    }
    
    func stopVideoRecording() {
//        if cameraSession != nil {
        if dataOutput != nil {
            dataOutput?.stopRecording()
            cameraSession.stopRunning()
        }
//        }
    }
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("finish \(outputFileURL)")
//        outputvideofileURL = outputFileURL
//        playVideo(url: outputFileURL)
        
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        print("start \(fileURL)")
        outputvideofileURL = fileURL
    }
    
    func playVideo(url:URL) {
        let player = AVPlayer(url: url)
        let playerPreview = AVPlayerLayer(player: player)
        playerPreview.frame = self.view.bounds
        
        self.view.layer.addSublayer(playerPreview)
        player.play()
    }
    
    func getSelectedCategoryList(categoryId:Int)  {
//        if (let category == selectedCategory) {
        if categoryId >= 0 {
            let sqlite:SQLiteDatabase = SQLiteDatabase()
            deckArray = sqlite.getDecklist(categoryId: categoryId)
            for deck in deckArray {
                print(deck)
            }
        }
        
//        }
    }
    
    func updateIsPlayedFlag() {
        let sqlite:SQLiteDatabase = SQLiteDatabase()
        sqlite.updateDeckIsPlayed(deckResultArray: deckResultArray)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScoreCardViewController" {
            let controller = segue.destination as! ScoreCardViewController
            controller.deckResultArray = self.deckResultArray
            controller.selectedCategory = self.selectedCategory
        }
    }
}

