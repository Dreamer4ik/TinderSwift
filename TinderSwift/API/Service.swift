//
//  Service.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 10.09.2022.
//

import Foundation
import FirebaseStorage

struct Service {
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            print(snapshot?.data())
        }
    }
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            return
        }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else {
                    return
                }
                completion(imageUrl)
            }
        }
    }
}
