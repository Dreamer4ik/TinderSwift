//
//  MatchView.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 03.10.2022.
//

import UIKit

class MatchView: UIView {
    // MARK: - Properties
    
    private let currentUser: User
    private let matchedUser: User
    private var views: [UIView]?
    
    private let matchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "itsamatch")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "You and Another one have liked eacth other!"
        label.numberOfLines = 0
        return label
    }()
    
    private let currentUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "jane1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let matchedUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kelly1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let sendMessageButton: UIButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    // MARK: Lifecycle
    
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        super.init(frame: .zero)
        
        configureBlurView()
        configureUI()
        
        sendMessageButton.addTarget(self, action: #selector(didTapSendMessageButton), for: .touchUpInside)
        keepSwipingButton.addTarget(self, action: #selector(didTapKeepSwipingButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let currentUserImageSize: CGFloat = 140
        currentUserImageView.anchor(left: centerXAnchor, paddingLeft: 16)
        currentUserImageView.setDimensions(height: currentUserImageSize, width: currentUserImageSize)
        currentUserImageView.layer.cornerRadius = currentUserImageSize/2
        currentUserImageView.centerY(inView: self)
        
        let matchedUserImageSize: CGFloat = 140
        matchedUserImageView.anchor(right: centerXAnchor, paddingRight: 16)
        matchedUserImageView.setDimensions(height: matchedUserImageSize, width: matchedUserImageSize)
        matchedUserImageView.layer.cornerRadius = matchedUserImageSize/2
        matchedUserImageView.centerY(inView: self)
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                 paddingTop: 32, paddingLeft: 48, paddingRight: 48)
        sendMessageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                 paddingTop: 16, paddingLeft: 48, paddingRight: 48)
        keepSwipingButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        descriptionLabel.anchor(left: leftAnchor,bottom: currentUserImageView.topAnchor,
                                right: rightAnchor, paddingBottom: 32)
        
        matchImageView.anchor(bottom: descriptionLabel.topAnchor, paddingBottom: 16)
        matchImageView.setDimensions(height: 80, width: 300)
        matchImageView.centerX(inView: self)
    }
    
    // MARK: Actions
    @objc private func didTapSendMessageButton() {
        
    }
    
    @objc private func didTapKeepSwipingButton() {
        tapDismissMatchView()
    }
    
    @objc private func tapDismissMatchView() {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
            self.blurView.alpha = 0
        }
        animator.addCompletion { _ in
            self.removeFromSuperview()
        }
        animator.startAnimation()
    }
    
    // MARK: Helpers
    private func configureUI() {
         views = [
            matchImageView,
            descriptionLabel,
            currentUserImageView,
            matchedUserImageView,
            sendMessageButton,
            keepSwipingButton
        ]
        
        views?.forEach({ view in
            addSubview(view)
            view.alpha = 1
        })
    }
    
    private func configureBlurView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapDismissMatchView))
        blurView.addGestureRecognizer(tap)
        addSubview(blurView)
        blurView.fillSuperview()
        blurView.alpha = 0
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
            self.blurView.alpha = 1
        }
        animator.startAnimation()
    }
}
