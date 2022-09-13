//
//  TransitionViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 12.09.2022.
//

import UIKit
import MTTransitions

class TransitionViewController: UIViewController {
    
    private let transition = MTViewControllerTransition(effect: .wipeRight)
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tinder_Launch")?.withRenderingMode(.alwaysOriginal)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientLayer()
        view.addSubview(iconImageView)
        transitionVC()
    }
    
    func transitionVC() {
        DispatchQueue.main.async {
            let vc = HomeViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.transitioningDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let iconWidth: CGFloat = 200
        let iconHeight: CGFloat = 100
        iconImageView.frame = CGRect(
            x: (view.width - iconWidth)/2,
            y: (view.height - iconHeight)/2,
            width: iconWidth,
            height: iconHeight
        )
    }
}

extension TransitionViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}
