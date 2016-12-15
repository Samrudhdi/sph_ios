//
//  File.swift
//  Sahi Pakde Hai
//
//  Created by Dipti Fulwani on 24/06/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//


import Foundation
import AVFoundation


class CommonUtil{
    
    static func playSound(sound:String,ofType:String) -> AVAudioPlayer {
        var categorySelectionSound:AVAudioPlayer? = nil
        let path = Bundle.main.path(forResource: sound, ofType:ofType)!
        let url = URL(fileURLWithPath: path)
        do {
            categorySelectionSound = try AVAudioPlayer(contentsOf: url)
        }catch {
            print("couldn't load file")
        }
        return categorySelectionSound!
    }

}
