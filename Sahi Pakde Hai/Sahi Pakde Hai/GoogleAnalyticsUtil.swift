//
//  GoogleAnalyticsUtil.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 20/02/17.
//  Copyright © 2017 Patronous Inc. All rights reserved.
//

import Foundation

class GoogleAnalyticsUtil {
    
    static func trackScreen(screenName:String) {
        
        // The UA-XXXXX-Y tracker ID is loaded automatically from the
        // GoogleService-Info.plist by the `GGLContext` in the AppDelegate.
        // If you're copying this to an app just using Analytics, you'll
        // need to configure your tracking ID here.
        // [START screen_view_hit_swift]
        guard let tracker = GAI.sharedInstance().defaultTracker else { return
        }
        
        tracker.set(kGAIScreenName, value: screenName)
        
        guard let builder = GAIDictionaryBuilder.createScreenView()
        else {
            return
        }
        tracker.send(builder.build() as [NSObject : AnyObject])
        // [END screen_view_hit_swift]

    }
    
    static func trackEvent(action:String, category:String, label:String) {
        guard let tracker = GAI.sharedInstance().defaultTracker
        else {
            return
        }
        
        guard let builder = GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: label, value: nil)
        else {
            return
        }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    static func trackEcommerceView(productName: String, pid: String) {
        guard let tracker = GAI.sharedInstance().defaultTracker else {
            return
        }
        
        let product: GAIEcommerceProduct = GAIEcommerceProduct()
        product.setId(pid)
        product.setName(productName)
        product.setPrice(0.62)
        
        guard let builder = GAIDictionaryBuilder.createScreenView()
            else {
                return
        }

        builder.add(product)
        tracker.set(kGAIScreenName, value: Constant.E_COMMERCE)
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}
