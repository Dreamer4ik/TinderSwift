//
//  ProfileViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 25.09.2022.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func profileController(_ controller: ProfileViewController, didLikeUser user: User)
    func profileController(_ controller: ProfileViewController, didDislikeUser user: User)
    func profileController(_ controller: ProfileViewController, didSuperlikeUser user: User)
}

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: ProfileViewControllerDelegate?
    private let user: User
    private var collectionView: UICollectionView?
    private var barStackView: SegmentedBarView?
    private var viewModel: ProfileViewModel?
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dismiss_down_arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let professionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        self.viewModel = ProfileViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
        
        barStackView = SegmentedBarView(numberOfSegments: viewModel?.imageURLs.count ?? 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        configureUI()
        loadUserData()
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
    private func loadUserData() {
        infoLabel.attributedText = viewModel?.userDetailsAttributedString
        professionLabel.text = viewModel?.profession
        bioLabel.text = viewModel?.bio
    }
    
    private func configureUI() {
        view.backgroundColor = .white
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
        
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.topAnchor,
                        right: view.rightAnchor)
        
        configureBottomControls()
        configureBarStackView()
    }
    
    private func configureBarStackView() {
        if let stack = barStackView {
            view.addSubview(stack)
        }
        barStackView?.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                             paddingTop: 56, paddingLeft: 8, paddingRight: 8, height: 4)
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
        delegate?.profileController(self, didDislikeUser: user)
    }
    
    @objc private func didTapSuperlikeButton() {
        delegate?.profileController(self, didSuperlikeUser: user)
    }
    
    @objc private func didTapLikeButton() {
        delegate?.profileController(self, didLikeUser: user)
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
        
        if let viewModel = viewModel {
            cell.configure(viewModel: viewModel, index: indexPath.row)
        }
        
        return cell
    }
     
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        barStackView?.setHighlighted(index: indexPath.row)
    }
}

// MARK: UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.imageCount ?? 0
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
