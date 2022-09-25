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
    private var user: User?
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()
    
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
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chechUserIsLoggedIn()
        configureUI()
        fetchUsers()
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
            cardView.delegate = self
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
