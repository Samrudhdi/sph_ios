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
    var desc_1:String
    var desc_2:String
    
    init() {
        self.image = ""
        self.categoryId = 0
        self.backgroundColor = UIColor.black
        self.desc_1 = ""
        self.desc_2 = ""
    }
    
    
}
