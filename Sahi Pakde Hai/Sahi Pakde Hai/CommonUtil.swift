//
//  File.swift
//  Sahi Pakde Hai
//
//  Created by Dipti Fulwani on 24/06/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//


import Foundation
import AVFoundation
import UIKit
import SystemConfiguration


class CommonUtil{
    
    func playSound(sound:String,ofType:String) -> AVAudioPlayer {
        var categorySelectionSound:AVAudioPlayer? = nil
        let path = Bundle.main.path(forResource: sound, ofType:ofType)!
        let url = URL(fileURLWithPath: path)
        do {
            categorySelectionSound = try AVAudioPlayer(contentsOf: url)
        }catch {
            print("couldn't load file")
        }
        return categorySelectionSound!
    }
    
    static func showActivityIndicator(actInd:UIActivityIndicatorView,view:UIView,subView:UIView){
        subView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/225.0, alpha: 0.5)
        actInd.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        actInd.center = view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = .whiteLarge
        actInd.color = Constant.whiteColor
        
        view.addSubview(subView)
        view.addSubview(actInd)
        view.isUserInteractionEnabled = true
        
        actInd.startAnimating()
    }
    
    static func removeActivityIndicator(actInd:UIActivityIndicatorView,view:UIView,subView:UIView){
        subView.removeFromSuperview()
        actInd.stopAnimating()
        actInd.isHidden = true
    }
    
    static func showMessage(controller: UIViewController, message: String){
//        let snackbar = TTGSnackbar.init(message: message, duration: .middle)
//        snackbar.backgroundColor = Constant.whiteColor
//        snackbar.messageTextColor = Constant.blackColor
        //        snackbar.messageTextFont = UIFont(name:"AppleSDGothicNeo-Regular", size: 17.0)!
//        snackbar.show()
        
        let alertController = UIAlertController(title: Constant.APP_NAME, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
    
    static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    static func getThumbnail(url:URL) -> UIImage? {
        
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(1), 100)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch let error{
           print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
        return nil
    }
    
    static func setLandscapeOrientation() {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    static func setPortraitOrientation() {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    static func disableSleep() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    static func enableSleep() {
        UIApplication.shared.isIdleTimerDisabled = false
    }

}



extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        //        let uicolor = UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}



extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}

extension UITableView {
    
    func tableViewScrollToBottom(animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
            }
        }
    }
}
