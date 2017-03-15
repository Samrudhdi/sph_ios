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
import FBSDKShareKit
import FBSDKLoginKit
import FacebookShare

class VideoPlayViewController: UIViewController,FBSDKSharingDelegate{
    
    var videoURl:URL? = nil
    @IBOutlet weak var videoView: UIView!
    
    var count = Constant.count
    var threeTwoOneCount = Constant.threeTwoOneCount
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDeviceOrientation()
        returnedOrientation()
        subView.frame = CGRect(x: 0, y: 0, width: self.videoView.frame.height, height: self.videoView.frame.width)

        self.threeTwoOneTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.threeTwoOneCounter), userInfo: nil, repeats: true)
        
        playVideo()
        // Do any additional setup after loading the view.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.landscapeRight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GoogleAnalyticsUtil.trackScreen(screenName: Constant.SCREEN_WATCH_VIDEO)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playVideo() {
        if videoURl != nil {
            videoView.layoutIfNeeded()
            player = AVPlayer(url: videoURl!)
            let playerPreview = AVPlayerLayer(player: player)
            playerPreview.frame = CGRect(x: 0, y: 0, width: self.videoView.frame.height, height: self.videoView.frame.width)
            playerPreview.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.videoView.layer.addSublayer(playerPreview)
            player?.play()
        }
    }

    @IBAction func back(_ sender: AnyObject) {
        player?.pause()
        dismiss(animated: true, completion: nil)
        GoogleAnalyticsUtil.trackEvent(action: Constant.ACT_VIDEO_BACK, category: selectedCategory.categoryName, label: "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player?.pause()
    }
    
    @IBAction func saveVideo(_ sender: AnyObject) {
        saveVideoToGallary()
        GoogleAnalyticsUtil.trackEvent(action: Constant.ACT_VIDEO_SAVE, category: self.selectedCategory.categoryName, label: "")
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
        let videoContent = FBSDKShareVideoContent()
        videoContent.video = FBSDKShareVideo(videoURL: videoURl)
        let video = Video.init(url: videoURl!)
        let videoShareContent = VideoShareContent(video: video)
        //        let shareApi = FBSDKShareAPI()
//        shareApi.message = "Sharing..."
//        shareApi.shareContent = videoContent
//        shareApi.delegate = self
//        shareApi.share()
            let sharer = GraphSharer(content: videoShareContent)
        sharer.failsOnInvalidData = true
        sharer.completion = {
            result in
            print(result)
            print("facebook share result")
            CommonUtil.removeActivityIndicator(actInd: self.indicatorView, view: self.view, subView: self.subView)
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
        let action = "publish_actions"
        if FBSDKAccessToken.current() != nil && FBSDKAccessToken.current().hasGranted(action) {
            shareFB()
        }else {
            let loginManager = FBSDKLoginManager()
            loginManager.logIn(withPublishPermissions: ["publish_actions"], from: self, handler: { ( res:FBSDKLoginManagerLoginResult?, err:Error?) in
                if err == nil {
                    print(res)
                    if (res?.isCancelled)! {
                        print("cancelled")
                    }else if ((res?.declinedPermissions) != nil) {
                        print("declined")
                    }else if ((res?.grantedPermissions) != nil) {
                        print("granted")
                    }
                }else {
                    print(err.debugDescription)
                }
            })
        }
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("fail with error")
        print(error.localizedDescription)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("cancel")
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("sharing is done");
        print(results.debugDescription)
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
    
    func returnedOrientation() -> AVCaptureVideoOrientation {
        var videoOrientation: AVCaptureVideoOrientation!
        let orientation = UIDevice.current.orientation
        
        switch orientation {
        case .portrait:
            videoOrientation = .portrait
            PreferenceUtil.setPreference(value: 0, key: "CaptureVideoOrientation")
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
            PreferenceUtil.setPreference(value: 1, key: "CaptureVideoOrientation")
        case .landscapeLeft:
            videoOrientation = .landscapeRight
            PreferenceUtil.setPreference(value: 2, key: "CaptureVideoOrientation")
        case .landscapeRight:
            videoOrientation = .landscapeLeft
            PreferenceUtil.setPreference(value: 3, key: "CaptureVideoOrientation")
        case .faceDown, .faceUp, .unknown:
            let digit = PreferenceUtil.getIntPref(key: "CaptureVideoOrientation")
            videoOrientation = AVCaptureVideoOrientation.init(rawValue: digit)
        }
        return videoOrientation
    }
    
    func setDeviceOrientation() {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
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
