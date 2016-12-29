//
//  DeckResult.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 28/12/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DeckResult {
    var word:String
    var isCorrect:Bool
    var questionAskedTime:Int
    var questionAnsweredTime:Int
    var deckId:Int
    
    init() {
        deckId = -1
        word = ""
        isCorrect = false
        questionAskedTime = -1
        questionAnsweredTime = -1
        deckId = -1
    }
}
