//
//  SignUpViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 22..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var pwTextfield: UITextField!
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusLabel.text = ""
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        SoundManager.clickEffect()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        SoundManager.clickEffect()
        
        // 필요한 세 가지 자료가 모두 입력 되었는지 확인
        if emailTextfield.text == "" {
            statusLabel.text = "Insert ID"
            return
        }
        if pwTextfield.text == "" {
            statusLabel.text = "Insert Password"
            return
        }
        if nameTextfield.text == "" {
            statusLabel.text = "Insert Name"
            return
        }
        
        guard let email = emailTextfield.text,
            let password = pwTextfield.text,
            let name = nameTextfield.text else { return }
        
        OnlineManager.createUser(email: email, password: password, name: name) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.statusLabel.text = error.localizedDescription
                }
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "updateUser"), object: nil)
                self.presentingViewController?.presentingViewController?.dismiss(animated: true)
            }
        }
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextfield {
            textField.resignFirstResponder()
            self.pwTextfield.becomeFirstResponder()
        }
        else if textField == self.pwTextfield {
            textField.resignFirstResponder()
            self.nameTextfield.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        
        return true
    }
    
}
