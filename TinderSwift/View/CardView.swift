//
//  CardView.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 01.09.2022.
//

import UIKit
import SDWebImage

enum SwipeDirection: Int {
    case left = -1
    case right = 1
    case top = 2
}

protocol CardViewDelegate: AnyObject {
    func cardView(_ view: CardView, wantsToShowProfileFor user: User)
}

class CardView: UIView {
    // MARK: - Properties
    weak var delegate: CardViewDelegate?
    
    private let gradientLayer = CAGradientLayer()
    private let barStackView = UIStackView()
    private let viewModel: CardViewModel
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    private var likeLabel: UILabel = {
        let label = UILabel()
        label.text = "LIKE"
        label.textColor = UIColor(hue: 0.3333, saturation: 1, brightness: 0.75, alpha: 1.0)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 55, weight: .bold)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.layer.borderWidth = 5
        label.layer.borderColor = UIColor(hue: 0.3333, saturation: 1, brightness: 0.75, alpha: 1.0).cgColor
        label.isHidden = true
        return label
    }()
    
    private let nopeLabel: UILabel = {
        let label = UILabel()
        label.text = "NOPE"
        label.textColor = UIColor(hue: 0.9833, saturation: 0.64, brightness: 0.98, alpha: 1.0)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 55, weight: .heavy)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.layer.borderWidth = 5
        label.layer.borderColor = UIColor(hue: 0.9833, saturation: 0.64, brightness: 0.98, alpha: 1.0).cgColor
        label.isHidden = true
        return label
    }()
    
    private let superLikeLabel: UILabel = {
        let label = UILabel()
        label.text = "SUPER\n LIKE"
        label.numberOfLines = 2
        label.textColor = UIColor(hue: 0.5889, saturation: 0.66, brightness: 1, alpha: 1.0)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 56, weight: .bold)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.layer.borderWidth = 5
        label.layer.borderColor = UIColor(hue: 0.5889, saturation: 0.66, brightness: 1, alpha: 1.0).cgColor
        label.isHidden = true
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "info_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureGestureRecognizers()
        
        imageView.sd_setImage(with: viewModel.imageUrl)
        
        infoLabel.attributedText = viewModel.userInfoText
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageView.fillSuperview() // or in layoutSubviews imageView.frame = bounds
        
        addSubviews()
        
        infoLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                         paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        infoButton.setDimensions(height: 40, width: 40)
        infoButton.centerY(inView: infoLabel)
        infoButton.anchor(right: rightAnchor, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(imageView)
        configureBarStackView()
        configureGradientLayer()
        addSubview(likeLabel)
        addSubview(nopeLabel)
        addSubview(superLikeLabel)
        addSubview(infoLabel)
        addSubview(infoButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        
        
        likeLabel.rotation = -15
        likeLabel.sizeToFit()
        likeLabel.center = center.applying(.init(translationX: -center.x + 85, y: -258))
        likeLabel.bounds = CGRect(x: likeLabel.left, y: likeLabel.top, width: 150, height: 60)
        
        nopeLabel.rotation = 15
        nopeLabel.sizeToFit()
        nopeLabel.center = center.applying(.init(translationX: center.x - 95 , y: -258))
        nopeLabel.bounds = CGRect(x: nopeLabel.left, y: nopeLabel.top, width: 170, height: 60)
        
        superLikeLabel.rotation = -15
        superLikeLabel.sizeToFit()
        superLikeLabel.center = center.applying(.init(translationX: center.x - 200  , y: 160))
        superLikeLabel.bounds = CGRect(x: superLikeLabel.left, y: superLikeLabel.top, width: 220, height: 135)
        
        infoButton.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
        
        // #First try
        //        likeLabel.frame = CGRect(
        //            x: 5,
        //            y: top + 47.32,
        //            width: 160,
        //            height: 20
        //        )
        //        nopeLabel.frame = CGRect(
        //            x: width - 170,
        //            y: top + 10,
        //            width: 150,
        //            height: 100
        //        )
        //        superLikeLabel.frame = CGRect(
        //            x: (width - superLikeLabel.width)/2,
        //            y: infoLabel.top - 90,
        //            width: 250,
        //            height: 70
        //        )
        
        
    }
    
    // MARK: - Actions
    
    @objc private func didTapInfoButton() {
        delegate?.cardView(self, wantsToShowProfileFor: viewModel.user)
    }
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            superview?.subviews.forEach({
                $0.layer.removeAllAnimations()
            })
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default:
            break
        }
    }
    
    @objc private func handleChangePhoto(sender: UITapGestureRecognizer) {
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto = location > width/2
        
        if shouldShowNextPhoto {
            viewModel.showNextPhoto()
        }
        else {
            viewModel.showPreviousPhoto()
        }
        
        imageView.sd_setImage(with: viewModel.imageUrl)
        barStackView.arrangedSubviews.forEach({
            $0.backgroundColor = .barDeselectedColor
        })
        barStackView.arrangedSubviews[viewModel.index].backgroundColor = .white
    }
    
    // MARK: - Helpers
    func panCard(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = -degrees * .pi / 180
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
        showLabelWithFeel(sender: sender)
    }
    
    func showLabelWithFeel(sender: UIPanGestureRecognizer) {
        let direction = sender.translation(in: nil).x
        let directionForTop = sender.translation(in: nil).y
        
        if direction > 0 {
            likeLabel.alpha = abs(direction/300)
            likeLabel.isHidden = false
            nopeLabel.isHidden = true
            superLikeLabel.isHidden = true
        }
        else if directionForTop < 0 {
            superLikeLabel.alpha = abs(directionForTop/300)
            superLikeLabel.isHidden = false
            likeLabel.isHidden = true
            nopeLabel.isHidden = true
        }
        else {
            nopeLabel.alpha = abs(direction/300)
            nopeLabel.isHidden = false
            likeLabel.isHidden = true
            superLikeLabel.isHidden = true
        }
    }
    
    func resetCardPosition(sender: UIPanGestureRecognizer) {
        let direction: SwipeDirection = sender.translation(in: nil).x > 100 ? .right : .left
        let shouldDismissCard = abs(sender.translation(in: nil).x) > 150
        
        let shouldDismissCardForTop = sender.translation(in: nil).y < -300
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.1, options: .curveEaseOut) {
            
            if shouldDismissCard {
                let xTranslation = CGFloat(direction.rawValue) * 1000
                let offScreenTransform = self.transform.translatedBy(x: xTranslation, y: 0)
                self.transform = offScreenTransform
            }
            else if shouldDismissCardForTop {
                let directionTop: SwipeDirection = .top
                let yTranslation = CGFloat(direction.rawValue) * 1000
                let offScreenTransform = self.transform.translatedBy(x: 0, y: yTranslation)
                self.transform = offScreenTransform
            }
            else {
                self.transform = .identity
                self.nopeLabel.isHidden = true
                self.likeLabel.isHidden = true
                self.superLikeLabel.isHidden = true
            }
        } completion: { _ in
            if shouldDismissCard || shouldDismissCardForTop {
                self.removeFromSuperview()
            }
        }
        
    }
    
    func configureBarStackView() {
        (0..<viewModel.imageURLs.count).forEach({ _ in
            let barView = UIView()
            barView.backgroundColor = .barDeselectedColor
            barStackView.addArrangedSubview(barView)
        })
        
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        addSubview(barStackView)
        barStackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,
                            paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 4)
        
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
    }
    
    func configureGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    func configureGestureRecognizers() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        addGestureRecognizer(tap)
    }
}
