//
//  DescriptionViewController.swift
//  Sahi Pakde Hai
//
//  Created by Dipti Fulwani on 24/06/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var selectedCategoryImage: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    
    var selecteCategory = Category()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor? = selecteCategory.backgroundColor
        self.selectedCategoryImage.image = UIImage.init(named: selecteCategory.image)
        self.desc.text = selecteCategory.desc
        if selecteCategory.isPaid {
            previewButton.isHidden = false
        }else{
            previewButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GoogleAnalyticsUtil().trackScreen(screenName: Constant.SCREEN_DESCRIPTION)
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

    // Back button
    @IBAction func moveBAck(_ sender: AnyObject) {
        GoogleAnalyticsUtil().trackEvent(action: Constant.ACT_BACK, category: self.selecteCategory.categoryName, label: "")
        self.dismiss(animated: true, completion: {})
    }

    @IBAction func playGame(_ sender: AnyObject) {
        
        GoogleAnalyticsUtil().trackEvent(action: Constant.ACT_PLAY, category: self.selecteCategory.categoryName, label: "")
        setTeamPlayRound()
        goToGamePlayController()
    }
    
    func setTeamPlayRound() {
        if TeamPlayUtil.isTeamPlay {
            TeamPlayUtil.playingRound = 1
            TeamPlayUtil.playingTeam = 1
        }
    }
    
    func goToGamePlayController() {
        if self.storyboard?.instantiateViewController(withIdentifier: "PLAY_GAME_VIEW") is PlayGameViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "PLAY_GAME_VIEW") as! PlayGameViewController
            controller.selectedCategory = self.selecteCategory
            present(controller, animated: true, completion: {})
        }

    }
    
    @IBAction func previewPlay(_ sender: AnyObject) {
        GoogleAnalyticsUtil().trackEvent(action: Constant.ACT_PREVIEW, category: self.selecteCategory.categoryName, label: "")
    }
}
