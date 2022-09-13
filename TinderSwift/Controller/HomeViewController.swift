//
//  ViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 31.08.2022.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 5
        return view
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chechUserIsLoggedIn()
        configureUI()
        configureCards()
        fetchUser()
//        logOut()
    }
    
    // MARK: - API
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Service.fetchUser(withUid: uid) { user in
            print("Execute User...")
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
    
    private func configureCards() {
        let images1 = [UIImage(named: "jane1"), UIImage(named: "jane2"), UIImage(named: "jane3")].compactMap({$0})
        let user1 = User(name: "Jane Doe", age: 22, images: images1)
        let images2 = [UIImage(named: "kelly1"), UIImage(named: "kelly2"), UIImage(named: "kelly3")].compactMap({$0})
        let user2 = User(name: "Kelly", age: 21, images: images2)
        
        let cardView1 = CardView(viewModel: CardViewModel(user: user1))
        let cardView2 = CardView(viewModel: CardViewModel(user: user2))
        //        let cardView3 = CardView()
        //        let cardView4 = CardView()
        //        let cardView5 = CardView()
        
        deckView.addSubview(cardView1)
        deckView.addSubview(cardView2)
        //        deckView.addSubview(cardView3)
        //        deckView.addSubview(cardView4)
        //        deckView.addSubview(cardView5)
        
        cardView1.fillSuperview()
        cardView2.fillSuperview()
        //        cardView3.fillSuperview()
        //        cardView4.fillSuperview()
        //        cardView5.fillSuperview()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
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
}

