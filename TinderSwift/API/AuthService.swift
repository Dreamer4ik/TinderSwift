//
//  AuthService.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 10.09.2022.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let profileImage: UIImage
}

struct AuthService {
    
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping((Error?)-> Void)) {
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
            if let error = error {
                print("Error user signing up \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else {
                return
            }
            
            Service.uploadImage(image: credentials.profileImage) { imageUrl in
                let data = [
                    "email": credentials.email,
                    "fullname": credentials.fullname,
                    "imageURLs": [imageUrl],
                    "uid": uid,
                    "age": 18
                ] as [String : Any]
                
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
        }
    }
}
