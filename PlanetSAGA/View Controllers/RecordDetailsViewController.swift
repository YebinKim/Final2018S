//
//  RecordDetailsViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 6. 17..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit

class RecordDetailsViewController: UIViewController {
    
    @IBOutlet var userScore: UILabel!
    @IBOutlet var userScoreDate: UILabel!
    @IBOutlet var scoreMemo: UITextView!
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = ""

//        userScore.text = ScoreData.score
//        userScoreDate.text = ScoreData.scoreDate
//        scoreMemo.text = ScoreData.scoreMemo
    }
    
    @IBAction func buttonSavePressed(_ sender: UIButton) {
        SoundManager.clickEffect()
        
        let urlString: String = "http://condi.swu.ac.kr/student/W02iphone/USS_updateScoreMemo.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
//        let playCount = self.appDelegate.userPlayCounts
//        self.appDelegate.userPlayCounts = String(Int(playCount!)! + 1)
        
//        var restString: String = "id=" + self.appDelegate.ID! + "&scoreno=" + (selectedData?.scoreNo)!
//        restString += "&scorememo=" + scoreMemo.text
//        request.httpBody = restString.data(using: .utf8)
//
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else {
//            print("Error: calling POST")
//            return
//            }
//        }
//        task.resume()
        
        statusLabel.text = "Memo saved"
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        SoundManager.clickEffect()
        
        self.dismiss(animated: true, completion: nil)
    }
}