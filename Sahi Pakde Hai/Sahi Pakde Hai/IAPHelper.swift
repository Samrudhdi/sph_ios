//
//  IAPHelper.swift
//  Sahi Pakde Hai
//
//  Created by Manoj Belghaya on 06/03/17.
//  Copyright © 2017 Patronous Inc. All rights reserved.
//

import StoreKit

class IAPHelper : NSObject  {
    
    static func isProductPurchased(productIdentifier: String) -> Bool {
        return PreferenceUtil().getBoolPref(key: productIdentifier)
    }
    
    static func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    static func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    static func storePurchasePrice(products:[SKProduct]){
        if products.count > 0 {
            for product in products {
                print("\n name: "+product.localizedTitle+" price: "+product.localizedPrice())
                setPrice(price: product.localizedPrice(), productIdentifier: product.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }

    static func getPrice(productIdentifier: String) -> String{
        return PreferenceUtil().getStringPref(key: productIdentifier)
    }
    
    static func setPrice(price: String, productIdentifier: String) {
        PreferenceUtil().setPreference(value: price, key: productIdentifier)
    }
    
    static func setProductPurchased(isPurchased: Bool, productIdentifier: String) {
        PreferenceUtil().setPreference(value: isPurchased, key: productIdentifier)
    }
    
}


// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as? NSError {
            if transactionError.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(transaction.error?.localizedDescription)")
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        
//        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        UserDefaults.standard.synchronize()
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: identifier)
    }
}

