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
    
    @IBOutlet weak var backButton: StyledButton!
    
    @IBOutlet weak var inputFieldView: StyledView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var pwTextfield: UITextField!
    @IBOutlet weak var signInButton: StyledButton!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var signUpButton: StyledButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyStyled()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusLabel.text = ""
    }
    
    private func applyStyled() {
        backButton.neumorphicLayer?.cornerRadius = backButton.frame.width / 3
        backButton.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        signInButton.neumorphicLayer?.cornerRadius = signInButton.frame.height / 6
        signInButton.neumorphicLayer?.elementBackgroundColor = signInButton.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        signUpButton.neumorphicLayer?.cornerRadius = signUpButton.frame.width / 3
        signUpButton.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        inputFieldView.neumorphicLayer?.cornerRadius = inputFieldView.frame.height / 6
        inputFieldView.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
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
