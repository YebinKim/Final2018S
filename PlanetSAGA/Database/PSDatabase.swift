//
//  PSDatabase.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/09.
//  Copyright © 2020 김예빈. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class PSDatabase: NSObject {
    
    static var userRef: DatabaseReference {
        Database.database().reference(withPath: "online")
    }
    
    static var userInfoRef: DatabaseReference {
        Database.database().reference(withPath: "userInfo")
    }
    
    static var scoreRef: DatabaseReference {
        Database.database().reference(withPath: "score")
    }
    
    static var storageRef: StorageReference {
        Storage.storage().reference()
    }
    
}
