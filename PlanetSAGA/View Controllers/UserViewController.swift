//
//  UserViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 22..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class UserViewController: UIViewController {
    
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = Auth.auth().currentUser {
            PSDatabase.userInfoRef
                .queryEqual(toValue: nil, childKey: user.uid)
                .observeSingleEvent(of: .value, with: { snapshot in
                    guard let child = snapshot.children.allObjects.first,
                        let snapshot = child as? DataSnapshot,
                        let userInfo = UserInfo(snapshot: snapshot) else { return }
                    
                    self.userLabel.text = userInfo.name
                    
                    let storageRef = PSDatabase.storageRef.child(user.uid)
                    
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        } else {
                            self.userImage.image = UIImage(data: data!)
                        }
                    }
                })
        }
        
        // 프로필사진 다시 불러오기
        //        var imageName = appDelegate.userProfilePic // 숫자.jpg 로 저장된 파일 이름
        //        if (imageName != "") {
        //            let urlString = "http://condi.swu.ac.kr/student/W02iphone/"
        //            imageName = urlString + imageName!
        //            let url = URL(string: imageName!)!
        //            if let imageData = try? Data(contentsOf: url) {
        //                userImage.image = UIImage(data: imageData)
        //                // 웹에서 파일 이미지를 접근함
        //            }
        //        }
    }
    
    @IBAction func buttonLogoutPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Logout?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        SoundManager.clickEffect()
    }
}
