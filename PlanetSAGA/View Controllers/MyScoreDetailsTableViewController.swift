//
//  LocalRecordDetailsViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 6. 18..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import CoreData
import UIKit

class MyScoreDetailsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var localScoreLabel: UILabel!
    @IBOutlet var localDateLabel: UILabel!
    
    @IBOutlet var idTextfield: UITextField!
    @IBOutlet var pwTextfield: UITextField!
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet var statusLabel: UILabel!
    
    var detailLocalScore: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = ""

        if let localScore = detailLocalScore {
            localScoreLabel.text = localScore.value(forKey: "localscore") as? String
            
            let dbDate: Date? = localScore.value(forKey: "playdate") as? Date
            let formatter: DateFormatter = DateFormatter()
            
            formatter.dateFormat = "yyyy-MM-dd"
            if let unwrapDate = dbDate {
                let displayDate = formatter.string(from: unwrapDate as Date)
                localDateLabel.text = displayDate
            }
        }
    }
    
    @IBAction func buttonSavePressed(_ sender: UIButton) {
        SoundManager.clickEffect()
        
        // 필요한 세 가지 자료가 모두 입력 되었는지 확인
        if idTextfield.text == "" {
            statusLabel.text = "Insert ID";
            return;
        }
        if pwTextfield.text == "" {
            statusLabel.text = "Insert Password";
            return;
        }
        if nameTextfield.text == "" {
            statusLabel.text = "Insert Name";
            return;
        }
        
        let urlString: String = "http://condi.swu.ac.kr/student/W02iphone/USS_insertUser.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        var restString: String = "id=" + idTextfield.text! + "&password=" + pwTextfield.text!
        restString += "&name=" + nameTextfield.text! + "&maxscore=" + localScoreLabel.text! + "&playcounts=" + "1"
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else {
            print("Error: calling POST")
            return
            }
        }
        task.resume()
        
        self.insertScore()
        self.deleteScore()
        
        statusLabel.text = "Score saved";
        
        self.delay(bySeconds: 1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
//        if let player = appDelegate.clickEffectAudioPlayer {
//            player.play()
//        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func insertScore() {
        let urlString: String = "http://condi.swu.ac.kr/student/W02iphone/USS_insertScore.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        var restString: String = "id=" + idTextfield.text! + "&score=" + localScoreLabel.text!
        restString += "&scoredate=" + localDateLabel.text! + "&scorememo=" + ""
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else {
            print("Error: calling POST")
            return
            }
        }
        task.resume()
    }
    
    func deleteScore() {
        // Core Data 내의 해당 자료 삭제
//        let context = getContext()
//        context.delete(detailLocalScore!)
//        
//        do {
//            try context.save()
//            print("Score Deleted!")
//        } catch let error as NSError {
//            print("Could not delete \(error), \(error.userInfo)")
//        }
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        if textField == self.idTextfield { textField.resignFirstResponder()
            self.pwTextfield.becomeFirstResponder()
        }
        else if textField == self.pwTextfield {
            textField.resignFirstResponder()
            self.nameTextfield.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }

    func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
    enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }

}
