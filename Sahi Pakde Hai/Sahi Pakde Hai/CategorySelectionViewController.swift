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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cinemaCat.desc_1 = Constant.cinema_desc_1
        cinemaCat.desc_2 = Constant.cinema_desc_2
        
        var lightCameraActionCat = Category()
        lightCameraActionCat.categoryId = 2
        lightCameraActionCat.backgroundColor = Constant.bg_light_camera_action
        lightCameraActionCat.image = "light_camera_action"
        lightCameraActionCat.desc_1 = Constant.light_camera_action_desc_1
        lightCameraActionCat.desc_2 = Constant.light_camera_action_desc_2
        
        var hindi = Category()
        hindi.categoryId = 3
        hindi.backgroundColor = Constant.bg_sirf_hindi
        hindi.image = "hindi"
        hindi.desc_1 = Constant.hindi_desc_1
        hindi.desc_2 = Constant.hindi_desc_2
        
        var heroHeroine = Category()
        heroHeroine.categoryId = 4
        heroHeroine.backgroundColor = Constant.bg_hero_heroine
        heroHeroine.image = "hero_heroine"
        heroHeroine.desc_1 = Constant.hh_desc_1
        heroHeroine.desc_2 = Constant.hh_desc_2
        
        var adultOnly = Category()
        adultOnly.categoryId = 5
        adultOnly.backgroundColor = Constant.bg_adult_only
        adultOnly.image = "icon_adults"
        adultOnly.desc_1 = Constant.ao_desc_1
        adultOnly.desc_2 = Constant.ao_desc_2

        
        var hollywood = Category()
        hollywood.categoryId = 6
        hollywood.backgroundColor = Constant.bg_hollywood
        hollywood.image = "hollywood"
        hollywood.desc_1 = Constant.hollywood_desc_1
        hollywood.desc_2 = Constant.hollywood_desc_2

        
        var cricket = Category()
        cricket.categoryId = 7
        cricket.backgroundColor = Constant.bg_cricket
        cricket.image = "cricket"
        cricket.desc_1 = Constant.cricket_desc_1
        cricket.desc_2 = Constant.cricket_desc_2

        
        var songs = Category()
        songs.categoryId = 8
        songs.backgroundColor = Constant.bg_songs
        songs.image = "songs"
        songs.desc_1 = Constant.songs_desc_1
        songs.desc_2 = Constant.songs_desc_2

        
        var mythology = Category()
        mythology.categoryId = 9
        mythology.backgroundColor = Constant.bg_mythology
        mythology.image = "mythology"
        mythology.desc_1 = Constant.mythology_desc_1
        mythology.desc_2 = Constant.mythology_desc_2

        
        var gameOfThrones = Category()
        gameOfThrones.categoryId = 10
        gameOfThrones.backgroundColor = Constant.bg_got
        gameOfThrones.image = "game_of_thrones"
        gameOfThrones.desc_1 = Constant.got_desc_1
        gameOfThrones.desc_2 = Constant.got_desc_2

        
        var kidsZone = Category()
        kidsZone.categoryId = 11
        kidsZone.backgroundColor = Constant.bg_kids_zone
        kidsZone.image = "kid_zone"
        kidsZone.desc_1 = Constant.kz_desc_1
        kidsZone.desc_2 = Constant.kz_desc_2
        
        var khaanPaan = Category()
        khaanPaan.categoryId = 12
        khaanPaan.backgroundColor = Constant.bg_khaan_paan
        khaanPaan.image = "khaan_paan"
        khaanPaan.desc_1 = Constant.kp_desc_1
        khaanPaan.desc_2 = Constant.kp_desc_2

        
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
        
        var contentArray:Array<String> = []
        contentArray.append(shareText)
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
