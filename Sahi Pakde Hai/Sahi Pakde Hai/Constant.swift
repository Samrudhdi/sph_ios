//
//  Constant.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 14/12/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//


import Foundation
import UIKit

class Constant{
    
    
    
    // :mixpanel
    static let MIXPANEL_TOKEN = "1f2c9bed7dcc2da97538e51b5d7e0c7d"
    static let MIXPANEL_API_KEY = "fd2bf720e7e996f24f083bb617a15d8f"
    static let MIXPANEL_API_SECRET = "737845a7f49ead75635cf608f21eaf1a"
    
    
    // video file name
    static let FILE_NAME = "sahipakdehai.mov"
    
    
    // App Name
    static let APP_NAME = "Sahi Pakde Hai"
    
    // SKU
    static let SKU_ADULTS_ONLY = "com.patronous.sahipakdehai.adults_only"
    static let SKU_CRICKET = "com.patronous.sahipakdehai.cricket"
    static let SKU_GOT = "com.patronous.sahipakdehai.game_of_thrones"
    static let SKU_KIDS_ZONE = "com.patronous.sahipakdehai.kids_zone"
    static let SKU_SONGS = "com.patronous.sahipakdehai.songs"
    static let PURCHASED = "purchased"
    
    static let productIdentifiers: Set<String> = [Constant.SKU_ADULTS_ONLY,Constant.SKU_CRICKET,Constant.SKU_SONGS,Constant.SKU_GOT,Constant.SKU_KIDS_ZONE]
    
    
    // Timer count
    static let count = 6000//6000
    static let threeTwoOneCount = 5
    
    // Google Analytics
    
    // Screen name
    static let SCREEN_CATEGORY_PAGE = "Category Page"
    static let SCREEN_DESCRIPTION = "Description Page"
    static let SCREEN_HELP = "Help Screen"
    static let SCREEN_PLAY_GAME = "Play Game"
    static let SCREEN_SCORE_CARD = "Score Card"
    static let SCREEN_TEAM_PLAY = "Team Play"
    static let SCREEN_WATCH_VIDEO = "Watch Video"
    static let SCREEN_SPLASH = "Splash Screen"
    static let SCREEN_TEAM_PLAY_FINAL_SCORE_CARD = "Final Team Play Score Card"
    static let E_COMMERCE = "e-commerce"
    
    //    Category
    static let CAT_CINEMA = "Cinema"
    static let CAT_LIGHT_CAMERA_ACTION = "Lights Camera Action"
    static let CAT_SIRF_HINDI_ME_BOL = "Sirf Hindi me Bol"
    static let CAT_HERO_HEROINE = "Hero Heroine"
    static let CAT_ADULTS_ONLY = "Adults Only"
    static let CAT_HOLLYWOOD = "Hollywood"
    static let CAT_SOCIAL_SHARE = "Social Share"
    static let CAT_TEAM_PLAY = "Team Play"
    
    static let CAT_CRICKET = "Cricket"
    static let CAT_SONGS = "Songs"
    static let CAT_MYTHOLOGY = "Mythology"
    static let CAT_GAME_OF_THRONES = "Game of Thrones"
    static let CAT_KIDS_ZONES = "Kids Zone"
    static let CAT_KHAAN_PAAN = "Khaan Paan"
    
    static let CAT_HELP = "Help"
    static let CAT_SCORE_SCREEN = "Score Screen"
    static let CAT_TEAM_PLAY_SCORE_SCREEN = "Team Play Score Screen"
    static let CAT_ANSWER = "Answer"
    static let CAT_VIDEO = "Video"
    
    //    Action
    static let ACT_PLAY = "Play"
    static let ACT_BACK = "Back"
    static let ACT_CANCEL = "Cancel"
    static let ACT_CATEGORY_SELECTED = "Category Selected"
    static let ACT_VIDEO_BACK = "Video Back"
    static let ACT_VIDEO_SHARE = "Video Share"
    static let ACT_VIDEO_SAVE = "Video Save"
    static let ACT_VIDEO_PLAY = "Video Play"
    static let ACT_TILT_UP = "Tilt Up"
    static let ACT_TILT_DOWN = "Tilt Down"
    static let ACT_PLACE_ON_FOREHEAD = "Place on Forehead"
    static let ACT_CHOOSE_CATEGORY = "Choose Category"
    static let ACT_NUMBER_OF_ROUNDS = "Number of Rounds -"
    static let ACT_PREVIEW = "Preview"
    static let ACT_INITIATED_DESCRIPTION_PAGE = "Initiated Buy Description Page"
    static let ACT_INITIATED_SCORE_CARD_PAGE = "Initiated Buy Score Card Page"
    static let ACT_BUY_DESCRIPTION_PAGE = "Purchased Description Page"
    static let ACT_BUY_SCORE_CARD_PAGE = "Purchased Score Card Page"

    
    // color
    static let bg_cinema = UIColor.init(hexString: "#D74A3A")
    static let bg_light_camera_action = UIColor.init(hexString: "#8FC744")
    static let bg_sirf_hindi = UIColor.init(hexString: "#00C2FF")
    static let bg_hero_heroine = UIColor.init(hexString: "#A06592")
    static let bg_adult_only = UIColor.init(hexString: "#E09128")
    static let bg_hollywood = UIColor.init(hexString: "#3D5596")
    
