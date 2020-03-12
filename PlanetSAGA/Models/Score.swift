//
//  Score.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/09.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit
import Firebase

struct Score {
    
    let ref: DatabaseReference?
    let key: String
    
    var score: Int
    var scoreDate: String
    var scoreMemo: String = ""
    
    init(score: Int, scoreDate: String, key: String = "") {
        self.ref = nil
        self.key = key
        
        self.score = score
        self.scoreDate = scoreDate
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let score = value["score"] as? Int,
            let scoreDate = value["scoreDate"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.score = score
        self.scoreDate = scoreDate
    }
    
    func toAnyObject() -> [AnyHashable: Any] {
        return [
            "score": score,
            "scoreDate": scoreDate,
            "scoreMemo": scoreMemo
        ]
    }
    
}
