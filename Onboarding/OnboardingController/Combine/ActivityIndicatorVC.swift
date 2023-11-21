//
//  ActivityIndicatorVC.swift
//  MobileSMS
//
//  Created by Konstantin Khmara on 19.01.2022.
//  Copyright © 2022 Netsolace, Inc. All rights reserved.
//

import UIKit

final class ActivityIndicatorVC: UIViewController {
    // MARK: - Properties
    private let activityView = ActivityIndicatorView()
    
    // for Combine
    @Published var isAnimating = false {
        didSet {
            if isAnimating {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }
    
    private var frontWindow: UIWindow? {
        UIApplication.shared.keyWindow
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(activityView)
        activityView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 270, height: 134))
            $0.center.equalToSuperview()
        }
    }
    
    private func updateViewHierarchy() {
        // Add the overlay to the application window if necessary
        if view.superview == nil {
            frontWindow?.addSubview(view)
            view.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            // maybe already on screen but not in front, so bring to front
            view.superview?.bringSubviewToFront(view)
        }
    }
    
    func startAnimating() {
        updateViewHierarchy()
    }
    
    func stopAnimating() {
        if self.view.superview != nil {
            self.view.removeFromSuperview()
        }
    }
}
