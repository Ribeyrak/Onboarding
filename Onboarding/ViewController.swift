//
//  ViewController.swift
//  Onboarding
//
//  Created by Evhen Lukhtan on 20.11.2023.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let backgroundImage = "bg"
        
        static let firstCellImage = "Illustration1"
        static let firstCellLabelText = "Your Personal Assistant"
        static let firstCellSublabelText = "Simplify your life with an AI companion"
        
        static let secondCellImage = "Illustration2"
        static let secondCellLabelText = "Get assistance with any topic"
        static let secondCellSublabelText = "From daily tasks to complex queries, we’ve got you covered"
        
        static let thirdCellImage = "Illustration3"
        static let thirdCellLabelText = "Perfect copy you can rely on"
        static let thirdCellSublabelText = "Generate professional texts effortlessly"
        
        static let fourthCellImage = "Illustration4"
        static let fourthCellLabelText = "Upgrade for Unlimited AI Capabilities"
        static let fourthCellSublabelText = "7-Day Free Trial, then $19.99 /month, auto-renewable"
    }
    
    var cells: [CellModel] = []
    
    // MARK: - UI
    private lazy var background: UIImageView = {
       let v = UIImageView()
        v.image = UIImage(named: Constants.backgroundImage)
        return v
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createCollectionLayout())
        collectionView.register(OnboardingViewCell.self, forCellWithReuseIdentifier: OnboardingViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var continueButton: UIButton = {
        var conf = UIButton.Configuration.filled()
        conf.title = "Continue"
        conf.attributedTitle?.foregroundColor = UIColor(hexString: "#191F28")
        conf.attributedTitle?.font = .systemFont(ofSize: 17, weight: .semibold)
        conf.buttonSize = .large
        conf.baseBackgroundColor = UIColor(hexString: "#FFFFFF")
        conf.cornerStyle = .capsule
        
        let v = UIButton(configuration: conf)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindUI()
    }
    
    // MARK: - Private functions
    private func setupUI() {
        view.addSubview(background)
        background.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(86)
            $0.left.right.equalToSuperview().inset(31)
            $0.height.equalTo(56)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(continueButton.snp.top).offset(-28)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(56)
        }
    }
    
    private func bindUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        cells = [
            CellModel(image: Constants.firstCellImage, mainLabelText: Constants.firstCellLabelText, subLabelText: Constants.firstCellSublabelText),
            CellModel(image: Constants.secondCellImage, mainLabelText: Constants.secondCellLabelText, subLabelText: Constants.secondCellSublabelText),
            CellModel(image: Constants.thirdCellImage, mainLabelText: Constants.thirdCellLabelText, subLabelText: Constants.thirdCellSublabelText),
            CellModel(image: Constants.fourthCellImage, mainLabelText: Constants.fourthCellLabelText, subLabelText: Constants.fourthCellSublabelText)
        ]
    }
    
    private func createCollectionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 4, trailing: 12)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.90), // Ширина группы меньше 100%
                                                   heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingViewCell.identifier, for: indexPath) as! OnboardingViewCell
        let res = cells[indexPath.row]
        cell.configure(cell: res)
        return cell
    }
    
    
}
