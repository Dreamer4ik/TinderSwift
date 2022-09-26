//
//  ProfileCollectionViewCell.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 25.09.2022.
//

import UIKit
import SDWebImage

class ProfileCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProfileCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(viewModel: ProfileViewModel, index: Int) {
        imageView.sd_setImage(with: viewModel.imageURLs[index])
    }
}
