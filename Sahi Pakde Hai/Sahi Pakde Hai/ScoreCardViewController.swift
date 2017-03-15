//
//  ScoreCardViewController.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 22/12/16.
//  Copyright © 2016 Patronous Inc. All rights reserved.
//

import UIKit
import AVFoundation
import StoreKit

class ScoreCardViewController: BaseUIViewController,UITableViewDataSource,UITableViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver{

    var deckResultArray:Array<DeckResult> = []
    var animateDeckResult:Array<DeckResult> = []
    var selectedCategory = Category()
    var videoUrl:URL?
    var totalCorrect = 0
    var score = 0
    enum ButtonType{
        case PLAY_AGAIN
        case CONTINUE
        case FINAL_SCORE
        case BUY
    }
    var  buttonType = ButtonType.PLAY_AGAIN
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playSameCategoryButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var videoThumbnailImageView: UIImageView!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoViewConstrain: NSLayoutConstraint!
    
    var playingTeam:Int?
    var playingRound:Int?
    var totalTeams:Int?
    var totalRounds:Int?
    
    var product:SKProduct? = nil
    var isPurchaseRequest = false
    var scoreTimer:Timer? = nil
    var timerCount:Int = 0
    var player: AVAudioPlayer? = nil
    
    let indicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showOrHideVideoView()
        self.videoThumbnailImageView.layoutIfNeeded()
        self.videoThumbnailImageView.setNeedsDisplay()
        self.setupTableView()
//        self.setupTimer()
        self.setFace()
        self.setupPlayButton()
        self.playScoreSound()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 28.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultTableViewCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        SKPaymentQueue.default().add(self)
        GoogleAnalyticsUtil.trackScreen(screenName: Constant.SCREEN_SCORE_CARD)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
        SKPaymentQueue.default().remove(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        print("support orientation");
        return UIInterfaceOrientationMask.portrait
    }
    
    @IBAction func playSameCategory(_ sender: AnyObject) {
        self.setupPlayButtonClick()
    }
    
