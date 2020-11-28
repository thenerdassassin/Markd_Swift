//
//  InAppPurchasesObserver.swift
//  Markd
//
//  Created by Brittany Schmidt on 8/18/19.
//  Copyright © 2019 Joshua Daniel Schmidt. All rights reserved.
//

import Foundation
import StoreKit

class InAppPurchasesObserver: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let instance = InAppPurchasesObserver()
    
    private var handler:PurchaseHandler?
    fileprivate var productId = "markd_contractor_annual"
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var productToPurchase: SKProduct?
    
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func getSKProduct() {
        productsRequest = SKProductsRequest(productIdentifiers: Set([self.productId]))
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func purchase(_ handler:PurchaseHandler) {
        self.handler = handler
        guard let product = productToPurchase else {
            print("InAppPurchases:- No Product Found!")
            return
        }
        
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
        } else {
            print("InAppPurchases:- Can't make purchases")
        }
    }
    func restorePurchase(_ handler:PurchaseHandler) {
        self.handler = handler
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    //Mark:- SKProductsRequestDelegate
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            if product.productIdentifier == productId {
                productToPurchase = product
            }
        }
    }
    //Mark:- SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("InAppPurchases:- Product purchase done")
                handler?.purchase(wasSuccessful: true)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
                
            case .failed:
                print("InAppPurchases:- Product purchase failed for \(String(describing: transaction.error))")
                handler?.purchase(wasSuccessful: false)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .restored:
                print("InAppPurchases:- Product restored")
                handler?.purchase(wasSuccessful: false)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
                
            default:
                print("InAppPurchases:- \(transaction.transactionState)")
                handler?.purchase(wasSuccessful: false)
                break
            }
        }
    }
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("InAppPurchases:- Restored Transactions")
        handler?.purchase(wasSuccessful: true)
    }
    
}
