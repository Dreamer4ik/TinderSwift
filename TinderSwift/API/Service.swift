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
        
        fetchSwipes { swipedUserIDs in
            query.getDocuments { snapshot, error in
                guard let snapshot = snapshot else {
                    return
                }
                snapshot.documents.forEach({ document in
                    
                    let dictionary = document.data()
                    let user = User(dictionary: dictionary)
                    
                    if let userid = Auth.auth().currentUser?.uid {
                        if user.uid != userid, swipedUserIDs[user.uid] == nil {
                            users.append(user)
                        }
                    }
                })
                completion(users)
            }
        }
    }
    
    static func fetchSwipes(completion: @escaping([String: Int]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        COLLECTION_SWIPES.document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() as? [String: Int] else {
                completion([String: Int]())
                return
            }
            completion(data)
        }
    }
    
    static func fetchMatches(completion: @escaping([Match]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        COLLECTION_MATCHES.document(uid).collection("matches").getDocuments { snapshot, error in
            guard let data = snapshot else {
                return
            }
            
            let matches = data.documents.map({
                Match(dictionary: $0.data())
            })
            
            completion(matches)
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
    
    static func saveSwipe(forUser user: User, isLike: Swipe, completion: ((Error?) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        COLLECTION_SWIPES.document(uid).getDocument { snapshot, error in
            let data = [user.uid: isLike.swipeType]
            
            if snapshot?.exists == true {
                COLLECTION_SWIPES.document(uid).updateData(data, completion: completion)
            } else {
                COLLECTION_SWIPES.document(uid).setData(data, completion: completion)
            }
        }
    }
    
    static func checkIfMatchExists(forUser user: User, completion: @escaping(Int) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            return
        }
        
        COLLECTION_SWIPES.document(user.uid).getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let didMatch = data[currentUid] as? Int else {
                return
            }
            completion(didMatch)
        }
    }
    
    static func uploadMatch(currentUser: User, matchedUser: User) {
        guard let profileImageURL = matchedUser.imageURLs.first,
              let currentUserProfileImageURL = currentUser.imageURLs.first else {
            return
        }
        
        let matchedUserData = [
            "uid:": matchedUser.uid,
            "name": matchedUser.name,
            "profileImageURL": profileImageURL
        ]
        
        COLLECTION_MATCHES.document(currentUser.uid).collection("matches")
            .document(matchedUser.uid).setData(matchedUserData)
        
        let currentUserData = [
            "uid:": currentUser.uid,
            "name": currentUser.name,
            "profileImageURL": currentUserProfileImageURL
        ]
        
        COLLECTION_MATCHES.document(matchedUser.uid).collection("matches")
            .document(currentUser.uid).setData(currentUserData)
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
