//
//  OnboardingVM.swift
//  Onboarding
//
//  Created by Evhen Lukhtan on 21.11.2023.
//

import UIKit

final class OnboardingVM {
    // MARK: - Private properties
    var cells: [ScreensType]

    // MARK: - Init
    init(amount: Double) {
        self.cells = [.firstScreen, .secondScreen, .thirdScreen, .fourthScreen(amount)]
    }
    // MARK: - Methods
    func numberOfCells() -> Int {
            return cells.count
        }
    
    func configureCell(at index: Int) -> ScreensType {
        cells[index]
    }

    func processPayment(for product: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let success = Bool.random()
            completion(success)
        }
    }
}
