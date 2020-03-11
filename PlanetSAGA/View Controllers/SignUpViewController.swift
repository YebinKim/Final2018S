//
//  SignUpViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 22..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var pwTextfield: UITextField!
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = ""
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        SoundManager.clickEffect()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonJoinPressed(_ sender: UIButton) {
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
        
        Auth.auth().createUser(withEmail: emailTextfield.text!,
                               password: pwTextfield.text!) { user, error in
            if let error = error, user == nil {
                self.statusLabel.text = error.localizedDescription
                print("Error: \(error.localizedDescription)")
            } else {
                let userInfo = UserInfo(email: self.emailTextfield.text!,
                                        name: self.nameTextfield.text!)
                let userInfoRef = PSDatabase.userInfoRef.child(user!.user.uid)
                userInfoRef.setValue(userInfo.toAnyObject())
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
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
