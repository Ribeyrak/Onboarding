//
//  ViewController.swift
//  Onboarding
//
//  Created by Evhen Lukhtan on 20.11.2023.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let backgroundImage = "bg"
        static let continueButtonText = "Continue"
        
        static let firstCellImage = "Illustration1"
        static let firstCellLabelText = "Your Personal \n Assistant"
        static let firstCellSublabelText = "Simplify your life \n with an AI companion"
        
        static let secondCellImage = "Illustration2"
        static let secondCellLabelText = "Get assistance \n with any topic"
        static let secondCellSublabelText = "From daily tasks to complex \n queries, we’ve got you covered"
        
        static let thirdCellImage = "Illustration3"
        static let thirdCellLabelText = "Perfect copy \n you can rely on"
        static let thirdCellSublabelText = "Generate professional \n texts effortlessly"
        
        static let fourthCellImage = "Illustration4"
        static let fourthCellLabelText = "Upgrade for Unlimited \n AI Capabilities"
        static let fourthCellSublabelText = "7-Day Free Trial, \n then $19.99 /month, auto-renewable"
    }
    
    var cells: [CellModel] = []
    private var loadingIndicator: UIActivityIndicatorView?
    
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
    
    private lazy var clearView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    private lazy var continueButton: UIButton = {
        var conf = UIButton.Configuration.filled()
        conf.title = Constants.continueButtonText
        conf.attributedTitle?.foregroundColor = UIColor(hexString: "#191F28")
        conf.attributedTitle?.font = .systemFont(ofSize: 17, weight: .semibold)
        conf.buttonSize = .large
        conf.baseBackgroundColor = UIColor(hexString: "#FFFFFF")
        conf.cornerStyle = .capsule
        
        let v = UIButton(configuration: conf)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var termsTextView: UITextView = {
        let v = UITextView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isEditable = false
        v.isScrollEnabled = false
        v.delegate = self
        v.isHidden = false
        return v
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        //collectionView.showsHorizontalScrollIndicator = false
        
        cells = [
            CellModel(image: Constants.firstCellImage, mainLabelText: Constants.firstCellLabelText, subLabelText: Constants.firstCellSublabelText),
            CellModel(image: Constants.secondCellImage, mainLabelText: Constants.secondCellLabelText, subLabelText: Constants.secondCellSublabelText),
            CellModel(image: Constants.thirdCellImage, mainLabelText: Constants.thirdCellLabelText, subLabelText: Constants.thirdCellSublabelText),
            CellModel(image: Constants.fourthCellImage, mainLabelText: Constants.fourthCellLabelText, subLabelText: Constants.fourthCellSublabelText)
        ]
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    // Setup CollectionViewLayout
    private func createCollectionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // Setup TextView
    private func setupTermsTextView() {
        let attributedString = NSMutableAttributedString(string: "By continuing you accept our: \n Terms of Use, Privacy Policy and Subscription Terms")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor(hexString: "#6E6E73"), range: NSRange(location: 0, length: attributedString.length))
        
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hexString: "#208BFF")
        ]
        
        let termsOfUseRange = (attributedString.string as NSString).range(of: "Terms of Use")
        attributedString.addAttribute(.link, value: "https://www.google.com.ua/", range: termsOfUseRange)
        
        let privacyPolicyRange = (attributedString.string as NSString).range(of: "Privacy Policy")
        attributedString.addAttribute(.link, value: "https://github.com/", range: privacyPolicyRange)
        
        let subscriptionTermsRange = (attributedString.string as NSString).range(of: "Subscription Terms")
        attributedString.addAttribute(.link, value: "https://www.ukr.net/", range: subscriptionTermsRange)
        
        termsTextView.attributedText = attributedString
        termsTextView.linkTextAttributes = linkAttributes
        termsTextView.backgroundColor = .clear
        termsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
        navigationController?.setupLeftBarButtonItem(title: "Restore Purchase", fontSize: 14, action: #selector(subscribeButtonTapped))
        navigationController?.setupRightBarButtonItem(systemName: "xmark", action: #selector(rightBarButtonTapped))
    }
    
    @objc private func continueButtonTapped() {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        let nextItem = visibleIndexPath.item + 1
        if nextItem < cells.count {
            let nextIndexPath = IndexPath(item: nextItem, section: visibleIndexPath.section)
            collectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
            
            if nextItem == cells.count - 1 {
                updateContinueButtonText(to: "Try Free & Subscribe")
                setupNavigationItems()
            }
            updateVisibilityFor(index: nextItem)
        } else if nextItem == cells.count {
            processPurchase()
        }
    }
    
    @objc func subscribeButtonTapped() {
        let paymentProcessor = PaymentProcessor()
        paymentProcessor.processPayment(for: "someProduct") { success in
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
            indicator.color = .white
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
        
        let paymentProcessor = PaymentProcessor()
        paymentProcessor.processPayment(for: "SubscriptionProduct") { [weak self] success in
            self?.hideLoadingIndicator()
            if success {
                self?.handleSuccessfulPayment()
            } else {
                self?.showPaymentError()
            }
        }
    }
    
    private func handleSuccessfulPayment() {
        let alert = UIAlertController(title: "Success", message: "Subscription activated successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            print("Good job")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func showPaymentError() {
        let alert = UIAlertController(title: "Payment Error", message: "There was an error processing your payment. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
    }}

// MARK: - CollectionView Delegate, DataSource
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

// MARK: - TextView Delegate
extension OnboardingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "https://www.google.com.ua/" {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        } else if URL.absoluteString == "https://github.com/" {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        } else if URL.absoluteString == "https://www.ukr.net/" {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }
        return false
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let cellWidthIncludingSpacing = scrollView.frame.width * 0.9 + 6
    //        let index = Int((scrollView.contentOffset.x + cellWidthIncludingSpacing / 2) / cellWidthIncludingSpacing)
    //
    //        pageControl.currentPage = index
    //
    //        termsTextView.isHidden = index == 1 || index == 2
    //        pageControl.isHidden = index == 0 || index == 3
    //    }
}

