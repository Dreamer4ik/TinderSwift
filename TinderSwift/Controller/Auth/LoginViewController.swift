//
//  LoginViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 06.09.2022.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Properties
    private var viewModel = LoginViewModel()
    
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
        configureTextFieldObservers()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            authButton.isEnabled = false
            authButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
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
    
    func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // MARK: - Actions
    
    @objc private func didTapLogIn() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        AuthService.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error user log in \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true)
        }
    }
    
    @objc private func didTapRegistration() {
        let vc = RegistrationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        checkFormStatus()
    }
}
