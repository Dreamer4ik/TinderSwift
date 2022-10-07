//
//  MatchCellViewModel.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 06.10.2022.
//

import Foundation

struct MatchCellViewModel {
    
    let name: String
    var profileImageURL: URL?
    let uid: String
    
    init(match: Match) {
        name = match.name
        profileImageURL = URL(string: match.profileImageURL)
        uid = match.uid
    }
}
