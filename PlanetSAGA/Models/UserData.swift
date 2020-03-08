//
//  UserData.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 6. 17..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit

class UserData: NSObject {
    // 모든 자료는 입력 전에 nil 인지 확인하게 됨
    // 모든 자료가 nil이 아니므로 Optional 타입이 아니며
    // 이 경우, init() 함수를 정의하던지 초기값을 주어야 함
    var id: String = ""
    var pw: String = ""
    var name: String = ""
    var profilePic: String = ""
    var maxScore: String = ""
    var playCounts: String = ""
}
