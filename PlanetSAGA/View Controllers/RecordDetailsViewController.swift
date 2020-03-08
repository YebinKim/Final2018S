//
//  RecordDetailsViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 6. 17..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit

class RecordDetailsViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet var userScore: UILabel!
    @IBOutlet var userScoreDate: UILabel!
    @IBOutlet var scoreMemo: UITextView!
    @IBOutlet var statusLabel: UILabel!
    
    var selectedData: UserScore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = ""

        guard let ScoreData = selectedData else { return }
        userScore.text = ScoreData.score
        userScoreDate.text = ScoreData.scoreDate
        scoreMemo.text = ScoreData.scoreMemo
    }
    
    @IBAction func buttonSavePressed(_ sender: UIButton) {
        if let player = appDelegate.clickEffectAudioPlayer {
            player.play()
        }
        
        let urlString: String = "http://condi.swu.ac.kr/student/W02iphone/USS_updateScoreMemo.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let playCount = self.appDelegate.userPlayCounts
        self.appDelegate.userPlayCounts = String(Int(playCount!)! + 1)
        
        var restString: String = "id=" + self.appDelegate.ID! + "&scoreno=" + (selectedData?.scoreNo)!
        restString += "&scorememo=" + scoreMemo.text
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else {
            print("Error: calling POST")
            return
            }
        }
        task.resume()
        
        statusLabel.text = "Memo saved"
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        if let player = appDelegate.clickEffectAudioPlayer {
            player.play()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
