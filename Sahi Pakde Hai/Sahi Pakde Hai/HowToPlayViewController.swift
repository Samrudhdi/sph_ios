//
//  HowToPlayViewController.swift
//  Sahi Pakde Hai
//
//  Created by Dipti Fulwani on 27/06/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import UIKit

class HowToPlayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GoogleAnalyticsUtil().trackScreen(screenName: Constant.SCREEN_HELP)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func play(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }
}
