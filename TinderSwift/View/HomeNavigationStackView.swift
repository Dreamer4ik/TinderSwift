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
        tinderIcon.tintColor = UIColor(hue: 0.975, saturation: 0.61, brightness: 0.9, alpha: 1.0)
//        tinderIcon.tintColor = UIColor(hue: 0.9861, saturation: 0.58, brightness: 0.89, alpha: 1.0)
        
        settingsButton.setImage(UIImage(named: "top_left_profile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(UIImage(named: "top_right_messages")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingsButton, UIView(), tinderIcon, UIView(), messageButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        settingsButton.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(didTapMessage), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapSettings() {
        delegate?.showMessages()
    }
    
    @objc private func didTapMessage() {
        delegate?.showSettings()
    }
}
