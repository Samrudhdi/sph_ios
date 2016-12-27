//
//  Deck.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 26/12/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Deck {
    var deckId:Int
    var word:String

    var deckType:Int
    
    init() {
        deckId = -1
        deckType = -1
        word = ""
    }
    
    init(json:JSON) {
        let columns = json["c"].array
        deckId = ((columns?[0].dictionary)?["v"]?.int)!
        word = ((columns?[1].dictionary)?["v"]?.string)!
        deckType = ((columns?[2].dictionary)?["v"]?.int)!
    }
}
