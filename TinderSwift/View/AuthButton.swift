//
//  AuthButton.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 08.09.2022.
//

import UIKit

class AuthButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 5
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