    static let bg_cricket = UIColor.init(hexString: "#90c94a")
    static let bg_songs = UIColor.init(hexString: "#D44765")
    static let bg_mythology = UIColor.init(hexString: "#12453F")
    static let bg_got = UIColor.init(hexString: "#5B5B5E")
    static let bg_kids_zone = UIColor.init(hexString: "#F699B6")
    static let bg_khaan_paan = UIColor.init(hexString: "#EFB15B")
    
    static let whiteColor = UIColor.init(hexString: "#ffffff")
    static let correctColor = UIColor(red: 0, green: 255, blue: 0, alpha: 1)
    static let wrongColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
    static let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let selected_round_bg_color = UIColor.init(hexString: "#4F4F4F")
    static let unselected_round_bg_color = UIColor.init(hexString: "#606060")
    
//    preference
    static let SHARED_PREF_NAME = "shared_preference_sph"
    static let FIRST_TIME_ENTER = "first_time_enter"
    static let FIRST_TIME_DATA_LOAD = "first_time_data_load"
    static let UPDATE_VERSION_CODE = "update_version_code"
    static let SOUND_SETTING = "sound_setting"
    static let VIDEO_SETTING = "video_setting"
    
//    :Description
    static let cinema_desc = "Help your teammate guess the right movie from this collection of your favorite hits.\n\n\nIt’s the original dumb charades we all know! ACT all you can but NO TALKING!"
    
    static let light_camera_action_desc = "Show off your acting skills!\n\n\nAct out the word on your card for your teammate to guess. ONLY ACTING, NO TALKING!"

    static let hindi_desc = "Ain’t easy to speak in\n\"शुद्ध हिंदी\"\n\n\nTry it out yourself. Help your friend guess the english word on the card. One rule: You can SPEAK ONLY IN HINDI"
    
    static let hh_desc = "All the big stars of Bollywood are here.\n\n\nGIVE CLUES to your friend to guess as many names as possible without saying any part of the name on the card. NO RHYMING!"
    
    static let ao_desc = "This is a collection of \"Adults Only\" words. No place for Kaccha Nimbu\n\n\nGIVE CLUES to your friend to guess as many names as possible without saying any part of the name on the card. NO RHYMING!\n\n\nDISCLAIMER: This content is strictly for adults."
   
    static let hollywood_desc = "A dive into the western world. Superstars, movies, singers, designers and much more....\n\n\nGIVE CLUES to your friend to guess as many names as possible without saying any part of the name on the card. NO RHYMING!"
    
    static let cricket_desc = "This deck is for all the cricket fans!\n\n\nGIVE CLUES to your friend to guess as many words as possible without saying any part of the name on the card. NO RHYMING!"
    
   
    static let songs_desc = "All the songs you love\n\n\nACT or DANCE to help your friend guess the correct song. NO TALKING!\n\n\nChallenge Variation: GIVE CLUES to your friend to guess as many words as possible without saying any part of the name on the card. NO RHYMING!"
    
    static let mythology_desc = "From Ram to Ravana. From Yudhishthira to Duryodhana. A deck with all about mythology\n\n\nGIVE CLUES to your friend to guess as many names as possible without saying any part of the name on the card. NO RHYMING!"
    
    static let got_desc = "The royal families and their desire for the Iron Throne. Deck with everything about Game of Thrones\n\n\nGIVE CLUES to your friend to guess as many words as possible without saying any part of the name on the card. NO RHYMING!"
    

    static let kz_desc = "For all the kids and also people that are kids at heart\n\n\nGIVE CLUES or ACT for your friend to guess as many names as possible without saying any part of the name on the card. NO RHYMING!"
    
    static let kp_desc = "The right place for all the foodies. This deck has all your favorite foods and drinks\n\n\nGIVE CLUES to your friend to guess as many names as possible without saying any part of the name on the card. NO RHYMING!"
}
