//
//  UserInfo.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/09.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit
import Firebase

struct UserInfo {
    
    let ref: DatabaseReference?
    let key: String
    
    var email: String
    var name: String
    var profilePic: String?
    var maxScore: Int?
    var playCounts: Int?
    
    init(email: String, name: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.email = email
        self.name = name
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let email = value["email"] as? String,
            let name = value["name"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.email = email
        self.name = name
    }
    
    func toAnyObject() -> Any {
        return [
            "email": email,
            "name": name
        ]
    }
    
}
