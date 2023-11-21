//
//  OnboardingModel.swift
//  Onboarding
//
//  Created by Evhen Lukhtan on 21.11.2023.
//

import UIKit

enum ScreensType {
    case firstScreen
    case secondScreen
    case thirdScreen
    case fourthScreen(Double)
    
    var image: UIImage {
        switch self {
        case .firstScreen: #imageLiteral(resourceName: "Illustration1")
        case .secondScreen: #imageLiteral(resourceName: "Illustration2")
        case .thirdScreen: #imageLiteral(resourceName: "Illustration3")
        case .fourthScreen: #imageLiteral(resourceName: "Illustration4")
        }
    }
    var label: String {
        switch self {
        case .firstScreen: "Your Personal \n Assistant"
        case .secondScreen: "Get assistance \n with any topic"
        case .thirdScreen: "Perfect copy \n you can rely on"
        case .fourthScreen: "Upgrade for Unlimited \n AI Capabilities"
        }
    }
    var sublabel: String? {
        switch self {
        case .firstScreen:
            return "Simplify your life \n with an AI companion"
        case .secondScreen:
            return "From daily tasks to complex \n queries, we’ve got you covered"
        case .thirdScreen:
            return "Generate professional \n texts effortlessly"
        default:
            return nil
        }
    }
    
    var atributedSublabel: NSAttributedString? {
        switch self {
        case .fourthScreen(let num):
            let cost = NumberFormatter.currencyFormatter.string(from: NSNumber(value: num)) ?? ""
            let string = "7-Day Free Trial, \n then \(cost) /month, auto-renewable"
            let attributedString = NSMutableAttributedString(string: string)
            let font = UIFont.boldSystemFont(ofSize: 16)
            let range = string.range(of: cost)
            attributedString.addAttribute(.font, value: font, range: NSRange(range!, in: string))
            return attributedString
        default:
            return nil
        }
    }
}
