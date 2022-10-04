//
//  MatchViewViewModel.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 04.10.2022.
//

import Foundation

struct MatchViewViewModel {
    private let currentUser: User
    let matchedUser: User
    
    let matchLabelText: String
    
    let currentUserImageURL: URL?
    let matchedUserImageURL: URL?
    
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        matchLabelText = "You and \(matchedUser.name) have liked each other!"
        currentUserImageURL = URL(string: currentUser.imageURLs.first ?? "")
        matchedUserImageURL = URL(string: matchedUser.imageURLs.first ?? "")
    }
}
