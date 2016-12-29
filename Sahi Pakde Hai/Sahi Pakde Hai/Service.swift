//
//  service.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 26/12/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Service  {
    
    func getDeckData(url:String, actInd: UIActivityIndicatorView, view:UIView, subView: UIView, success: @escaping (Array<Deck>) -> Void, failure: @escaping (Error?) -> Void) {
        
        let myUrl = URL(string: url);
//        print(myUrl)
        var request = URLRequest(url:myUrl! as URL);
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
//            DispatchQueue.main.async {
//                CommonUtil.removeActivityIndicator(actInd: actInd, view: view, subView: subView)
//            }
//            
            if error != nil
            {
                DispatchQueue.main.async {
                    failure(error)
                }
                
                return
            }
            
            //            converting data into json object
            var dataString = String()
            dataString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            
            
//            let range = Range(uncheckedBounds: (lower: start, upper: end))
//            if dataString != nil {
                let start = dataString.range(of: "{")?.lowerBound
                let end = dataString.range(of: "}", options: String.CompareOptions.backwards, range: nil, locale: nil)?.upperBound
//                print(start)
//                print(end)
                let range = start!..<end!
                let result = dataString.substring(with: range)
//                print(result)
        
                let newData = result.data(using: .utf8)!
                let jsonResult = JSON(data: newData as Data)
//                print(jsonResult)
//                print(jsonResult["table"]["rows"].array)
                
                var decks:Array<Deck> = []
            
            let deckArray = jsonResult["table"]["rows"].array!
            deckArray.forEach({ (deck) in decks.append(Deck(json: deck))})
            
            DispatchQueue.main.async {
                success(decks)
            }
        }
        
        task.resume()
    }
}
