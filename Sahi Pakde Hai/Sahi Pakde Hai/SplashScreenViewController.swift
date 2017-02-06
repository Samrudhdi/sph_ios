//
//  SplashScreenViewController.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 31/01/17.
//  Copyright © 2017 Patronous Inc. All rights reserved.
//

import UIKit

class SplashScreenViewController: BaseUIViewController{

    let indicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
//        facebookLogin()
    }
    
    func goToHomeScreen() {
        perform(#selector(SplashScreenViewController.showNavController), with: nil, afterDelay: 3)
    }
    
    func showNavController() {
        performSegue(withIdentifier: "ShowSplashScreen", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        if CommonUtil.isInternetAvailable() {
            CommonUtil.showActivityIndicator(actInd: indicatorView, view: self.view, subView: super.subView)
            let url = "https://spreadsheets.google.com/tq?key=1RqjjkDkY4g2HfHDINt-Xxfv-QJsuLDOEQVW-D94-Km8"
            Service().getDeckData(url: url, actInd: indicatorView, view: self.view, subView: super.subView, success: successCallBack, failure: failureCallBack)
        }else {
            let preference = UserDefaults.standard
            if !preference.bool(forKey: Constant.FIRST_TIME_DATA_LOAD){
                CommonUtil.showMessageOnSnackbar(message: "No Internet Access")
            }
        }
        //        let data = Service().getJSON(urlToRequest: url)
        
    }
    
    func successCallBack(decks:Array<Deck>) {
        storeDeckData(decks: decks)
        CommonUtil.removeActivityIndicator(actInd: indicatorView, view: self.view, subView: super.subView)
        goToHomeScreen()
    }
    
    func failureCallBack(error: Error?) {
        CommonUtil.removeActivityIndicator(actInd: indicatorView, view: self.view, subView: super.subView)
        CommonUtil.showMessageOnSnackbar(message: error.debugDescription)
    }
    
    func storeDeckData(decks:Array<Deck>){
        let deck = decks[0];
        let updateFlag = deck.word
        print(updateFlag)
        let updateVersionCode = deck.deckType
        print(updateVersionCode)
        
        // Reading data from preference
        let preference = UserDefaults.standard
        //        if preference.object(forKey: Constant.UPDATE_VERSION_CODE) != nil {
        let storedVersion = preference.integer(forKey: Constant.UPDATE_VERSION_CODE)
        if updateVersionCode > storedVersion{
            let prefere = UserDefaults.standard
            insertDataOnDatabase(decks: decks)
            prefere.set(updateVersionCode, forKey: Constant.UPDATE_VERSION_CODE)
            prefere.set(true, forKey: Constant.FIRST_TIME_DATA_LOAD)
            //                prefere.in
            let didSave = prefere.synchronize()
            if !didSave {
                print("preference not set")
            }else {
                print("preference set")
            }
        }
    }
    
    func insertDataOnDatabase(decks:Array<Deck>){
        
        //        let group = AsyncGroup()
        //        group.background {
        let sqliteDatabase:SQLiteDatabase = SQLiteDatabase()
        let isReCreatedTable = sqliteDatabase.reCreateTable()
        if isReCreatedTable {
            let isInserted = sqliteDatabase.insertData(deckArray: decks)
            if isInserted {
                print("Data inserted successfully")
            }else {
                print("Data not inserted")
            }
        }else {
            print("Unable to insert data in table")
        }
        //        }
        //        group.wait()
        
    }
    
    // facebook login
//    func facebookLogin() {
//        if FBSDKAccessToken.current() == nil {
//            print("Not logged in")
//        }else {
//            print("Logged In")
//        }
//        
//        let loginButton = FBSDKLoginButton()
//        loginButton.readPermissions = ["public_profile","email","user_friends"]
//        loginButton.center = self.view.center
//        
//        loginButton.delegate = self
//        self.view.addSubview(loginButton)
//        
//    }
    
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if error == nil {
//            print("login complete")
//        }else {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("user logged out")
//    }
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
