//
//  LoginViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 06.09.2022.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tinder")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureField: true)
    private let authButton = AuthButton(title: "Log In", type: .system)
    
    private let goToRegistrationButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Don't have an account?  ",
                                                       attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)])
        
        attributedText.append(NSAttributedString(string: "Sign Up",
                                                 attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        configureGradientLayer()
        
//        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, authButton])
//        stack.axis = .vertical
//        stack.spacing = 16
//        view.addSubview(stack)
//        stack.anchor(top: iconImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        
        addSubviews()
        authButton.addTarget(self, action: #selector(didTapLogIn), for: .touchUpInside)
        goToRegistrationButton.addTarget(self, action: #selector(didTapRegistration), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(iconImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(authButton)
        view.addSubview(goToRegistrationButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let sizeIcon: CGFloat = 90
        let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        iconImageView.frame = CGRect(
            x: (view.width - sizeIcon)/2,
            y: height + 32,
            width: sizeIcon,
            height: sizeIcon
        )
        
        emailTextField.frame = CGRect(
            x: 32,
            y: iconImageView.bottom + 24,
            width: view.width - 64,
            height: 50
        )
        
        passwordTextField.frame = CGRect(
            x: 32,
            y: emailTextField.bottom + 16,
            width: view.width - 64,
            height: 50
        )
        
        authButton.frame = CGRect(
            x: 32,
            y: passwordTextField.bottom + 16,
            width: view.width - 64,
            height: 50
        )
        
        goToRegistrationButton.frame = CGRect(
            x: 32,
            y: view.height - view.safeAreaInsets.bottom - goToRegistrationButton.height,
            width: view.width - 64,
            height: 50
        )
    }
    
    @objc private func didTapLogIn() {
        
    }
    
    @objc private func didTapRegistration() {
        let vc = RegistrationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
