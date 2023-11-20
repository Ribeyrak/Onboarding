//
//  UINavigationController.swift
//  Onboarding
//
//  Created by Evhen Lukhtan on 20.11.2023.
//

import UIKit

extension UINavigationController {
    func setupLeftBarButtonItem(title: String, fontSize: CGFloat, action: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.addTarget(topViewController, action: action, for: .touchUpInside)
        button.tintColor = UIColor(hexString: "#9099A6")
        topViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }

    func setupRightBarButtonItem(systemName: String, action: Selector) {
        let button = UIBarButtonItem(image: UIImage(systemName: systemName), style: .plain, target: topViewController, action: action)
        button.tintColor = UIColor(hexString: "#9099A6")
        topViewController?.navigationItem.rightBarButtonItem = button
    }
}
