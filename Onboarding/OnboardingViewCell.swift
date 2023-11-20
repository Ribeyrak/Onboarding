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
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    private lazy var mainLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.numberOfLines = 2
        v.font = .systemFont(ofSize: 26)
        v.textColor = UIColor(hexString: "#FFFFFF")
        return v
    }()
    
    private lazy var subLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.numberOfLines = 2
        v.font = .systemFont(ofSize: 17)
        v.textColor = UIColor(hexString: "#E3E3E3")
        return v
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
            $0.top.equalToSuperview().inset(16)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(320)
        }
        
        contentView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(image.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(55)
        }
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints {
            $0.top.equalTo(mainLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(39)
        }
    }
    
    func configure(cell: CellModel) {
        image.image = UIImage(named: cell.image)
        mainLabel.text = cell.mainLabelText
        subLabel.text = cell.subLabelText
        
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
