//
//  Category.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 14/12/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import Foundation
import UIKit

struct Category {
    var image:String
    var backgroundColor:UIColor
    var categoryId:Int
    var desc:String
    var isPaid:Bool
    
    init() {
        self.image = ""
        self.categoryId = 0
        self.backgroundColor = UIColor.black
        self.desc = ""
        self.isPaid = false
    }
    
    
}
