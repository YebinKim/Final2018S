//
//  RankingDetailsViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 6. 17..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit

class RankingDetailsViewController: UIViewController {

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userID: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userMaxScore: UILabel!
    @IBOutlet var userPlayCounts: UILabel!
    
//    var selectedData: UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        userID.text = selectedData?.id
//        userName.text = selectedData?.name
//        userMaxScore.text = selectedData?.maxScore
//        userPlayCounts.text = selectedData?.playCounts
        
//        var imageName = selectedData?.profilePic // 숫자.jpg 로 저장된 파일 이름
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

    @IBAction func buttonBackPressed(_ sender: UIButton) {
//        if let player = appDelegate.clickEffectAudioPlayer {
//            player.play()
//        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
