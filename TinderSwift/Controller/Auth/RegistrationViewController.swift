//
//  RegistrationViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 06.09.2022.
//

import UIKit

class RegistrationViewController: UIViewController {

    // MARK: - Properties
    
    private let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let fullnameTextField = CustomTextField(placeholder: "Full Name")
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureField: true)
    private let signUpButton = AuthButton(title: "Sign Up", type: .system)
    
    private let goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Already have an account?  ",
                                                       attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)])
        
        attributedText.append(NSAttributedString(string: "Sign In",
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
    
    func configureUI() {
        configureGradientLayer()
        addSubviews()
        selectPhotoButton.addTarget(self, action: #selector(didTapSelectPhoto), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        goToLoginButton.addTarget(self, action: #selector(didTapGoToLogin), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(selectPhotoButton)
        view.addSubview(emailTextField)
        view.addSubview(fullnameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        view.addSubview(goToLoginButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        selectPhotoButton.sizeToFit()
//        selectPhotoButton.center = view.center
        let sizeSelectPhoto: CGFloat = 275
        selectPhotoButton.frame = CGRect(
            x: (view.width - sizeSelectPhoto)/2,
            y: view.safeAreaInsets.top + 8,
            width: sizeSelectPhoto,
            height: sizeSelectPhoto
        )
        
        emailTextField.frame = CGRect(
            x: 32,
            y: selectPhotoButton.bottom + 16,
            width: view.width - 64,
            height: 50
        )
        
        fullnameTextField.frame = CGRect(
            x: 32,
            y: emailTextField.bottom + 16,
            width: view.width - 64,
            height: 50
        )
        
        passwordTextField.frame = CGRect(
            x: 32,
            y: fullnameTextField.bottom + 16,
            width: view.width - 64,
            height: 50
        )
        
        signUpButton.frame = CGRect(
            x: 32,
            y: passwordTextField.bottom + 16,
            width: view.width - 64,
            height: 50
        )
        
        goToLoginButton.frame = CGRect(
            x: 32,
            y: view.height - view.safeAreaInsets.bottom - goToLoginButton.height,
            width: view.width - 64,
            height: 50
        )
    }
    
    // MARK: - Actions
    @objc private func didTapSelectPhoto() {
        
    }
    
    @objc private func didTapSignUp() {
        
    }
    
    @objc private func didTapGoToLogin() {
        navigationController?.popViewController(animated: true)
    }
}
