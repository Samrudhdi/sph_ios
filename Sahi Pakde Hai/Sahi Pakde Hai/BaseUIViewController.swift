//
//  BaseUIViewController.swift
//  AugerTorque
//
//  Created by Rahul Raja on 15/10/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import Foundation
import UIKit

class BaseUIViewController: UIViewController {
    
    let subView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
