//
//  ProfileViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 25.09.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let user: User
    private var collectionView: UICollectionView?
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dismiss_down_arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Ivan iOS - 32"
        return label
    }()
    
    private let professionLabel: UILabel = {
        let label = UILabel()
        label.text = "Developer"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "I develop tinder"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let dislikeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "dismiss_circle")
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let superlikeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "super_like_circle")
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "like_circle")
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    // MARK: Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        configureUI()
        
        print(user.name)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: view.width + 100
        )
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .systemTeal
        dismissButton.addTarget(self, action: #selector(didTapDismissButton), for: .touchUpInside)
        view.addSubview(dismissButton)
        
        dismissButton.setDimensions(height: 40, width: 40)
        dismissButton.anchor(top: collectionView?.bottomAnchor, right: view.rightAnchor,
                             paddingTop: -20, paddingRight: 16)
        
        let infoStack = UIStackView(arrangedSubviews: [infoLabel, professionLabel, bioLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        
        view.addSubview(infoStack)
        infoStack.anchor(top: collectionView?.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        configureBottomControls()
    }
    
    private func configureBottomControls() {
        dislikeButton.addTarget(self, action: #selector(didTapDislikeButton), for: .touchUpInside)
        superlikeButton.addTarget(self, action: #selector(didTapSuperlikeButton), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [dislikeButton, superlikeButton, likeButton])
        stack.spacing = -32
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.setDimensions(height: 80, width: 300)
        stack.centerX(inView: view)
        stack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 32)
        
    }
    
    private func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    // MARK: - Actions
    @objc private func didTapDismissButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapDislikeButton() {
        
    }
    
    @objc private func didTapSuperlikeButton() {
        
    }
    
    @objc private func didTapLikeButton() {
        
    }
}

// MARK: UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileCollectionViewCell.identifier,
            for: indexPath
        ) as? ProfileCollectionViewCell else {
            preconditionFailure("Error ProfileCollectionViewCell")
        }
        if indexPath.row == 0 {
            cell.backgroundColor = .orange
        }
        else {
            cell.backgroundColor = .red
        }
        return cell
    }
     
}

// MARK: UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user.imageURLs.count
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.width, height: view.width + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
