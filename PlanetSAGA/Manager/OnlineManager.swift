//
//  OnlineManager.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/11.
//  Copyright © 2020 김예빈. All rights reserved.
//

import Foundation
import Firebase

class OnlineManager: NSObject {
    
    static var online: Bool = false
    
    static var user: User?
    static var userInfo: UserInfo? {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateUser"), object: nil)
        }
    }
    
    static func registerUser() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AuthStateDidChange, object: Auth.auth(), queue: nil) { _ in
            if let user = Auth.auth().currentUser {
                self.online = true
                self.user = User(authData: user)
                self.updateUserInfo(user.uid)
            } else {
                self.online = false
                self.user = nil
                self.userInfo = nil
            }
        }
    }
    
    static func createUser(email: String, password: String, name: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email,
                               password: password) { user, error in
            if let error = error, user == nil {
                print("Error: \(error.localizedDescription)")
                completion(error)
            } else {
                let userInfo = UserInfo(email: email,
                                        name: name)
                let userInfoRef = PSDatabase.userInfoRef.child(user!.user.uid)
                userInfoRef.setValue(userInfo.toAnyObject())
                
                completion(nil)
            }
        }
    }
    
    static func signInUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { user, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    static func signOutUser() {
        if self.user != nil {
            do {
                try Auth.auth().signOut()
            } catch {
                print("SignOut Error: \(error.localizedDescription)")
            }
        }
    }
    
    static func updateUserInfo(_ uid: String) {
        PSDatabase.userInfoRef
            .queryEqual(toValue: nil, childKey: uid)
            .observeSingleEvent(of: .value, with: { snapshot in
                guard let child = snapshot.children.allObjects.first,
                    let snapshot = child as? DataSnapshot else { return }
                
                self.userInfo = UserInfo(snapshot: snapshot)
                
                let storageRef = PSDatabase.storageRef.child(uid)
                storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error, data == nil {
                        print("Error: \(error.localizedDescription)")
                    } else {
                        self.userInfo?.profileImage = UIImage(data: data!)
                    }
                }
            })
    }
    
}
