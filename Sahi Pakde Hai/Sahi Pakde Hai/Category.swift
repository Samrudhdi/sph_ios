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
    
    var categoryId:Int
    var categoryName:String
    var image:String
    var backgroundColor:UIColor
    var desc:String
    var isPaid:Bool
    
    init() {
        self.categoryName = ""
        self.categoryId = 0
        self.image = ""
        self.backgroundColor = UIColor.black
        self.desc = ""
        self.isPaid = false
    }
    
    
}
