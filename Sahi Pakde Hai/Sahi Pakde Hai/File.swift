//
//  File.swift
//  Sahi Pakde Hai
//
//  Created by Dipti Fulwani on 24/06/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import UIKit

class CommonUtil{
    
    func moveToNextScreen(_ storyBoardIdentifire: String,senderViewController: UIViewController){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyBoard.instantiateViewController(withIdentifier: storyBoardIdentifire)
        senderViewController.present(destinationViewController, animated:true, completion:nil)
    }
}
