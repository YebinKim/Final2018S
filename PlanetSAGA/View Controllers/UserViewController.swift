//
//  UserViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 22..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import CoreData
import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet var loginUserLabel: UILabel!
    @IBOutlet var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        loginUserLabel.text = appDelegate.userName
        
        // 프로필 사진 불러오기
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        loginUserLabel.text = appDelegate.userName
        
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
            let urlString: String = "http://condi.swu.ac.kr/student/W02iphone/USS_UserLogout.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return }
            }
            task.resume()
            
//            self.appDelegate.ID = nil
//            self.appDelegate.userName = "Guest"
//            self.appDelegate.userProfilePic = nil
//            self.appDelegate.userMaxScore = "0"
//            self.appDelegate.userPlayCounts = nil
//
//            self.appDelegate.flagLogin = false
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let MainView = storyboard.instantiateViewController(withIdentifier: "MainView")
            self.present(MainView, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
//        if let player = appDelegate.clickEffectAudioPlayer {
//            player.play()
//        }
    }
}
