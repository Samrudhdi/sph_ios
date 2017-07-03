//
//  FacebookAnalytics.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 08/05/17.
//  Copyright © 2017 Patronous Inc. All rights reserved.
//

import Foundation
import OneSignal

class MyNotification {
    
    static func trackEvent(category: String, action: String){
        OneSignal.sendTag(category, value: action)
    }
}
