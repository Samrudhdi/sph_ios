//
//  DescriptionViewController.swift
//  Sahi Pakde Hai
//
//  Created by Dipti Fulwani on 24/06/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
