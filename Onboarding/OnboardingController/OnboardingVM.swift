//
//  OnboardingVM.swift
//  Onboarding
//
//  Created by Evhen Lukhtan on 21.11.2023.
//

import UIKit
import Combine

final class OnboardingVM {
    // MARK: - Private properties
    @Published private(set) var screens: [ScreensType] = []
    private(set) var amountSubject = PassthroughSubject<Double, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        bind()
    }
    // MARK: - Public Methods
    func numberOfCells() -> Int {
            return screens.count
        }
    
    func configureCell(at index: Int) -> ScreensType {
        screens[index]
    }

    func processPayment(for product: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let success = Bool.random()
            completion(success)
        }
    }
    
    // MARK: - Private Methods
    private func bind() {
        amountSubject
            .map { amount -> [ScreensType] in
                [.firstScreen, .secondScreen, .thirdScreen, .fourthScreen(amount)]
            }
            .assign(to: \.screens, on: self)
            .store(in: &cancellables)
    }
}
