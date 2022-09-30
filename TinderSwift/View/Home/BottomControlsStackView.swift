//
//  BottomControlsStackView.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 01.09.2022.
//

import UIKit

protocol BottomControlsStackViewDelegate: AnyObject {
    func tapLikeButton()
    func tapDislikeButton()
    func tapSuperLikeButton()
    func tapRevertButton()
}

class BottomControlsStackView: UIStackView {
    
    // MARK: - Properties
    weak var delegate: BottomControlsStackViewDelegate?
    
    let revertButton = UIButton(type: .system)
    let dislikeButton = UIButton(type: .system)
    let superLikeButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)
    let boostButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        distribution = .fillEqually
        
        revertButton.setImage(UIImage(named: "refresh_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        dislikeButton.setImage(UIImage(named: "dismiss_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        superLikeButton.setImage(UIImage(named: "super_like_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(UIImage(named: "like_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        boostButton.setImage(UIImage(named: "boost_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        [revertButton, dislikeButton, superLikeButton, likeButton, boostButton].forEach { view in
            addArrangedSubview(view)
        }
        
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(didTapDislikeButton), for: .touchUpInside)
        superLikeButton.addTarget(self, action: #selector(didTapSuperLikeButton), for: .touchUpInside)
        revertButton.addTarget(self, action: #selector(didTapRevertButton), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func didTapLikeButton() {
        delegate?.tapLikeButton()
    }
    
    @objc private func didTapDislikeButton() {
        delegate?.tapDislikeButton()
    }
    
    @objc private func didTapSuperLikeButton() {
        delegate?.tapSuperLikeButton()
    }
    
    @objc private func didTapRevertButton() {
        delegate?.tapRevertButton()
    }
}
