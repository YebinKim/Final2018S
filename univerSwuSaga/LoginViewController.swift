//
//  LoginViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 22..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var backgroundImage: UIImageView!

    @IBOutlet var loginIdTextfield: UITextField!
    @IBOutlet var loginPwTextfield: UITextField!
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
    
    @IBAction func buttonLoginPressed(_ sender: UIButton) {
        if let player = appDelegate.clickEffectAudioPlayer {
            player.play()
        }
        
        if loginIdTextfield.text == "" {
            statusLabel.text = "Insert ID"; return;
        }
        if loginPwTextfield.text == "" {
            statusLabel.text = "Insert Password"; return;
        }
        
        let urlString: String = "http://condi.swu.ac.kr/student/W02iphone/USS_loginUser.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        self.statusLabel.text = " "
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + loginIdTextfield.text! + "&password=" + loginPwTextfield.text!
        
        request.httpBody = restString.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            
            do {
                let response = response as! HTTPURLResponse
                if !(200...299 ~= response.statusCode) {
                    print ("HTTP Error!")
                    return
                }
                guard let jsonData = try JSONSerialization.jsonObject(with: receivedData, options:.allowFragments) as? [String: Any] else {
                    print("JSON Serialization Error!")
                    return
                }
                guard let success = jsonData["success"] as! String? else {
                    print("Error: PHP failure(success)")
                    return
                }
                if success == "YES" {
                    if let name = jsonData["name"] as! String? {
                        DispatchQueue.main.async {
                            self.statusLabel.text = "Welcome " + name
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.ID = self.loginIdTextfield.text
                            appDelegate.userName = name
                            appDelegate.flagLogin = true
                            
                            appDelegate.userInfoDownloadDataFromServer()
                            
                            self.delay(bySeconds: 1) {
                                self.performSegue(withIdentifier: "toLoginSuccess", sender: self)
                            }
                        }
                    }
                } else {
                    if let errMessage = jsonData["error"] as! String? {
                        DispatchQueue.main.async {
                            self.statusLabel.text = errMessage
                        }
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        if textField == self.loginIdTextfield { textField.resignFirstResponder()
            self.loginPwTextfield.becomeFirstResponder()
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
