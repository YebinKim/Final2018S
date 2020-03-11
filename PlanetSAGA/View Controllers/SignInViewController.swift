//
//  SignInViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 22..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var pwTextfield: UITextField!
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusLabel.text = ""
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        SoundManager.clickEffect()
        self.dismiss(animated: true)
    }
    
    @IBAction func buttonLoginPressed(_ sender: UIButton) {
        SoundManager.clickEffect()
        
        if emailTextfield.text == "" {
            statusLabel.text = "Insert ID"
            return
        }
        if pwTextfield.text == "" {
            statusLabel.text = "Insert Password"
            return
        }
        
        guard let email = emailTextfield.text, let password = pwTextfield.text else { return }
        
        OnlineManager.signInUser(email: email, password: password) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.statusLabel.text = error.localizedDescription
                }
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "updateUser"), object: nil)
                self.dismiss(animated: true)
            }
        }
    }
    
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        if textField == self.emailTextfield {
            textField.resignFirstResponder()
            self.emailTextfield.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        
        return true
    }
    
}
