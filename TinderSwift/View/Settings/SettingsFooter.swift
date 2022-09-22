//
//  SettingsFooter.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 22.09.2022.
//

import UIKit

protocol SettingsFooterDelegate: AnyObject {
    func logOut()
}

class SettingsFooter: UIView {
    
    // MARK: - Properties
    weak var delegate: SettingsFooterDelegate?
    
    private let logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    private let spacer = UIView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logOutButton)
        
        spacer.backgroundColor = .systemGroupedBackground
        addSubview(spacer)
        spacer.setDimensions(height: 32, width: width)
        
        logOutButton.addTarget(self, action: #selector(didTapLogOut), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logOutButton.frame = CGRect(
            x: 0,
            y: spacer.bottom,
            width: width,
            height: 50
        )
    }
    
    // MARK: - Actions
    @objc private func didTapLogOut() {
        delegate?.logOut()
    }
}
