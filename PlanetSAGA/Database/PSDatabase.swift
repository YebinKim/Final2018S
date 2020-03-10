//
//  PSDatabase.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/09.
//  Copyright © 2020 김예빈. All rights reserved.
//

import Foundation
import Firebase

class PSDatabase: NSObject {
    
    static var userRef: DatabaseReference {
        Database.database().reference(withPath: "online")
    }
    
    static var userInfoRef: DatabaseReference {
        Database.database().reference(withPath: "userInfo")
    }
    
//    let usersRef = Database.database().reference(withPath: "online")
    
//    func addUserInfo(userInfo: UserInfo) {
//         let itemRef = self.userInfoRef.child("list")
//         itemRef.setValue(userInfo)
//    }
    
}
