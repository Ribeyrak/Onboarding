//
//  IAPManager.swift
//  Onboarding
//
//  Created by Evhen Lukhtan on 22.11.2023.
//

import StoreKit
import Combine

final class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = IAPManager()
    var purchasePublisher = PassthroughSubject<Bool, Never>()
    var restorePublisher = PassthroughSubject<Bool, Never>()
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    func purchaseProduct(with identifier: String) {
        let request = SKProductsRequest(productIdentifiers: [identifier])
        request.delegate = self
        request.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.purchasePublisher.send(true)
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.restorePublisher.send(false)
        }
    }
    
    // MARK: - SKProductsRequestDelegate
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let product = response.products.first else {
            print("Product not found.")
            return
        }
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            print("Product found.")
        } else {
            print("Purchases are disabled on this device.")
        }
    }
    
    // MARK: - SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                purchasePublisher.send(true)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                restorePublisher.send(true)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if transaction.transactionState == .purchased {
                    purchasePublisher.send(false)
                } else if transaction.transactionState == .restored {
                    restorePublisher.send(false)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
            return true
        }
}
