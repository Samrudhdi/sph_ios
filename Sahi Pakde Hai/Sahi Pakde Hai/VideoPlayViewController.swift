//
//  VideoPlayViewController.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 31/01/17.
//  Copyright © 2017 Patronous Inc. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import FacebookShare
import FacebookLogin
import FacebookCore

class VideoPlayViewController: UIViewController{
    
    var videoURl:URL? = nil
    @IBOutlet weak var videoView: UIView!
    
    var count = 0
    var threeTwoOneCount = 0
    var timer:Timer? = nil
    var threeTwoOneTimer:Timer? = nil
    var questionAtPosition:Int = 0
    var player:AVPlayer?

    @IBOutlet weak var labelTop: UILabel!
    @IBOutlet weak var labelMiddle: UILabel!
    
    var deckResultArray:Array<DeckResult> = []
    
    let subView = UIView()
    let indicatorView = UIActivityIndicatorView()
    var selectedCategory = Category()
    
    let loginManger = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subView.frame = CGRect(x: 0, y: 0, width: self.videoView.frame.height, height: self.videoView.frame.width)
        setupPerviewLayer()
        setupNotificationCenter()
        // Do any additional setup after loading the view.
    }
    
    func setupPlayVideo()  {
        count = Constant.count
        threeTwoOneCount = Constant.threeTwoOneCount
        questionAtPosition = 0
        labelTop.text = ""
        labelMiddle.text = ""
        
        self.threeTwoOneTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.threeTwoOneCounter), userInfo: nil, repeats: true)
        
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    
    func stopVideoPlay() {
        player?.pause()
        threeTwoOneTimer?.invalidate()
        timer?.invalidate()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.landscapeRight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TAG:  viewWillAppear")
        setupPlayVideo()
        GoogleAnalyticsUtil.trackScreen(screenName: Constant.SCREEN_WATCH_VIDEO)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopVideoPlay()
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForground), name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    func didEnterForground() {
        print("didEnterForground")
        setupPlayVideo()
    }
    
    func didEnterBackground() {
        print("didEnterBackground")
        stopVideoPlay()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPerviewLayer() {
        if videoURl != nil {
            videoView.layoutIfNeeded()
            player = AVPlayer(url: videoURl!)
            let playerPreview = AVPlayerLayer(player: player)
            playerPreview.frame = CGRect(x: 0, y: 0, width: self.videoView.frame.height, height: self.videoView.frame.width)
            playerPreview.videoGravity = AVLayerVideoGravityResize
            self.videoView.layer.addSublayer(playerPreview)
        }
    }

    @IBAction func back(_ sender: AnyObject) {
        player?.pause()
        dismiss(animated: true, completion: nil)
        GoogleAnalyticsUtil.trackEvent(action: Constant.ACT_VIDEO_BACK, category: selectedCategory.categoryName, label: "")
    }
    
    
    @IBAction func saveVideo(_ sender: AnyObject) {
        checkVideoSavePermission()
        GoogleAnalyticsUtil.trackEvent(action: Constant.ACT_VIDEO_SAVE, category: self.selectedCategory.categoryName, label: "")
    }
    
    func checkVideoSavePermission() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            print("video: authorized")
            saveVideoToGallary()
            break
        case .notDetermined:
            print("video: notDetermined")
            PHPhotoLibrary.requestAuthorization({ granted in
                print("cam: request access")
                if granted == PHAuthorizationStatus.authorized {
                    self.saveVideoToGallary()
                    print("cam: permission authorized")
                }
            })
        case .denied:
            print("video: denied")
            showPermissionAlertMessage()
            break
        case .restricted:
            print("video: restricted")
            break
        }
    }
    
    func saveVideoToGallary() {
        
        print(PHPhotoLibrary.authorizationStatus())
        CommonUtil.showActivityIndicator(actInd: self.indicatorView, view: self.videoView, subView: self.subView)
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURl!)
        }){ saved, error in
            var title:String?
            if saved {
                title = "Your video was successfully saved"
            }else {
                title = error?.localizedDescription
            }
            let alertController = UIAlertController(title: title!, message: "", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: {
                CommonUtil.removeActivityIndicator(actInd: self.indicatorView, view: self.videoView, subView: self.subView)
            })
        }

    }
    
    @IBAction func shareOnFacebook(_ sender: AnyObject) {
        print("fb share")
        checkFacebookPublishPermission()
    }
    
    func shareFB() {
        let video = Video.init(url: videoURl!)
        let videoShareContent = VideoShareContent(video: video)
            let sharer = GraphSharer(content: videoShareContent)
        sharer.failsOnInvalidData = true
        sharer.message = "Had a great time playing \"Sahi Pakde Hai\"!\n#sahipakdehai #charades #partygame #bollywood\n\nGet this super fun charades app here\nhttps://play.google.com/store/apps/details?id=com.sahipakdehai"
        sharer.completion = {
            result in
            CommonUtil.removeActivityIndicator(actInd: self.indicatorView, view: self.view, subView: self.subView)
            switch result {
            case .cancelled:
                
                break
                
            case .failed(let error):
                print(error.localizedDescription)
                CommonUtil.showMessage(controller: self, title: error.localizedDescription, message: "")
                break

            case .success( _):
                CommonUtil.showMessage(controller: self, title: "Successfully video uploaded on Facebook", message: "")
                break
            }
        }
        
        do {
            print("Started facebook share")
             CommonUtil.showActivityIndicator(actInd: self.indicatorView, view: self.view, subView: self.subView)
            try sharer.share()
        }catch {
            print("Facebook Share Error"+error.localizedDescription)
            CommonUtil.removeActivityIndicator(actInd: self.indicatorView, view: self.view, subView: self.subView)
        }
        
    }
    
    func checkFacebookPublishPermission() {
        if AccessToken.current != nil {
            print("fb: access token not nil")
            shareFB()
        }else {
            print("fb: facebook login")
            loginManger.logIn([.publishActions], viewController: self, completion: {
                loginResult in
                switch loginResult {
                case .failed(let error):
                    print("fb: failed")
                    print(error)
                    
                case .cancelled:
                    print("fb: cancelled")
                    print("User cancelled login.")
                    
                case .success( _, _, _):
                    print("fb: success")
                    print("Logged in!")
                    self.shareFB()
                }
            
            })
        }
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
    
    func setDeviceOrientation() {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func showPermissionAlertMessage() {
        
        let message = NSLocalizedString(Constant.APP_NAME+" doesn't have permission to use the camera, please change privacy settings", comment: "Alert message when the user has denied access to the camera")
        let alertController = UIAlertController(title: Constant.APP_NAME, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .`default`, handler: { action in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
            }
        }))
        
        self.present(alertController, animated: true, completion: nil)
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
