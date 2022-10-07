//
//  MessageMatchCollectionViewCell.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 05.10.2022.
//

import UIKit
import SDWebImage

class MessageMatchCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "MessageMatchCollectionViewCell"
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        let size: CGFloat = 80
        profileImageView.setDimensions(height: size, width: size)
        profileImageView.layer.cornerRadius = size/2
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, usernameLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 6
        
        addSubview(stack)
        stack.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: MatchCellViewModel) {
        usernameLabel.text = viewModel.name
        if let url = viewModel.profileImageURL {
            profileImageView.sd_setImage(with: url)
        }
    }
}
