//
//  OnboardingVM.swift
//  Onboarding
//
//  Created by Evhen Lukhtan on 21.11.2023.
//

import UIKit
import Combine

protocol OnboardingVMDelegate: AnyObject {
    func onboardingVMDidCompletePurchase()
    func onboardingVMDidFailPurchase()
}

final class OnboardingVM {
    // MARK: - Private properties
    @Published private(set) var screens: [ScreensType] = []
    private(set) var amountSubject = PassthroughSubject<Double, Never>()
    var cancellables = Set<AnyCancellable>()
    weak var delegate: OnboardingVMDelegate?
    
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
    
    func processPayment(for productIdentifier: String) {
        IAPManager.shared.purchaseProduct(with: productIdentifier)
        IAPManager.shared.purchasePublisher
            .sink { [weak self] in
                $0 ? self?.handleSuccessfulPayment() : self?.showPaymentError()
            }
            .store(in: &cancellables)
    }
    
    func processRestore() {
        IAPManager.shared.restorePurchases()
        IAPManager.shared.restorePublisher
            .sink { [weak self] in
               $0 ? self?.handleSuccessfulPayment() : self?.showPaymentError()
            }
            .store(in: &cancellables)
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
    
    private func handleSuccessfulPayment() {
        delegate?.onboardingVMDidCompletePurchase()
    }
    
    private func showPaymentError() {
        delegate?.onboardingVMDidFailPurchase()
    }
}
