//
//  RegistrationViewController.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 06.09.2022.
//

import UIKit
import JGProgressHUD

class RegistrationViewController: UIViewController {
    // MARK: - Properties
    
    weak var delegate: AuthenticationDelegate?
    private var viewModel = RegistrationViewModel()
    
    private let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email", isEmailField: true)
    private let fullnameTextField = CustomTextField(placeholder: "Full Name")
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureField: true)
    
    private let signUpButton : AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        return button
    }()
    
    private var profileImage: UIImage?
    
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
        configureTextFieldObservers()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
    func configureUI() {
        configureGradientLayer()
        addSubviews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapDismiss))
        view.addGestureRecognizer(tap)
        
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
    
    func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // MARK: - Actions
    @objc private func didTapSelectPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func didTapSignUp() {
        guard let email = emailTextField.text,
              let fullname = fullnameTextField.text,
              let password = passwordTextField.text,
              let image = profileImage else {
            return
        }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading..."
        hud.show(in: view)
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, profileImage: image)
        AuthService.registerUser(withCredentials: credentials) { error in
            if let error = error {
                print("Error signing user up \(error.localizedDescription)")
                hud.dismiss()
                return
            }
            hud.dismiss()
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc private func didTapGoToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        else if sender == passwordTextField {
            viewModel.password = sender.text
        } else {
            viewModel.fullname = sender.text
        }
        checkFormStatus()
    }
    
    @objc private func didTapDismiss() {
        view.endEditing(true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        selectPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        selectPhotoButton.layer.borderWidth = 3
        selectPhotoButton.layer.cornerRadius = 10
        selectPhotoButton.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true)
    }
}
