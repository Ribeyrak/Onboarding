//
//  ActivityIndicatorView.swift
//  MobileSMS
//
//  Created by Konstantin Khmara on 20.01.2022.
//  Copyright © 2022 Netsolace, Inc. All rights reserved.
//

import UIKit

final class ActivityIndicatorView: UIView {
    private enum Constants {
        static let loaderText: String = "Loading..."
        static let cornerRadius: CGFloat = 12
        static let size = CGFloat(130)
        static let zero = CGFloat(0)
        static let standardOffset: CGFloat = 16
    }
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let topTitleStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private let topTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        return indicator
    }()
    
    init() {
        super.init(frame: CGRect(x: Constants.zero, y: Constants.zero, width: Constants.size, height: Constants.size))
        self.setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = .secondarySystemBackground
        
        addSubview(topTitleStack)
        topTitleStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.standardOffset)
            $0.left.right.equalToSuperview().inset(Constants.standardOffset)
        }
        
        [topTitleLabel, infoLabel, activityIndicator].forEach {
            topTitleStack.addArrangedSubview($0)
        }
        
        topTitleLabel.text = Constants.loaderText
        
        addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-Constants.standardOffset * 2)
        }
    }
}
