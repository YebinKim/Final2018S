//
//  PSDatabase.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/09.
//  Copyright © 2020 김예빈. All rights reserved.
//

import Foundation
import Firebase

class PSDatabase {
    
    var ref: DatabaseReference {
        Database.database().reference()
    }
    
    func addUserData(userData: UserData) {
         let itemRef = self.ref.child("list")
         itemRef.setValue(userData)
    }
    
}
