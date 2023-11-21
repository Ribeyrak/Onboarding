//
//  PaymentProcessor.swift
//  Onboarding
//
//  Created by Evhen Lukhtan on 20.11.2023.
//

import UIKit

class PaymentProcessor {
    func processPayment(for product: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let success = Bool.random()
            completion(success)
        }
    }
}
