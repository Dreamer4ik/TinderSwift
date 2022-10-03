//
//  MatchView.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 03.10.2022.
//

import UIKit

class MatchView: UIView {
    private let currentUser: User
    private let matchedUser: User
    
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        super.init(frame: .zero)
        
        backgroundColor = .systemPurple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
