//
//  Match.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 06.10.2022.
//

import Foundation

struct Match {
    let name: String
    let profileImageURL: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
