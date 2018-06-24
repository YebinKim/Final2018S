//
//  JoinViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 22..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController, UITextFieldDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var backgroundImage: UIImageView!
    
    @IBOutlet var idTextfield: UITextField!
    @IBOutlet var pwTextfield: UITextField!
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.image = UIImage(named: "Background.png")
        statusLabel.text = ""
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        if let player = appDelegate.clickEffectAudioPlayer {
            player.play()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonJoinPressed(_ sender: UIButton) {
        if let player = appDelegate.clickEffectAudioPlayer {
            player.play()
        }
        
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
        let restString: String = "id=" + idTextfield.text! + "&password=" + pwTextfield.text! + "&name=" + nameTextfield.text!
        request.httpBody = restString.data(using: .utf8)
        self.executeRequest(request: request)
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
    
    func executeRequest (request: URLRequest) -> Void {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else {
            print("Error: calling POST")
            return
            }
            
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                DispatchQueue.main.async { // for Main Thread Checker
                    self.statusLabel.text = utf8Data
                    print(utf8Data) // php에서 출력한 echo data가 debug 창에 표시됨 }
                }
            }
        }
        task.resume()
    }
}
