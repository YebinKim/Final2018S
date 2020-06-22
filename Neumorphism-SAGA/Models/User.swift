//
//  User.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/09.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit
import Firebase

struct User {
    
    let uid: String
    let email: String
    let isAnonymous: Bool
    
    init(authData: Firebase.User) {
        self.uid = authData.uid
        self.email = authData.email!
        self.isAnonymous = authData.isAnonymous
    }
    
    init(uid: String, email: String, isAnonymous: Bool) {
        self.uid = uid
        self.email = email
        self.isAnonymous = isAnonymous
    }
    
}
