//
//  OnboardingVC.swift
//  Onboarding
//
//  Created by Evhen Lukhtan on 20.11.2023.
//

import UIKit
import SnapKit
import Combine

private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ScreensType>
private typealias DataSource = UICollectionViewDiffableDataSource<Int, ScreensType>

final class OnboardingVC: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let backgroundImage = #imageLiteral(resourceName: "bg")
        static let continueButtonText = "Continue"
        static let updateContinueButtonText = "Try Free & Subscribe"
        static let navBarLeftItemName = "Restore Purchase"
        static let navBarRightItemImage = "xmark"
        static let amount = 19.99
        static let textViewString = "By continuing you accept our: \n Terms of Use, Privacy Policy and Subscription Terms"
        
        static let textViewInsetConstraint = CGFloat(10)
        static let termsOfUse = "Terms of Use"
        static let termsOfUseValue = "https://www.google.com.ua/"
        
        static let privacyPolicy = "Privacy Policy"
        static let privacyPolicyValue = "https://github.com/"
        
        static let subscriptionTerms = "Subscription Terms"
        static let subscriptionTermsValue = "https://www.ukr.net/"
    }
    
    // MARK: - Properties
    private let viewModel = OnboardingVM()
    private var cancellables = Set<AnyCancellable>()
    
    private var loadingIndicator: UIActivityIndicatorView?
    
    private lazy var snapshot = Snapshot()
    private lazy var dataSource = makeDataSource()
    
    // MARK: - UI
    private lazy var background: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.backgroundImage
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createCollectionLayout())
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    private lazy var clearView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var continueButton: UIButton = {
        var conf = UIButton.Configuration.filled()
        conf.title = Constants.continueButtonText
        conf.attributedTitle?.foregroundColor = UIColor(hexString: "#191F28")
        conf.attributedTitle?.font = .systemFont(ofSize: 17, weight: .semibold)
        conf.buttonSize = .large
        conf.baseBackgroundColor = UIColor(hexString: "#FFFFFF")
        conf.cornerStyle = .capsule
        
        let button = UIButton(configuration: conf)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var termsTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.isHidden = false
        return textView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor(hexString: "#9099A6")
        pageControl.currentPageIndicatorTintColor = UIColor(hexString: "#009AFF")
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.isHidden = true
        return pageControl
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
        setupTermsTextView()
        
        bindCombine()
        viewModel.amountSubject.send(Constants.amount)
    }
    
    // MARK: - Private functions
    private func setupUI() {
        view.addSubview(background)
        background.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(termsTextView)
        termsTextView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(26)
            $0.bottom.equalToSuperview().inset(34)
            $0.height.greaterThanOrEqualTo(28)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
        }
        
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints {
            $0.bottom.equalTo(termsTextView.snp.top).offset(-24)
            $0.bottom.equalTo(pageControl.snp.top).offset(-24)
            $0.left.right.equalToSuperview().inset(31)
            $0.height.equalTo(56)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(continueButton.snp.top).offset(-28)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        
        view.addSubview(clearView)
        clearView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(continueButton.snp.top).offset(-28)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(56)
        }
    }
    
    private func bindUI() {
        continueButton.addAction(UIAction(handler: { [weak self] _ in
            self?.continueButtonTapped()
        }), for: .touchUpInside)
    }
    
    private func bindCombine() {
        viewModel.$screens
            .sink { [weak self] in
                self?.applySnapshot(for: $0)
            }
            .store(in: &cancellables)
    }
    
    private func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<OnboardingViewCell, ScreensType> { cell, indexPath, screen in
            cell.configure(cell: self.viewModel.configureCell(at: indexPath.row))
        }
        
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        return dataSource
    }
    
    private func applySnapshot(for rows: [ScreensType]) {
        var snapshot = snapshot
        snapshot.appendSections([0])
        snapshot.appendItems(rows)
        dataSource.apply(snapshot)
    }
    // Setup CollectionViewLayout
    private func createCollectionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 3, bottom: .zero, trailing: 3)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 6, bottom: .zero, trailing: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // Setup TextView
    private func setupTermsTextView() {
        let attributedString = NSMutableAttributedString(string: Constants.textViewString)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: .zero, length: attributedString.length))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: .zero, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor(hexString: "#6E6E73"), range: NSRange(location: .zero, length: attributedString.length))
        
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hexString: "#208BFF")
        ]
        
        let termsOfUseRange = (attributedString.string as NSString).range(of: Constants.termsOfUse)
        attributedString.addAttribute(.link, value: Constants.termsOfUseValue, range: termsOfUseRange)
        
        let privacyPolicyRange = (attributedString.string as NSString).range(of: Constants.privacyPolicy)
        attributedString.addAttribute(.link, value: Constants.privacyPolicyValue, range: privacyPolicyRange)
        
        let subscriptionTermsRange = (attributedString.string as NSString).range(of: Constants.subscriptionTerms)
        attributedString.addAttribute(.link, value: Constants.subscriptionTermsValue, range: subscriptionTermsRange)
        
        termsTextView.attributedText = attributedString
        termsTextView.linkTextAttributes = linkAttributes
        termsTextView.backgroundColor = .clear
        termsTextView.textContainerInset = UIEdgeInsets(top: Constants.textViewInsetConstraint, left: Constants.textViewInsetConstraint, bottom: Constants.textViewInsetConstraint, right: Constants.textViewInsetConstraint)
    }
    
    private func updateContinueButtonText(to newText: String) {
        var currentConfig = continueButton.configuration
        currentConfig?.title = newText
        currentConfig?.attributedTitle?.foregroundColor = UIColor(hexString: "#191F28")
        currentConfig?.attributedTitle?.font = .systemFont(ofSize: 17, weight: .semibold)
        currentConfig?.buttonSize = .large
        currentConfig?.baseBackgroundColor = UIColor(hexString: "#FFFFFF")
        currentConfig?.cornerStyle = .capsule
        continueButton.configuration = currentConfig
    }
    
    private func updateVisibilityFor(index: Int) {
        termsTextView.isHidden = index == 1 || index == 2
        pageControl.isHidden = index == 0 || index == 3
        pageControl.currentPage = index
        
        for i in 0..<pageControl.numberOfPages {
            let isCurrentPage = i == index
            let indicatorImage = createFlatIndicatorImage(isCurrentPage: isCurrentPage)
            pageControl.setIndicatorImage(indicatorImage, forPage: i)
        }
    }
    
    private func setupNavigationItems() {
        navigationController?.setupLeftBarButtonItem(title: Constants.navBarLeftItemName, fontSize: 14, action: #selector(subscribeButtonTapped))
        navigationController?.setupRightBarButtonItem(systemName: Constants.navBarRightItemImage, action: #selector(rightBarButtonTapped))
    }
    
    private func continueButtonTapped() {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        let nextItem = visibleIndexPath.item + 1
        if nextItem < viewModel.numberOfCells() {
            let nextIndexPath = IndexPath(item: nextItem, section: visibleIndexPath.section)
            collectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
            
            if nextItem == viewModel.numberOfCells() - 1 {
                updateContinueButtonText(to: Constants.updateContinueButtonText)
                setupNavigationItems()
            }
            updateVisibilityFor(index: nextItem)
        } else if nextItem == viewModel.numberOfCells() {
            processPurchase()
        }
    }
    
    @objc func subscribeButtonTapped() {
        viewModel.processPayment(for: "someProduct") { success in
            if success {
                print("Subs restore success")
            } else {
                print("Restore fail")
            }
        }
    }
    
    @objc func rightBarButtonTapped() {
        print("rightBarButtonTapped")
    }
    
    private func showLoadingIndicator() {
        if loadingIndicator == nil {
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.center = self.view.center
            indicator.color = .black
            self.view.addSubview(indicator)
            self.loadingIndicator = indicator
        }
        
        loadingIndicator?.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        loadingIndicator?.stopAnimating()
    }
    
    private func processPurchase() {
        showLoadingIndicator()
        viewModel.processPayment(for: "SubscriptionProduct") { [weak self] success in
            self?.hideLoadingIndicator()
            if success {
                self?.handleSuccessfulPayment()
            } else {
                self?.showPaymentError()
            }
        }
    }
    
    private func createFlatIndicatorImage(isCurrentPage: Bool) -> UIImage? {
        let width = isCurrentPage ? 25 : 14
        let size = CGSize(width: width, height: 4)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(8))
            ctx.cgContext.addPath(path.cgPath)
            ctx.cgContext.fillPath()
        }
    }
}

// MARK: - Alert
extension OnboardingVC {
    func handleSuccessfulPayment() {
        let alert = UIAlertController(title: "Success", message: "Subscription activated successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("Good job")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showPaymentError() {
        let alert = UIAlertController(title: "Payment Error", message: "There was an error processing your payment. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - TextView Delegate
extension OnboardingVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == Constants.termsOfUseValue || URL.absoluteString == Constants.privacyPolicyValue || URL.absoluteString == Constants.subscriptionTermsValue {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }
        return false
    }
}


