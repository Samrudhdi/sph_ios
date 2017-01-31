//
//  CategorySelectionViewController.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 06/12/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import UIKit
import AVFoundation
import Async

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
        loadData()
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
    
    
    func setCategoryList(){
        
        var cinemaCat = Category()
        cinemaCat.categoryId = 1
        cinemaCat.backgroundColor = Constant.bg_cinema
        cinemaCat.image = "cinema"
        cinemaCat.desc_1 = "afsadfdsaf asdfsdaf asdfdsafds adfas sadfsdf adsfsaf"
        cinemaCat.desc_2 = "afadfa asdfsadf dsafasdf dfsafsafadfasdf asdfsadf asadfaf a sda"
        
        var lightCameraActionCat = Category()
        lightCameraActionCat.categoryId = 2
        lightCameraActionCat.backgroundColor = Constant.bg_light_camera_action
        lightCameraActionCat.image = "light_camera_action"
        lightCameraActionCat.desc_1 = "afsadfdsaf asdfsdaf asdfdsafds adfas sadfsdf adsfsaf"
        lightCameraActionCat.desc_2 = "afadfa asdfsadf dsafasdf dfsafsafadfasdf asdfsadf asadfaf a sda"
        
        categoryArray.append(cinemaCat)
        categoryArray.append(lightCameraActionCat)
        categoryArray.append(cinemaCat)
        categoryArray.append(lightCameraActionCat)
        categoryArray.append(cinemaCat)
        categoryArray.append(lightCameraActionCat)
        
    }

    @IBAction func goToHelp(_ sender: AnyObject) {
        
        
        if self.storyboard?.instantiateViewController(withIdentifier: "HOW_TO_PLAY_VIEW") is HowToPlayViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "HOW_TO_PLAY_VIEW") as! HowToPlayViewController
            
//            controller.selecteCategory = self.selectedCategory!
            
            present(controller, animated: true, completion: {})
        }

//        performSegue(withIdentifier: "HelpViewController", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategory = categoryArray[indexPath.row]
        
        categorySelectionSound = CommonUtil().playSound(sound: "select_category", ofType: "mp3")
        if categorySelectionSound != nil {
            categorySelectionSound.play()
        }
        
        
        if self.storyboard?.instantiateViewController(withIdentifier: "DESCRIPTION_VIEW") is DescriptionViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "DESCRIPTION_VIEW") as! DescriptionViewController
            
            controller.selecteCategory = self.selectedCategory!
            
            present(controller, animated: true, completion: {})
        }
        
//        performSegue(withIdentifier: "DescriptionViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DescriptionViewController" {
            let descriptionController = segue.destination as! DescriptionViewController
            descriptionController.selecteCategory = self.selectedCategory!
        }
    }
    
    func loadData() {
        if CommonUtil.isInternetAvailable() {
            CommonUtil.showActivityIndicator(actInd: indicatorView, view: self.view, subView: super.subView)
            let url = "https://spreadsheets.google.com/tq?key=1RqjjkDkY4g2HfHDINt-Xxfv-QJsuLDOEQVW-D94-Km8"
            Service().getDeckData(url: url, actInd: indicatorView, view: self.view, subView: super.subView, success: successCallBack, failure: failureCallBack)
        }else {
            let preference = UserDefaults.standard
            if !preference.bool(forKey: Constant.FIRST_TIME_DATA_LOAD){
                CommonUtil.showMessageOnSnackbar(message: "No Internet Access")
            }
        }
//        let data = Service().getJSON(urlToRequest: url)
        
    }

    func successCallBack(decks:Array<Deck>) {
        storeDeckData(decks: decks)
        CommonUtil.removeActivityIndicator(actInd: indicatorView, view: self.view, subView: super.subView)
    }
    
    func failureCallBack(error: Error?) {
        CommonUtil.removeActivityIndicator(actInd: indicatorView, view: self.view, subView: super.subView)
        CommonUtil.showMessageOnSnackbar(message: error.debugDescription)
    }
    
    func storeDeckData(decks:Array<Deck>){
        let deck = decks[0];
        let updateFlag = deck.word
        print(updateFlag)
        let updateVersionCode = deck.deckType
        print(updateVersionCode)
        
        // Reading data from preference
        let preference = UserDefaults.standard
//        if preference.object(forKey: Constant.UPDATE_VERSION_CODE) != nil {
        let storedVersion = preference.integer(forKey: Constant.UPDATE_VERSION_CODE)
        if updateVersionCode > storedVersion{
            let prefere = UserDefaults.standard
            insertDataOnDatabase(decks: decks)
            prefere.set(updateVersionCode, forKey: Constant.UPDATE_VERSION_CODE)
            prefere.set(true, forKey: Constant.FIRST_TIME_DATA_LOAD)
//                prefere.in
            let didSave = prefere.synchronize()
            if !didSave {
                print("preference not set")
            }else {
                print("preference set")
            }
        }
    }
    
    func insertDataOnDatabase(decks:Array<Deck>){
        
//        let group = AsyncGroup()
//        group.background {
            let sqliteDatabase:SQLiteDatabase = SQLiteDatabase()
            let isReCreatedTable = sqliteDatabase.reCreateTable()
            if isReCreatedTable {
                let isInserted = sqliteDatabase.insertData(deckArray: decks)
                if isInserted {
                    print("Data inserted successfully")
                }else {
                    print("Data not inserted")
                }
            }else {
                print("Unable to insert data in table")
            }
//        }
//        group.wait()

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
