//
//  MessageMatchHeaderCollectionReusableView.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 05.10.2022.
//

import UIKit

class MessageMatchHeaderCollectionReusableView: UICollectionReusableView {
    
    private let newMatchLabel: UILabel = {
        let label = UILabel()
        label.text = "New Matches"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.9826375842, green: 0.3476698399, blue: 0.447683692, alpha: 1)
        return label
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(MessageMatchCollectionViewCell.self, forCellWithReuseIdentifier: MessageMatchCollectionViewCell.identifier)
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(newMatchLabel)
        newMatchLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(collectionView)
        collectionView.anchor(top: newMatchLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                              paddingTop: 4, paddingLeft: 12, paddingBottom: 24, paddingRight: 12)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MessageMatchHeaderCollectionReusableView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageMatchCollectionViewCell.identifier, for: indexPath
        ) as? MessageMatchCollectionViewCell else {
            preconditionFailure("MessageMatchHeaderCollectionReusableView Error")
        }
        
        return cell
    }
}

extension MessageMatchHeaderCollectionReusableView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 108)
    }
}
