//
//  AuthenticationViewModel.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 09.09.2022.
//

import Foundation

protocol AuthenticationViewModelProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationViewModelProtocol {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false &&
        password?.isEmpty == false
    }
}

struct RegistrationViewModel: AuthenticationViewModelProtocol {
    var email: String?
    var fullname: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false &&
        password?.isEmpty == false &&
        fullname?.isEmpty == false
    }
}
