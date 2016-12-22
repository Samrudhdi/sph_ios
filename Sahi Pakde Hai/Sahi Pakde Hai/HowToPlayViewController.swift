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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func play(_ sender: AnyObject) {
//        self.dismiss(animated: true, completion: {})
        self.navigationController?.popViewController(animated: true)
    }
}
