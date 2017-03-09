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
    
    var count = Constant.count
    var threeTwoOneCount = Constant.threeTwoOneCount
    var timer:Timer? = nil
    var threeTwoOneTimer:Timer? = nil
    
    var upward:Int = 0
    var downward:Int = 0
    var middle:Int = 0
    var isGameStarted:Bool = false
    
    var motionManager: CMMotionManager!
    var avPlayer:AVAudioPlayer? = nil
    var avPlayerTimerLow:AVAudioPlayer? = nil
    var dataOutput:AVCaptureMovieFileOutput? = nil
    var filePath:URL? = nil
    
    var selectedCategory = Category()
    var deckArray:Array<Deck> = []
    var deckResultArray:Array<DeckResult> = []
    var deckResult = DeckResult()
    var deckQuestionAtPosition = 0
    
    var deckId:Int = 0
    var isPreviewPlay = false
    var outputvideofileURL:URL? = nil
    
    var isTimsUP = true
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.landscapeRight
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationCenter()
        setupCameraSession()
        startGamePlay()
    }
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForground), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        GoogleAnalyticsUtil.trackScreen(screenName: Constant.SCREEN_PLAY_GAME)
    }
    
    func didEnterForground() {
        print("didEnterForground")
        startGamePlay()
        restartCameraPreview()
    }
    
    func didEnterBackground() {
        print("didEnterBackground")
        stopGamePlay()
    }
    
    func startGamePlay() {
        isGameStarted = false
        upward = 0
        downward = 0
        middle = 0
        deckQuestionAtPosition = 0;
        count = Constant.count
        threeTwoOneCount = Constant.threeTwoOneCount
        timer = nil
        threeTwoOneTimer = nil
        deckId = selectedCategory.categoryId
        CommonUtil.disableSleep()
        wordLabel.text = "Place On \nForehead"
        timerLabel.text = ""
        setTeamPlay()
        setSelectedCategoryList(categoryId: deckId, isPreviewPlay: PreviewUtil.isPreviewPlay)
        setupAccelerometer()
    }
    
    func stopGamePlay() {
        threeTwoOneTimer?.invalidate()
        timer?.invalidate()
        motionManager.stopDeviceMotionUpdates()
        stopVideoRecording()
        CommonUtil.enableSleep()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        stopGamePlay()
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupAccelerometer() {
        
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
                            self.showNewWord()
                        }else {
                            if (PreviewUtil.isPreviewPlay){
                                self.deckQuestionAtPosition = 0;
                                self.showNewWord()
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
                    }
                }else if self.isTiltDownward(roll: rollAngle,pitch: pitchAngle){
                    if self.isGameStarted {
                        self.correct()
                    }
                }else if self.isTiltUpward(roll: rollAngle,pitch: pitchAngle){
                    if self.isGameStarted {
                        self.pass()
                    }
                }
            })
        }
    }
    
    func showNewWord() {
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
    }
    
    func correct() {
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
    
    func pass() {
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // get magnitude of vector via Pythagorean theorem
    func magnitudeFromAttitude(attitude: CMAttitude) -> Double {
        return sqrt(pow(attitude.roll, 2) + pow(attitude.yaw, 2) + pow(attitude.pitch, 2))
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        print("Play Game Controller view did disappear")
//        motionManager.stopAccelerometerUpdates()
//    }
    
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
                teamPlayLabel.text = ""
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
                playTimerLowSound(sound: "time_low_loop", ofType: "mp3")
            }
            
            if count / 100 >= 1 {
                timerLabel.text = "\(count / 100)"
//                print(count)
            }
            count -= 1
            
        }else {
            timer?.invalidate()
//            print(count)
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

//    Wrong
    func isTiltUpward(roll:Double,pitch:Double) -> Bool {
        
        if (((roll >= -30) && (pitch <= 25.0 && pitch >= -25.0)) && upward == 2){
            print("upward")
            return true
        }else {
            return false
        }
    }

//    Correct
    func isTiltDownward(roll:Double,pitch:Double) -> Bool {
        if (((roll <= -140) && (pitch <= 25.0 && pitch >= -25.0)) && downward == 2){
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
    
    func playTimerLowSound(sound: String, ofType: String) {
        avPlayerTimerLow = CommonUtil().playSound(sound: sound, ofType: ofType)
        if avPlayerTimerLow != nil {
            avPlayerTimerLow?.play()
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
            
            setupVideoRecordingOutputFile()
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
    
    func setupVideoRecordingOutputFile() {
        
//        checking camera permission
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == AVAuthorizationStatus.authorized {
            
            dataOutput = AVCaptureMovieFileOutput()
            let fileName = "sahipakdehai.mov"
            
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
            filePath = documentURl.appendingPathComponent(fileName)
    
        }
    }
    
    func startVideoRecording() {
        if dataOutput != nil && filePath != nil {
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
    
    func restartCameraPreview() {
        cameraSession.startRunning()
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
    
    @IBAction func backPlayGame(_ sender: AnyObject) {
        timer?.invalidate()
        threeTwoOneTimer?.invalidate()
        stopVideoRecording()
        motionManager.stopDeviceMotionUpdates()
        dismiss(animated: true, completion: nil)
    }
    
    func setSelectedCategoryList(categoryId:Int,isPreviewPlay:Bool)  {
//        if (let category == selectedCategory) {
        if categoryId >= 0 {
            let sqlite:SQLiteDatabase = SQLiteDatabase()
            
            deckArray = sqlite.getDecklist(categoryId: categoryId, isPreviewPlay: isPreviewPlay)
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
    
    func setTeamPlay() {
        if TeamPlayUtil.isTeamPlay{
            let text = "Round \(TeamPlayUtil.playingRound): Team \(TeamPlayUtil.playingTeam)"
            teamPlayLabel.text = text
        }else {
            teamPlayLabel.text = ""
        }
    }

}

