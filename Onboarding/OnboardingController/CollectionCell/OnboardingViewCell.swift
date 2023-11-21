//
//  OnboardingViewCell.swift
//  Onboarding
//
//  Created by Evhen Lukhtan on 20.11.2023.
//

import UIKit
import SnapKit

protocol ReusableViewCell: AnyObject {
    static var identifier: String { get }
}

class OnboardingViewCell: UICollectionViewCell {
    
    // MARK: - UI
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 26, weight: .semibold)
        label.textColor = UIColor(hexString: "#FFFFFF")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(hexString: "#E3E3E3")
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(hexString: "#E3E3E3")
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        backgroundColor = UIColor(hexString: "#162C53").withAlphaComponent(0.7)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(image)
        image.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(320)
        }
        
        contentView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(image.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(70)
        }
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
    }
    
    func configure(cell: ScreensType) {
        image.image = cell.image
        mainLabel.text = cell.label
        if let subLabelText = cell.sublabel {
            subLabel.text = subLabelText
        }
        
        if let attributedSublabelText = cell.atributedSublabel {
            subLabel.attributedText = attributedSublabelText
        }
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
}

// MARK: - extensions
extension OnboardingViewCell: ReusableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
