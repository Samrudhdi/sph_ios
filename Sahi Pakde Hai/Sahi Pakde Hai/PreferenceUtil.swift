//
//  PreferenceUtil.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 03/03/17.
//  Copyright © 2017 Patronous Inc. All rights reserved.
//

import Foundation

class PreferenceUtil {
    
    static func setPreference(value:Any, key:String) {
        let preference = UserDefaults.standard
        preference.set(value, forKey: key)
        preference.synchronize()
    }
    
    static func getBoolPref(key: String) -> Bool {
        let preference = UserDefaults.standard
        return (preference.bool(forKey: key))
    }
    
    static func getIntPref(key:String) -> Int {
        let preference = UserDefaults.standard
        return (preference.integer(forKey: key))
    }
    
    static func getStringPref(key: String) -> String {
        let preference = UserDefaults.standard
        if preference.string(forKey: key) != nil {
            return (preference.string(forKey: key))!
        }else {
            return ""
        }
    }
}
