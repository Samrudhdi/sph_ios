//
//  PreferenceUtil.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 03/03/17.
//  Copyright © 2017 Patronous Inc. All rights reserved.
//

import Foundation

class PreferenceUtil {
    var preference:UserDefaults? = nil
    
    init() {
        preference = UserDefaults.standard
    }
    
    func setPreference(value:Any, key:String) {
        self.preference?.set(value, forKey: key)
        let didSave = self.preference?.synchronize()
        if !didSave! {
            print("preference not set")
        }else {
            print("preference set")
        }
    }
    
    func getBoolPref(key: String) -> Bool {
        return (self.preference?.bool(forKey: key))!
    }
    
    func getIntPref(key:String) -> Int {
        return (self.preference?.integer(forKey: key))!
    }
    
    func getStringPref(key: String) -> String {
        if self.preference?.string(forKey: key) != nil {
            return (self.preference?.string(forKey: key))!
        }else {
            return ""
        }
    }
}
