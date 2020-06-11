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
    
    let nameKey: String = "name"
    let profileImageURLKey: String = "profileImageURL"
    let maxScoreKey: String = "maxScore"
    let playCountsKey: String = "playCounts"
    
    var name: String = ""
    var profileImageURL: String = ""
    var maxScore: Int = 0
    var playCounts: Int = 0
    
    // cache data
    var profileImage: UIImage?
    
    init(email: String, name: String, key: String = "") {
        self.ref = nil
        self.key = key
        
        self.name = name
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: AnyObject] else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        if let name = value[nameKey] as? String {
            self.name = name
        }
        if let profileImageURL = value[profileImageURLKey] as? String {
            self.profileImageURL = profileImageURL
        }
        if let maxScore = value[maxScoreKey] as? Int {
            self.maxScore = maxScore
        }
        if let playCounts = value[playCountsKey] as? Int {
            self.playCounts = playCounts
        }
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "name": self.name,
            "profileImageURL": self.profileImageURL,
            "maxScore": self.maxScore,
            "playCounts": self.playCounts
        ]
    }
    
    static func toName(name: String) -> [String: Any] {
        return [
            "name": name
        ]
    }
    
    static func toProfilePic(profileImageURL: String) -> [String: Any] {
        return [
            "profileImageURL": profileImageURL
        ]
    }
    
    static func toPlayScore(maxScore: Int, playCounts: Int) -> [String: Any] {
        return [
            "maxScore": maxScore,
            "playCounts": playCounts
        ]
    }
    
}