    func showPlayGameController() {
        if self.storyboard?.instantiateViewController(withIdentifier: "PLAY_GAME_VIEW") is PlayGameViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "PLAY_GAME_VIEW") as! PlayGameViewController
            controller.selectedCategory = self.selectedCategory
            present(controller, animated: true, completion: {})
        }

    }
    
    @IBAction func back(_ sender: AnyObject) {
        if TeamPlayUtil.isTeamPlay {
            showConfirmDialog()
        }else {
            showCategoryViewController()
        }
    }
    
    func showCategoryViewController() {
        if self.storyboard?.instantiateViewController(withIdentifier: "CATEGORY_VIEW") is CategorySelectionViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "CATEGORY_VIEW") as! CategorySelectionViewController
            present(controller, animated: true, completion: {})
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckResultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as! ResultTableViewCell
        let label:UILabel = cell.resultLabel
        let deckResult = deckResultArray[indexPath.row]
        label.text = deckResult.word
        if deckResult.isCorrect {
            label.textColor = UIColor.white
//            increaseScoreByOne()
        }else {
            label.textColor = UIColor.red
        }
        
        return cell
    }
    
    func setFace() {
        for deckResult in deckResultArray {
            if deckResult.isCorrect {
                totalCorrect += 1
            }
        }
        
        scoreLabel.text = "Score \(totalCorrect)"
        if totalCorrect >= 4 {
            self.faceImageView.image? = UIImage.init(named: "user_happy_face")!
        }else {
            self.faceImageView.image? = UIImage.init(named: "user_sad_face")!
        }
    }
    
    func increaseScoreByOne() {
        score += 1
        scoreLabel.text = "Score \(score)"
    }
    
    func setThumbnail() {
        print(videoUrl)
        if videoUrl != nil {
//            playVideo(url: videoUrl!)
            let image = CommonUtil.getThumbnail(url: videoUrl!)
            if image != nil {
                self.videoThumbnailImageView.image = image
            }
        }
    }
    
    func setupTimer() {
        if deckResultArray.count > 0 {
            scoreTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(showResult), userInfo: nil, repeats: true)
        }
    }
    
    func showResult() {
        if timerCount < deckResultArray.count {
            timerCount += 1
            showWord(index: timerCount)
        }else {
           stopTimer()
        }
    }
    
    func showWord(index: Int) {
        let indexPath:IndexPath = IndexPath(row: index - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        let deck:DeckResult = deckResultArray[index - 1]
        if deck.isCorrect {
            increaseScoreByOne()
        }
    }
    
    
    @IBAction func playVideo(_ sender: AnyObject) {
        
        if self.storyboard?.instantiateViewController(withIdentifier: "VIDEO_PLAY_VIEW") is VideoPlayViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "VIDEO_PLAY_VIEW") as! VideoPlayViewController
            controller.videoURl = self.videoUrl
            controller.deckResultArray = self.deckResultArray
            controller.selectedCategory = self.selectedCategory
            
            present(controller, animated: true, completion: {})
        }

    }
    
    func showVideoView() {
        videoView.isHidden = false
        self.setThumbnail()
    }
    
    func hideVideoView() {
        videoView.isHidden = true
        videoViewConstrain.constant = 10
    }
    
    func showOrHideVideoView() {
        let  status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if status == AVAuthorizationStatus.authorized {
            showVideoView()
        }else {
            hideVideoView()
        }
    }
    
    func setButtonText(text:String){
        playSameCategoryButton.setTitle(text, for: .normal)
    }

    func setupPlayButton() {
        if PreviewUtil.isPreviewPlay {
            let price = PreferenceUtil.getStringPref(key: selectedCategory.productIdentifier)
            if !price.isEmpty {
                setButtonText(text: "Buy@ \(price)")
            }else {
                setButtonText(text: "Buy")
            }
            buttonType = ButtonType.BUY
            requestProdcut()
        }else {
            if TeamPlayUtil.isTeamPlay {
                
                playingTeam = TeamPlayUtil.playingTeam
                playingRound = TeamPlayUtil.playingRound
                totalTeams = TeamPlayUtil.totalTeams
                totalRounds = TeamPlayUtil.totalRounds
                
                if (playingTeam == 1){
                    var teamPlayScore = TeamPlayScore()
                    teamPlayScore.team1Score = totalCorrect
                    TeamPlayUtil.appendTeamScore(teamPlayScore: teamPlayScore)
                }else {
                    let index = TeamPlayUtil.getTeamScore().count - 1
                    TeamPlayUtil.addTeam2Score(score: totalCorrect, index: index)
                }
                
                if (totalRounds == playingRound && totalTeams == playingTeam){
                    print("final Score \(TeamPlayUtil.getTeamScore())")
                    setButtonText(text: "FINAL SCORE")
                    buttonType = ButtonType.FINAL_SCORE
                }else {
                    if (TeamPlayUtil.totalTeams == TeamPlayUtil.playingTeam) {
                        TeamPlayUtil.playingRound = TeamPlayUtil.playingRound + 1
                        TeamPlayUtil.playingTeam = 1
                    } else {
                        TeamPlayUtil.playingTeam = TeamPlayUtil.playingTeam + 1
                    }

                    setButtonText(text: "CONTINUE")
                    buttonType = ButtonType.CONTINUE
                }
            }else {
                setButtonText(text: "PLAY SAME CATEGORY")
                buttonType = ButtonType.PLAY_AGAIN
            }
        }
    }
    
    func setupPlayButtonClick() {
        switch buttonType {
        case .PLAY_AGAIN:
            showPlayGameController()
            break
            
        case .CONTINUE:
            showPlayGameController()
            break
            
        case .FINAL_SCORE:
            showFinalScore()
            break
            
        case .BUY:
            showActivityIndicator()
            buy()
            break
        }

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
        if SKPaymentQueue.canMakePayments() {
            print("condition 2")
            let payment = SKPayment(product: product!)
            SKPaymentQueue.default().add(payment)
            GoogleAnalyticsUtil.trackEvent(action: Constant.ACT_INITIATED_SCORE_CARD_PAGE, category: selectedCategory.categoryName, label: "")
        }
    }

    
    func showFinalScore() {
        if self.storyboard?.instantiateViewController(withIdentifier: "TEAM_FINAL_SCORE") is TeamFinalScoreCardViewController {
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "TEAM_FINAL_SCORE") as! TeamFinalScoreCardViewController
            controller.selectedCategory = self.selectedCategory
            present(controller, animated: true, completion: {})
        }
    }
    
    func showConfirmDialog() {
        let alertController = UIAlertController(title: "Exit Team Play", message: "Are you sure you want to exit team play?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Exit", style: .default, handler: {
            action in
            TeamPlayUtil.isTeamPlay = false
            self.showCategoryViewController()
        }))
        
        alertController.addAction(UIAlertAction(title: "Continue Team Play", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if  response.products.count > 0{
            if response.products[0].productIdentifier == selectedCategory.productIdentifier {
                product = response.products[0]
                let localizedPrice:String = (product?.localizedPrice())!
                IAPHelper.setPrice(price: localizedPrice, productIdentifier: (product?.productIdentifier)!)
                if !isPurchaseRequest {
                    setButtonText(text: "Buy@ \(localizedPrice)")
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
                purchased(transaction: transaction)
                GoogleAnalyticsUtil.trackEvent(action: Constant.ACT_BUY_SCORE_CARD_PAGE, category: selectedCategory.categoryName, label: "")
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                purchased(transaction: transaction)
                break
            case .deferred:
                print("deferred")
                break
            case .purchasing:
                print("purchasing")
                break
            }
        }
    }
    
    private func purchased(transaction: SKPaymentTransaction) {
        print("complete...")
        removeActivityIndicator()
        SKPaymentQueue.default().finishTransaction(transaction)
        IAPHelper.setProductPurchased(isPurchased: true, productIdentifier: transaction.payment.productIdentifier + "." + Constant.PURCHASED)
        setButtonText(text: "PLAY SAME CATEGORY")
        buttonType = ButtonType.PLAY_AGAIN
        PreviewUtil.isPreviewPlay = false
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
            let productId:Set<String> = [selectedCategory.productIdentifier]
            let productRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productId)
            productRequest.delegate = self
            productRequest.start()
            print("fetching products")
        }else {
            CommonUtil.showMessage(controller: self,title: "Can't make purchases",message: "")
        }
    }
    
    func playScoreSound() {
        self.player = CommonUtil().playSound(sound: "final_score", ofType: "mp3")
        if self.player != nil {
            self.player?.play()
        }
    }
    
    func showActivityIndicator() {
        CommonUtil.showActivityIndicator(actInd: self.indicatorView, view: self.view, subView: self.subView)
    }
    
    func removeActivityIndicator() {
        CommonUtil.removeActivityIndicator(actInd: self.indicatorView, view: self.view, subView: self.subView)
    }
    
    func stopTimer() {
        if scoreTimer != nil {
            scoreTimer?.invalidate()
            scoreTimer = nil
            scoreLabel.text = "Score \(totalCorrect)"
        }
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
