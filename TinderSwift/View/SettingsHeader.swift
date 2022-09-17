//
//  SettingsHeader.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 16.09.2022.
//

import UIKit

protocol SettingsHeaderDelegate: AnyObject {
    func settingsHeader(_ header: SettingsHeader, didSelect index: Int)
}

class SettingsHeader: UIView {
    
    // MARK: - Properties
    weak var delegate: SettingsHeaderDelegate?
    var buttons = [UIButton]()
    private var button1 = UIButton()
    private var button2 = UIButton()
    private var button3 = UIButton()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGroupedBackground
        
        button1 = createButton(0)
        button2 = createButton(1)
        button3 = createButton(2)
        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        
        addSubview(button1)
        button1.anchor(top: topAnchor, left: leftAnchor,bottom: bottomAnchor,
                       paddingTop: 16 ,paddingLeft: 16 ,paddingBottom: 16)
        button1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [button2, button3])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: button1.rightAnchor, bottom: bottomAnchor,
                     right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func didTapSelectPhoto(sender: UIButton) {
        delegate?.settingsHeader(self, didSelect: sender.tag)
    }
    
    // MARK: - Helpers
    private func createButton(_ index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(didTapSelectPhoto), for: .touchUpInside)
        button.tag = index
        return button
    }
}
