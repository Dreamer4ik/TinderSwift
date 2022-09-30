//
//  ViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 31.08.2022.
//

import UIKit
import Firebase
import Pulsator

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private var user: User?
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    private let operationQueue = OperationQueue()
    private var topCardView: CardView?
    private var cardViews = [CardView]()
    private var counter: Int = 0
    
    private var viewModels = [CardViewModel]() {
        didSet {
            configureCards()
        }
    }
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let viewBackgroundIcon: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tinder")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let pulsator = Pulsator()
    
    // MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        setupPuls()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chechUserIsLoggedIn()
        configureUI()
        DispatchQueue.main.async {
            self.fetchUsers()
        }
        fetchUser()
    }
    
    // MARK: - API
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Service.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    private func fetchUsers() {
        let operatioQueue = OperationQueue()
        
        operatioQueue.addOperation {
            Service.fetchUsers { users in
                self.viewModels = users.map({
                    CardViewModel(user: $0)
                })
            }
            Thread.sleep(forTimeInterval: 3.0)
        }
        
        operatioQueue.waitUntilAllOperationsAreFinished()
        
        operatioQueue.addOperation {
            DispatchQueue.main.async {
                self.pulsator.stop()
                self.pulsator.isHidden = true
                self.iconView.isHidden = true
                self.viewBackgroundIcon.isHidden = true
            }
        }
    }
    
    private func chechUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            presentLoginController()
        }
        else {
            print("user is logged in...")
        }
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
            presentLoginController()
        }
        catch {
            print("Failed to sign out...")
        }
    }
    
    // MARK: - Helpers
    private func setupPuls() {
        pulsator.radius = 150
        pulsator.numPulse = 5
        pulsator.animationDuration = 4
        //        pulsator.instanceDelay = 0.5
        pulsator.backgroundColor = UIColor.systemPink.cgColor
        pulsator.start()
    }
    
    private func configureCards() {
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            cardView.delegate = self
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        cardViews = deckView.subviews.compactMap({
            $0 as? CardView
        })
        topCardView = cardViews.last
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        topStack.delegate = self
        bottomStack.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [topStack, deckView, bottomStack])
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor
        )
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        view.addSubview(viewBackgroundIcon)
        view.addSubview(iconView)
        viewBackgroundIcon.layer.superlayer?.insertSublayer(pulsator, below: viewBackgroundIcon.layer)
        stack.bringSubviewToFront(deckView)
    }
    
    private func presentLoginController() {
        DispatchQueue.main.async {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let sizeView: CGFloat = 90
        let sizeIcon: CGFloat = 40
        
        viewBackgroundIcon.frame = CGRect(x: 0, y: 0, width: sizeView, height: sizeView)
        iconView.frame = CGRect(x: 0, y: 0, width: sizeIcon, height: sizeIcon)
        
        viewBackgroundIcon.configureGradientLayerForView()
        viewBackgroundIcon.layer.cornerRadius = sizeView/2
        iconView.layer.cornerRadius = sizeIcon/2
        
        viewBackgroundIcon.center = view.center
        iconView.center = view.center
        
        pulsator.position = viewBackgroundIcon.layer.position
    }
    
    func performSwipeAnimationLikeAndDislike(topCard: CardView,shouldLike: Bool, count: Int) {
        if shouldLike {
            topCard.configureCardViewLabel(direction: SwipeDirection.right)
        }
        else {
            topCard.configureCardViewLabel(direction: SwipeDirection.left)
        }
        let xTranslation: CGFloat = shouldLike ? view.width * 1.2 : -view.width * 1.2
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.1, options: .curveEaseOut) {
            
            let degreesCONST = 10.0
            let degrees: CGFloat = count % 2 == 0 ? degreesCONST : -degreesCONST
            let angle = degrees * .pi / 180
            let rotationalTransform = CGAffineTransform(rotationAngle: angle)
            topCard.transform = rotationalTransform.translatedBy(x: xTranslation, y: -50)
            
        } completion: { _ in
            self.topCardView?.removeFromSuperview()
            self.counter += 1
            guard !self.cardViews.isEmpty else {
                return
            }
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
        }
        
    }
    
    func performSwipeAnimationSuperLike(topCard: CardView) {
        topCard.configureCardViewLabel(direction: SwipeDirection.top)
        
        let yTranslation: CGFloat =  -view.height * 1.2
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.1, options: .curveEaseOut) {
            
            let offScreenTransform = topCard.transform.translatedBy(x: 0, y: yTranslation)
            topCard.transform = offScreenTransform
            
        } completion: { _ in
            NotificationCenter.default.post(name: NSNotification.Name("HideSuperLike"), object: nil)
            self.topCardView?.removeFromSuperview()
            self.counter += 1
            guard !self.cardViews.isEmpty else {
                return
            }
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
        }
    }
}

// MARK: - HomeNavigationStackViewProtocol
extension HomeViewController: HomeNavigationStackViewProtocol {
    func showSettings() {
        guard let user = user else {
            return
        }
        let vc = SettingsTableViewController(user: user)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func showMessages() {
        let vc = UIViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

// MARK: - SettingsTableViewControllerDelegate
extension HomeViewController: SettingsTableViewControllerDelegate {
    func settingsControllerWantsToLogOut(_ controller: SettingsTableViewController) {
        controller.dismiss(animated: true)
        logOut()
    }
    
    func settingsController(_ controller: SettingsTableViewController, wantsToUpdate user: User) {
        controller.dismiss(animated: true)
        self.user = user
        //        fetchUsers()
    }
}
// MARK: - CardViewDelegate
extension HomeViewController: CardViewDelegate {
    func cardView(_ view: CardView, wantsToShowProfileFor user: User) {
        let vc = ProfileViewController(user: user)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: - BottomControlsStackViewDelegate
extension HomeViewController: BottomControlsStackViewDelegate {
    func tapLikeButton() {
        guard let topCard = topCardView else {
            return
        }
        
        performSwipeAnimationLikeAndDislike(topCard: topCard, shouldLike: true, count: counter)
    }
    
    func tapDislikeButton() {
        guard let topCard = topCardView else {
            return
        }
        performSwipeAnimationLikeAndDislike(topCard: topCard, shouldLike: false, count: counter)
    }
    
    func tapSuperLikeButton() {
        guard let topCard = topCardView else {
            return
        }
        performSwipeAnimationSuperLike(topCard: topCard)
    }
    
    func tapRevertButton() {
        
    }
}
