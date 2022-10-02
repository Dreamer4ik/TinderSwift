//
//  Service.swift
//  TinderSwift
//
//  Created by Ivan Potapenko on 10.09.2022.
//

import Foundation
import FirebaseStorage
import Firebase

struct Service {
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else {
                return
            }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(currentUser: User, completion: @escaping([User]) -> Void) {
        var users = [User]()
        let minAge = currentUser.minSeekingAge
        let maxAge = currentUser.maxSeekingAge
        
        let query = COLLECTION_USERS
            .whereField("age", isGreaterThanOrEqualTo: minAge)
            .whereField("age", isLessThanOrEqualTo: maxAge)
        
        query.getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                return
            }
            snapshot.documents.forEach({ document in
                
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                
                if let userid = Auth.auth().currentUser?.uid {
                   if user.uid != userid {
                      users.append(user)
                   }
                }
                
                completion(users)
            })
        }
    }
    
    static func saveUserData(user: User, completion: @escaping(Error?) -> Void) {
        let data = [
            "fullname": user.name,
            "imageURLs": user.imageURLs,
            "uid": user.uid,
            "age": user.age,
            "bio": user.bio,
            "profession": user.profession,
            "minSeekingAge": user.minSeekingAge,
            "maxSeekingAge": user.maxSeekingAge
        ] as [String : Any]
        
        COLLECTION_USERS.document(user.uid).setData(data,completion: completion)
    }
    
    static func saveSwipe(forUser user: User, isLike: Swipe) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        COLLECTION_SWIPES.document(uid).getDocument { snapshot, error in
            let data = [user.uid: isLike.swipeType]
            
            if snapshot?.exists == true {
                COLLECTION_SWIPES.document(uid).updateData(data)
            } else {
                COLLECTION_SWIPES.document(uid).setData(data)
            }
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
