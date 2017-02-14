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
        self.navigationController?.isNavigationBarHidden = true
        
        setCategoryList()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        var lightCameraActionCat = Category()
        lightCameraActionCat.categoryId = 2
        lightCameraActionCat.backgroundColor = Constant.bg_light_camera_action
        lightCameraActionCat.image = "light_camera_action"
        lightCameraActionCat.desc = Constant.light_camera_action_desc
        lightCameraActionCat.isPaid = false
        
        var hindi = Category()
        hindi.categoryId = 3
        hindi.backgroundColor = Constant.bg_sirf_hindi
        hindi.image = "hindi"
        hindi.desc = Constant.hindi_desc
        hindi.isPaid = false
        
        var heroHeroine = Category()
        heroHeroine.categoryId = 4
        heroHeroine.backgroundColor = Constant.bg_hero_heroine
        heroHeroine.image = "hero_heroine"
        heroHeroine.desc = Constant.hh_desc
        heroHeroine.isPaid = false
        
        var adultOnly = Category()
        adultOnly.categoryId = 5
        adultOnly.backgroundColor = Constant.bg_adult_only
        adultOnly.image = "icon_adults"
        adultOnly.desc = Constant.ao_desc
        adultOnly.isPaid = true

        var hollywood = Category()
        hollywood.categoryId = 6
        hollywood.backgroundColor = Constant.bg_hollywood
        hollywood.image = "hollywood"
        hollywood.desc = Constant.hollywood_desc
        hollywood.isPaid = false
        
        var cricket = Category()
        cricket.categoryId = 7
        cricket.backgroundColor = Constant.bg_cricket
        cricket.image = "cricket"
        cricket.desc = Constant.cricket_desc
        cricket.isPaid = true

        var songs = Category()
        songs.categoryId = 8
        songs.backgroundColor = Constant.bg_songs
        songs.image = "songs"
        songs.desc = Constant.songs_desc
        songs.isPaid = true
        
        
        var mythology = Category()
        mythology.categoryId = 9
        mythology.backgroundColor = Constant.bg_mythology
        mythology.image = "mythology"
        mythology.desc = Constant.mythology_desc
        mythology.isPaid = false

        
        var gameOfThrones = Category()
        gameOfThrones.categoryId = 10
        gameOfThrones.backgroundColor = Constant.bg_got
        gameOfThrones.image = "game_of_thrones"
        gameOfThrones.desc = Constant.got_desc
        gameOfThrones.isPaid = true
        
        var kidsZone = Category()
        kidsZone.categoryId = 11
        kidsZone.backgroundColor = Constant.bg_kids_zone
        kidsZone.image = "kid_zone"
        kidsZone.desc = Constant.kz_desc
        kidsZone.isPaid = true
        
        var khaanPaan = Category()
        khaanPaan.categoryId = 12
        khaanPaan.backgroundColor = Constant.bg_khaan_paan
        khaanPaan.image = "khaan_paan"
        khaanPaan.desc = Constant.kp_desc
        khaanPaan.isPaid = false

        
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
        
    }

    @IBAction func goToHelp(_ sender: AnyObject) {
        
        
        if self.storyboard?.instantiateViewController(withIdentifier: "HOW_TO_PLAY_VIEW") is HowToPlayViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "HOW_TO_PLAY_VIEW") as! HowToPlayViewController
            
//            controller.selecteCategory = self.selectedCategory!
            
            present(controller, animated: true, completion: {})
        }

//        performSegue(withIdentifier: "HelpViewController", sender: self)
    }
    
    @IBAction func shareAppLink(_ sender: AnyObject) {
        let shareText = "Sahi Pakde Hai!\nGet this super fun charades app right now! Full of masti and entertainment with a special desi touch.\nhttps://play.google.com/store/apps/details?id=com.sahipakdehai"
        
//        var contentArray:Array<String> = []
//        contentArray.append(shareText)
//        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: contentArray, applicationActivities: nil)
//        present(activityViewController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DescriptionViewController" {
            let descriptionController = segue.destination as! DescriptionViewController
            descriptionController.selecteCategory = self.selectedCategory!
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
