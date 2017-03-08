//
//  SplashScreenViewController.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 31/01/17.
//  Copyright © 2017 Patronous Inc. All rights reserved.
//

import UIKit
import StoreKit

class SplashScreenViewController: BaseUIViewController,SKProductsRequestDelegate{

    
    let defaults = UserDefaults.standard

    let indicatorView = UIActivityIndicatorView()
    let delay: Float = 2.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInAppProductPrice()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GoogleAnalyticsUtil.trackScreen(screenName: Constant.SCREEN_SPLASH)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    func goToScreen() {
        
        if !PreferenceUtil().getBoolPref(key: Constant.FIRST_TIME_ENTER){
            PreferenceUtil().setPreference(value: true, key: Constant.FIRST_TIME_ENTER)
            perform(#selector(SplashScreenViewController.showHowToPlayController), with: nil, afterDelay: TimeInterval(delay))
        }else {
            perform(#selector(SplashScreenViewController.showCategoryController), with: nil, afterDelay: TimeInterval(delay))
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    func showCategoryController() {
        if self.storyboard?.instantiateViewController(withIdentifier: "CATEGORY_VIEW") is CategorySelectionViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "CATEGORY_VIEW") as! CategorySelectionViewController
            present(controller, animated: true, completion: {})
        }

    }
    
    func showHowToPlayController() {
        if self.storyboard?.instantiateViewController(withIdentifier: "HOW_TO_PLAY_VIEW") is HowToPlayViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "HOW_TO_PLAY_VIEW") as! HowToPlayViewController
            present(controller, animated: true, completion: {})
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData() {
        if CommonUtil.isInternetAvailable() {
            CommonUtil.showActivityIndicator(actInd: indicatorView, view: self.view, subView: super.subView)
            let url = "https://spreadsheets.google.com/tq?key=1RqjjkDkY4g2HfHDINt-Xxfv-QJsuLDOEQVW-D94-Km8"
            Service().getDeckData(url: url, actInd: indicatorView, view: self.view, subView: super.subView, success: successCallBack, failure: failureCallBack)
        }else {
            if !PreferenceUtil().getBoolPref(key: Constant.FIRST_TIME_DATA_LOAD){
                showNoInternetDialog()
            }else {
                goToScreen()
            }
        }
        
        
    }
    
    func successCallBack(decks:Array<Deck>) {
        storeDeckData(decks: decks)
        CommonUtil.removeActivityIndicator(actInd: indicatorView, view: self.view, subView: super.subView)
        goToScreen()
    }
    
    func failureCallBack(error: Error?) {
        CommonUtil.removeActivityIndicator(actInd: indicatorView, view: self.view, subView: super.subView)
        CommonUtil.showMessage(controller: self,title: (error?.localizedDescription)!, message: "")
    }
    
    func storeDeckData(decks:Array<Deck>){
        let deck = decks[0];
        let updateFlag = deck.word
        print(updateFlag)
        let updateVersionCode = deck.deckType
        print(updateVersionCode)
        
        let storedVersion = PreferenceUtil().getIntPref(key: Constant.UPDATE_VERSION_CODE)
        if updateVersionCode > storedVersion{
            insertDataOnDatabase(decks: decks)
            PreferenceUtil().setPreference(value: updateVersionCode, key: Constant.UPDATE_VERSION_CODE)
            PreferenceUtil().setPreference(value: true, key: Constant.FIRST_TIME_DATA_LOAD)
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
    }
    
    func showNoInternetDialog() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "No internet connectivity detected. Please reconnect and try again", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: {
            action in
            self.loadData()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getInAppProductPrice() {
        
        if IAPHelper.canMakePayments() {
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: Constant.productIdentifiers);
            productsRequest.delegate = self;
            productsRequest.start();
            print("Fetching Products");
        } else {
            CommonUtil.showMessage(controller: self, title: "can't make purchases", message: "")
        }
    }

    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        IAPHelper.storePurchasePrice(products: response.products)
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Product Reqeust Error: "+error.localizedDescription)
         CommonUtil.showMessage(controller: self, title:error.localizedDescription, message: "")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
