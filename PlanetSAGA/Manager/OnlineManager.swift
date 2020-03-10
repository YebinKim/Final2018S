//
//  OnlineManager.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/10.
//  Copyright © 2020 김예빈. All rights reserved.
//

import Foundation
import Firebase

final class OnlineManager: NSObject {
    
    static var user: User?
    
    static func loginUser() {
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let currentUser = self.user, let user = user else { return }
            self.user = User(authData: user)
            
            let currentUserRef = PSDatabase.userRef.child(currentUser.uid)
            currentUserRef.setValue(currentUser.email)
            currentUserRef.onDisconnectRemoveValue()
        }
    }
    
    static func logout() -> Bool {
        guard let user = user else { return false }
        
        let onlineRef = PSDatabase.userRef.child(user.uid)
        onlineRef.removeValue { (error, _) in
            if let error = error {
                print("Removing online failed: \(error)")
                return
            }
            do {
                try Auth.auth().signOut()
            } catch {
                print("Auth sign out failed: \(error)")
                return
            }
        }
        
        return true
    }
    
}
