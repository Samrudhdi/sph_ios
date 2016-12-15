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
    @IBOutlet weak var desc_1: UILabel!
    @IBOutlet weak var desc_2: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var selecteCategory = Category()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor? = UIColor.init(ciColor: CIColor.init(string: selecteCategory.backgroundColor))
        self.selectedCategoryImage.image = UIImage.init(named: selecteCategory.image)
        self.desc_1.text = selecteCategory.desc_1
        self.desc_2.text = selecteCategory.desc_2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Back button
    @IBAction func moveBAck(_ sender: AnyObject) {
       self.navigationController?.popViewController(animated: true)
    }

    @IBAction func playGame(_ sender: AnyObject) {
        performSegue(withIdentifier: "PlayGameViewController", sender: self)
    }
    
}
