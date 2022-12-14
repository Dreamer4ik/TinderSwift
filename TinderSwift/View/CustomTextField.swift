//
//  CustomTextField.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 08.09.2022.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String, isSecureField: Bool? = false, isEmailField: Bool? = false) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        
        keyboardAppearance = .dark
        autocapitalizationType = .none
        borderStyle = .none
        autocorrectionType = .no
        textColor = .white
        backgroundColor = UIColor(white: 1, alpha: 0.2)
        layer.cornerRadius = 5
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor:
                                                                                        UIColor(white: 1, alpha: 0.7)])
        isSecureTextEntry = isSecureField!
        if isEmailField! {
            keyboardType = .emailAddress
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

