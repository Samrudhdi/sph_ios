//
//  CategorySelectionViewController.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 06/12/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import UIKit
import AVFoundation

class CategorySelectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var shareButton: UIButton!

    @IBOutlet weak var teamPlayButton: UIButton!
    
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    let numberOfCell:CGFloat = 2
    var margin:CGFloat = 20.0
    
    var selectedCategory:Category? = nil
    var categoryArray:Array<Category> = []
    var categorySelectionSound:AVAudioPlayer!
    
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
        performSegue(withIdentifier: "HelpViewController", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategory = categoryArray[indexPath.row]
        
        categorySelectionSound = CommonUtil.playSound(sound: "select_category", ofType: "mp3")
        if categorySelectionSound != nil {
            categorySelectionSound.play()
        }
        
        
//        if self.storyboard?.instantiateViewController(withIdentifier: "DESCRIPTION_VIEW") is DescriptionViewController {
//            
//            let controller = self.storyboard?.instantiateViewController(withIdentifier: "DESCRIPTION_VIEW") as! DescriptionViewController
//            
//            controller.selecteCategory = self.selectedCategory!
//            
//            present(controller, animated: true, completion: {})
//        }
        
        performSegue(withIdentifier: "DescriptionViewController", sender: self)
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
