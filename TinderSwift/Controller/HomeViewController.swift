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
    
    private var viewModels = [CardViewModel]() {
        didSet {
            configureCards()
        }
    }
    
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
        fetchUsers()
//        fetchUser()
//        logOut()
    }
    
    // MARK: - API
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Service.fetchUser(withUid: uid) { user in
            print("Execute User...\(user)")
        }
    }
    
    private func fetchUsers() {
        Service.fetchUsers { users in
            self.viewModels = users.map({
                CardViewModel(user: $0)
            })
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
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        topStack.delegate = self
        
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

extension HomeViewController: HomeNavigationStackViewProtocol {
    func showSettings() {
        let vc = SettingsTableViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func showMessages() {
        
    }
}
