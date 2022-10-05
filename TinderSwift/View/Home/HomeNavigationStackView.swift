//
//  HomeNavigationStackView.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 31.08.2022.
//

import UIKit

protocol HomeNavigationStackViewProtocol: AnyObject {
    func showSettings()
    func showMessages()
}

class HomeNavigationStackView: UIStackView {
    
    // MARK: - Properties
    weak var delegate: HomeNavigationStackViewProtocol?
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let tinderIcon = UIImageView(image: UIImage(named: "tinder_logo")?.withRenderingMode(.alwaysTemplate))
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        tinderIcon.contentMode = .scaleAspectFit
        tinderIcon.tintColor = #colorLiteral(red: 0.9826375842, green: 0.3476698399, blue: 0.447683692, alpha: 1)
        
        settingsButton.setImage(UIImage(named: "top_left_profile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(UIImage(named: "top_right_messages")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingsButton, UIView(), tinderIcon, UIView(), messageButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        settingsButton.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
        messageButton.addTarget(self, action: #selector(didTapMessage), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapSettings() {
        delegate?.showSettings()
    }
    
    @objc private func didTapMessage() {
        delegate?.showMessages()
    }
}
