//
//  ViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 31.08.2022.
//

import UIKit

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
        configureUI()
        configureCards()
    }
    
    // MARK: - Helpers
    
    func configureCards() {
        let cardView1 = CardView()
        let cardView2 = CardView()
        let cardView3 = CardView()
        let cardView4 = CardView()
        let cardView5 = CardView()
        
        deckView.addSubview(cardView1)
        deckView.addSubview(cardView2)
        deckView.addSubview(cardView3)
        deckView.addSubview(cardView4)
        deckView.addSubview(cardView5)
        
        cardView1.fillSuperview()
        cardView2.fillSuperview()
        cardView3.fillSuperview()
        cardView4.fillSuperview()
        cardView5.fillSuperview()
    }
    
    func configureUI() {
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
}

