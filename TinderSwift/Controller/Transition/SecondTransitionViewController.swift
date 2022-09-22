//
//  SecondTransitionViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 16.09.2022.
//

import UIKit
import Lottie

class SecondTransitionViewController: UIViewController {
    
    let animationView = AnimationView()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tinder")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimation), name: NSNotification.Name(rawValue: "Animation"), object: nil)
        view.backgroundColor = .white
        addSubviews()
    }
    
    private func setupLottieAnimation() {
        animationView.animation = Animation.named("confetti")
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = view.center
        animationView.backgroundColor = .white
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.play { [weak self] _ in
            let vc = HomeViewController()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    private func setupAnimationIcon() {
        iconImageView.frame = CGRect(x: 0, y: 0, width: 65, height: 65)
        iconImageView.center = view.center
        
        let animator = UIViewPropertyAnimator(duration: 0.7, curve: .linear) {
            self.iconImageView.frame = self.iconImageView.frame.offsetBy(dx:25, dy:0)
        }
        
        let animator2 = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) {
            self.iconImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        
        animator.addCompletion { _ in
            animator2.startAnimation()
        }
        
        animator2.addCompletion { [weak self] _ in
            self?.animationView.stop()
        }
        
        animator.startAnimation()
        
    }
    
    private func addSubviews() {
        view.addSubview(animationView)
        view.addSubview(iconImageView)
    }
    
    @objc private func startAnimation() {
        setupLottieAnimation()
        if animationView.isAnimationPlaying {
            setupAnimationIcon()
        }
    }
}
