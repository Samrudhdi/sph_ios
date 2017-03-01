//
//  CategorySelectionViewController.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 06/12/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import UIKit
import AVFoundation

class CategorySelectionViewController: BaseUIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var shareButton: UIButton!

    @IBOutlet weak var teamPlayButton: UIButton!
    
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    let numberOfCell:CGFloat = 2
    var margin:CGFloat = 20.0
    
    var selectedCategory:Category? = nil
    var categoryArray:Array<Category> = []
    var categorySelectionSound:AVAudioPlayer!
    let indicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCategoryList()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeBottomButtonIcons()
        GoogleAnalyticsUtil().trackScreen(screenName: Constant.SCREEN_CATEGORY_PAGE)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.categoryImageView.image = UIImage.init(named: categoryArray[indexPath.row].image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let halfWidth = collectionView.frame.size.width / numberOfCell
        return CGSize(width:  (halfWidth - (margin * 2)), height: (halfWidth - (margin * 2)))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let frame : CGRect = self.view.frame
//        margin  = (frame.width - 90 * 2) / 5.0
        
//        print("margin == \(margin)")
        return UIEdgeInsetsMake(0, margin, 0, margin)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategory = categoryArray[indexPath.row]
        
        categorySelectionSound = CommonUtil().playSound(sound: "select_category", ofType: "mp3")
        if categorySelectionSound != nil {
            categorySelectionSound.play()
        }
        goToDescriptionScreen()
//        perform(#selector(goToDescriptionScreen), with: nil, afterDelay: 0.5)
        
    }
    
    func goToDescriptionScreen() {
        if self.storyboard?.instantiateViewController(withIdentifier: "DESCRIPTION_VIEW") is DescriptionViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "DESCRIPTION_VIEW") as! DescriptionViewController
            
            controller.selecteCategory = self.selectedCategory!
            
            present(controller, animated: true, completion: {})
        }
    }

    func setCategoryList(){
        
        var cinemaCat = Category()
        cinemaCat.categoryId = 1
        cinemaCat.backgroundColor = Constant.bg_cinema
        cinemaCat.image = "cinema"
        cinemaCat.desc = Constant.cinema_desc
        cinemaCat.isPaid = false
        cinemaCat.categoryName = Constant.CAT_CINEMA
        
        var lightCameraActionCat = Category()
        lightCameraActionCat.categoryId = 2
        lightCameraActionCat.backgroundColor = Constant.bg_light_camera_action
        lightCameraActionCat.image = "light_camera_action"
        lightCameraActionCat.desc = Constant.light_camera_action_desc
        lightCameraActionCat.isPaid = false
        lightCameraActionCat.categoryName = Constant.CAT_LIGHT_CAMERA_ACTION
        
        var hindi = Category()
        hindi.categoryId = 3
        hindi.backgroundColor = Constant.bg_sirf_hindi
        hindi.image = "hindi"
        hindi.desc = Constant.hindi_desc
        hindi.isPaid = false
        hindi.categoryName = Constant.CAT_SIRF_HINDI_ME_BOL
        
        var heroHeroine = Category()
        heroHeroine.categoryId = 4
        heroHeroine.backgroundColor = Constant.bg_hero_heroine
        heroHeroine.image = "hero_heroine"
        heroHeroine.desc = Constant.hh_desc
        heroHeroine.isPaid = false
        heroHeroine.categoryName = Constant.CAT_HERO_HEROINE
        
        var adultOnly = Category()
        adultOnly.categoryId = 5
        adultOnly.backgroundColor = Constant.bg_adult_only
        adultOnly.image = "icon_adults"
        adultOnly.desc = Constant.ao_desc
        adultOnly.isPaid = true
        adultOnly.categoryName = Constant.CAT_ADULTS_ONLY

        var hollywood = Category()
        hollywood.categoryId = 6
        hollywood.backgroundColor = Constant.bg_hollywood
        hollywood.image = "hollywood"
        hollywood.desc = Constant.hollywood_desc
        hollywood.isPaid = false
        hollywood.categoryName = Constant.CAT_HOLLYWOOD
        
        var cricket = Category()
        cricket.categoryId = 7
        cricket.backgroundColor = Constant.bg_cricket
        cricket.image = "cricket"
        cricket.desc = Constant.cricket_desc
        cricket.isPaid = true
        cricket.categoryName = Constant.CAT_CRICKET

        var songs = Category()
        songs.categoryId = 8
        songs.backgroundColor = Constant.bg_songs
        songs.image = "songs"
        songs.desc = Constant.songs_desc
        songs.isPaid = true
        songs.categoryName = Constant.CAT_SONGS
        
        
        var mythology = Category()
        mythology.categoryId = 9
        mythology.backgroundColor = Constant.bg_mythology
        mythology.image = "mythology"
        mythology.desc = Constant.mythology_desc
        mythology.isPaid = false
        mythology.categoryName = Constant.CAT_MYTHOLOGY

        
        var gameOfThrones = Category()
        gameOfThrones.categoryId = 10
        gameOfThrones.backgroundColor = Constant.bg_got
        gameOfThrones.image = "game_of_thrones"
        gameOfThrones.desc = Constant.got_desc
        gameOfThrones.isPaid = true
        gameOfThrones.categoryName = Constant.CAT_GAME_OF_THRONES
        
        var kidsZone = Category()
        kidsZone.categoryId = 11
        kidsZone.backgroundColor = Constant.bg_kids_zone
        kidsZone.image = "kid_zone"
        kidsZone.desc = Constant.kz_desc
        kidsZone.isPaid = true
        kidsZone.categoryName = Constant.CAT_KIDS_ZONES
        
        var khaanPaan = Category()
        khaanPaan.categoryId = 12
        khaanPaan.backgroundColor = Constant.bg_khaan_paan
        khaanPaan.image = "khaan_paan"
        khaanPaan.desc = Constant.kp_desc
        khaanPaan.isPaid = false
        khaanPaan.categoryName = Constant.CAT_KHAAN_PAAN

        
        categoryArray.append(cinemaCat)
        categoryArray.append(lightCameraActionCat)
        categoryArray.append(hindi)
        categoryArray.append(heroHeroine)
        categoryArray.append(adultOnly)
        categoryArray.append(hollywood)
        
        categoryArray.append(cricket)
        categoryArray.append(songs)
        categoryArray.append(mythology)
        categoryArray.append(gameOfThrones)
        categoryArray.append(kidsZone)
        categoryArray.append(khaanPaan)
        self.collectionView.reloadData()
        
    }

    @IBAction func goToHelp(_ sender: AnyObject) {
        if TeamPlayUtil.isTeamPlay {
            TeamPlayUtil.setIsTeamPlay(isTeamPlay: false)
            changeBottomButtonIcons()
        }else {
            showHelpScreen()
        }
    }
    
    @IBAction func shareAppLink(_ sender: AnyObject) {
        if TeamPlayUtil.isTeamPlay {
            dismissCategoryViewController()
        }else {
//            shareLink()
        }

    }
    
    @IBAction func goToTeamPlay(_ sender: AnyObject) {
        if TeamPlayUtil.isTeamPlay {
            dismissCategoryViewController()
        }else {
            showTeamPlay()
        }
    }
    
    func changeBottomButtonIcons() {
        if TeamPlayUtil.isTeamPlay {
            teamPlayButton.setImage(UIImage(named: "team_mode_on"), for: .normal)
            shareButton.setImage(UIImage(named: "back_team_play"), for: .normal)
            helpButton.setImage(UIImage(named: "cancel_team_play"), for: .normal)
        }else {
            shareButton.setImage(UIImage(named: "share"), for: .normal)
            teamPlayButton.setImage(UIImage(named: "team"), for: .normal)
            helpButton.setImage(UIImage(named: "que"), for: .normal)
        }
    }
   
    func showTeamPlay() {
        if self.storyboard?.instantiateViewController(withIdentifier: "TEAM_PLAY") is TeamPlayViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "TEAM_PLAY") as! TeamPlayViewController
            
            present(controller, animated: true, completion: {})
        }
    }
    
    func showHelpScreen() {
        if self.storyboard?.instantiateViewController(withIdentifier: "HOW_TO_PLAY_VIEW") is HowToPlayViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "HOW_TO_PLAY_VIEW") as! HowToPlayViewController
            present(controller, animated: true, completion: {})
        }

    }
    
    func shareLink() {
        let shareText = "Sahi Pakde Hai!\nGet this super fun charades app right now! Full of masti and entertainment with a special desi touch.\nhttps://play.google.com/store/apps/details?id=com.sahipakdehai"
        
        var contentArray:Array<String> = []
        contentArray.append(shareText)
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: contentArray, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)

    }
    
    func dismissCategoryViewController() {
        dismiss(animated: true, completion: nil)
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
