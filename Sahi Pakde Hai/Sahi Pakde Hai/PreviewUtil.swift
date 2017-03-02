//
//  PreviewUtility.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 22/02/17.
//  Copyright © 2017 Patronous Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

class PreviewUtil{
    
    static var isPreviewPlay:Bool = false
    

    static var previewJson: JSON = [
            "5":["Balls","Belly Dancer","Bikini","Boob Job","Brazilian Wax","Climax","Condoms","Doggie Style","Emraan Hashmi","Orgy","Push Up Bra","Skinny Dipping","Spanking","Sunny Leone","Tongue"
            ],
            
           "6": ["Garden State","Ghost","Giorgio Armani","Gladiator","Goldie Hawn","Horrible Bosses","Inception","Indiana Jones","J K Rowling","Top Gun"
            ],
           
           "7": ["Ashes","Bouncer","Doosra","First Slip","Helmet","Kolkata Knight Riders","Muttiah Muralidharan","Pads","Point","Ricky Ponting","Royal Challengers Bangalore","Sachin Tendulkar","Virat Kohli","Wicket Keeper","Yorker"
            ],
           
           "8": ["Ainvehi Ainvehi","Baby Doll","Bhaiya Mere Rakhi Ke Bandhan Ko Nibhana","Bole Chudiyan","Chaiyya Chaiyya","Char Botal Vodka","Choli Ke Peeche Kya Hai","Dhating Naach","Dola Re Dola","Jai Ho","Koi Kahe Kehta Rahe","Rang Barse","Selfie Le Le Re","Singham","Tere Mast Mast Do Nain"
            ],
           
           "10": ["A Song Of Ice and Fire","Casterly Rock","Direwolf","Dothraki","George R R Martin","Hodor","Peter Dinklage","Ramsay Bolton","Sansa Stark","Theon Greyjoy","White Walkers","Winterfell","Needle","Joffrey Baratheon","Twins"
            ],
           
           "11": ["Alphabets","Barbie","Batman","Birthday","Calculator","Chhota Bheem","Clown","Daya Ben","Doraemon","Finding Nemo","Ludo","Pirate","Shin Chan","Skipping Rope","Tom & Jerry"
            ]
        ]
    
    static func getCategoryJson(categoryId:String) -> [JSON]{
        return PreviewUtil.previewJson[categoryId].array!
    }
}
