//
//  DescriptionViewController.swift
//  Sahi Pakde Hai
//
//  Created by Dipti Fulwani on 24/06/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import UIKit
import StoreKit
import FacebookCore
//import Mixpanel

class DescriptionViewController: BaseUIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var selectedCategoryImage: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    
    var selecteCategory = Category()
    var product:SKProduct? = nil
    var isPurchaseRequest = false
    
    enum BUTTON_TYPE {
        case play
        case buy
    }
    
    var buttonType:BUTTON_TYPE = BUTTON_TYPE.play
    
    let indicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestProdcut()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SKPaymentQueue.default().add(self)
        GoogleAnalyticsUtil.trackScreen(screenName: Constant.SCREEN_DESCRIPTION)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SKPaymentQueue.default().remove(self)
    }
    
    func setupView() {
        self.view.backgroundColor? = selecteCategory.backgroundColor
        self.selectedCategoryImage.image = UIImage.init(named: selecteCategory.image)
        self.desc.text = selecteCategory.desc
        setupButton()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Back button
    @IBAction func moveBack(_ sender: AnyObject) {
        GoogleAnalyticsUtil.trackEvent(action: Constant.ACT_BACK, category: self.selecteCategory.categoryName, label: "")
        self.dismiss(animated: true, completion: {})
    }

    @IBAction func playGame(_ sender: AnyObject) {
        onClickButton()
    }
    
    @IBAction func previewPlay(_ sender: AnyObject) {
        GoogleAnalyticsUtil.trackEvent(action: Constant.ACT_PREVIEW, category: self.selecteCategory.categoryName, label: "")
        
//        Mixpanel.mainInstance().track(event: Constant.ACT_PREVIEW, properties: [Constant.CATEGORY:self.selecteCategory.categoryName])
        
            
        MyNotification.trackEvent(category: self.selecteCategory.categoryName, action: Constant.ACT_PREVIEW)
        
        PreviewUtil.isPreviewPlay = true
        goToGamePlayController()
        
    }
    
    func setTeamPlayRound() {
        if TeamPlayUtil.isTeamPlay {
            TeamPlayUtil.playingRound = 1
            TeamPlayUtil.playingTeam = 1
        }
    }
    
    func goToGamePlayController() {
        if self.storyboard?.instantiateViewController(withIdentifier: "PLAY_GAME_VIEW") is PlayGameViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "PLAY_GAME_VIEW") as! PlayGameViewController
            controller.selectedCategory = self.selecteCategory
            present(controller, animated: true, completion: {})
        }
        
    }
    
    func setupButton() {
        if self.selecteCategory.isPaidCategory {
            setPriceLabel()
        }else {
            buttonType = BUTTON_TYPE.play
            setPlayButtonTitle(title: "PLAY")
            hidePreviewButton()
        }
    }
    
    func setPriceLabel() {
        if IAPHelper.isProductPurchased(productIdentifier: selecteCategory.productIdentifier + "." + Constant.PURCHASED) {
            buttonType = BUTTON_TYPE.play
            setPlayButtonTitle(title: "PLAY")
            hidePreviewButton()
        }else {
            let price = PreferenceUtil.getStringPref(key: selecteCategory.productIdentifier)
            if !price.isEmpty {
                setPlayButtonTitle(title: price)
            }else {
                setPlayButtonTitle(title: "BUY")
            }
            buttonType = BUTTON_TYPE.buy
            showPreviewButton()
        }
    }
    
    func showPreviewButton() {
        previewButton.isHidden = false
    }
    
    func hidePreviewButton() {
        previewButton.isHidden = true
    }
    
    func setPlayButtonTitle(title:String) {
        playButton.setTitle(title, for: .normal)
    }
    
    func startGame() {
//  use for sending event to facebook analytics
    
        
//        Mixpanel.mainInstance().track(event: Constant.ACT_PLAY, properties: [Constant.CATEGORY:self.selecteCategory.categoryName])
        
        MyNotification.trackEvent(category: self.selecteCategory.categoryName, action: Constant.ACT_PLAY)
        
        GoogleAnalyticsUtil.trackEvent(action: Constant.ACT_PLAY, category: self.selecteCategory.categoryName, label: "")
        PreviewUtil.isPreviewPlay = false
        setTeamPlayRound()
        goToGamePlayController()
    }
    
    func buy() {
        if product != nil {
            buyProduct()
        }else {
            isPurchaseRequest = true
            requestProdcut()
        }
    }
    
    func buyProduct() {
        print("Sending the payment request to apple")
        print("condition 1")
        GoogleAnalyticsUtil.trackEvent(action: Constant.ACT_INITIATED_DESCRIPTION_PAGE, category: selecteCategory.categoryName, label: "")
        if SKPaymentQueue.canMakePayments() {
            print("condition 2")
            let payment = SKPayment(product: product!)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func onClickButton() {
        switch buttonType {
        case BUTTON_TYPE.play:
            startGame()
            break
            
        case BUTTON_TYPE.buy:
            showActivityIndicator()
            buy()
            break
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if  response.products.count > 0{
            if response.products[0].productIdentifier == selecteCategory.productIdentifier {
                product = response.products[0]
                IAPHelper.setPrice(price: (product?.localizedPrice())!, productIdentifier: (product?.productIdentifier)!)
                if !isPurchaseRequest {
                    setPriceLabel()
                }else {
                    buyProduct()
                }
            }
            
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Product Request Error: "+error.localizedDescription)
         CommonUtil.showMessage(controller: self,title: error.localizedDescription,message: "")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        removeActivityIndicator()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("condition 3")
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                print("\n purchased")
                purchased(transaction: transaction)
                GoogleAnalyticsUtil.trackEvent(action: Constant.ACT_BUY_DESCRIPTION_PAGE, category: selecteCategory.categoryName, label: "")
                break
                
            case .failed:
                print("\n fail")
                fail(transaction: transaction)
                break
                
            case .restored:
                print("\n restored")
                purchased(transaction: transaction)
                break
                
            case .deferred:
                print("\n deferred")
                break
                
            case .purchasing:
                print("\n purchasing")
                break
            }
        }
    }
    
    private func purchased(transaction: SKPaymentTransaction) {
        print("complete...")
        removeActivityIndicator()
        SKPaymentQueue.default().finishTransaction(transaction)
        IAPHelper.setProductPurchased(isPurchased: true, productIdentifier: transaction.payment.productIdentifier + "." + Constant.PURCHASED)
        buttonType = BUTTON_TYPE.play
        setPlayButtonTitle(title: "PLAY")
        hidePreviewButton()
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        removeActivityIndicator()
        if let transactionError = transaction.error as? NSError {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(transaction.error?.localizedDescription)")
                CommonUtil.showMessage(controller: self,title: (transaction.error?.localizedDescription)!,message: "")
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func requestProdcut() {
        if SKPaymentQueue.canMakePayments() {
            let productId:Set<String> = [selecteCategory.productIdentifier]
            let productRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productId)
            productRequest.delegate = self
            productRequest.start()
            print("fetching products")
        }else {
            CommonUtil.showMessage(controller: self,title: "Can't make purchases",message: "")
        }
    }
    
    func showActivityIndicator() {
        CommonUtil.showActivityIndicator(actInd: self.indicatorView, view: self.view, subView: self.subView)
    }
    
    func removeActivityIndicator() {
        CommonUtil.removeActivityIndicator(actInd: self.indicatorView, view: self.view, subView: self.subView)
    }
}
