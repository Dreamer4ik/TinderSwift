//
//  Swipe.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 01.10.2022.
//

import Foundation

struct Swipe: Codable {
    let swipeType: Int // 0: dislike, 1: like, 2: superlike
    
    init(swipeType: Int) {
        self.swipeType = swipeType
    }
}
