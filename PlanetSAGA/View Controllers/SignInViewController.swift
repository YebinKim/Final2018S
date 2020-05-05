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
    
    @IBOutlet weak var titleView: StyledView!
    
    @IBOutlet weak var inputFieldView: StyledView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var pwTextfield: UITextField!
    @IBOutlet weak var signInButton: StyledButton!
    
    @IBOutlet weak var statusView: StyledView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var signUpView: StyledView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeEmailTextField()
        initializePwTextField()
        
        applyStyled()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetStatus()
    }
    
    private func initializeEmailTextField() {
        emailTextfield.delegate = self
        emailTextfield.text = ""
    }
    
    private func initializePwTextField() {
        pwTextfield.delegate = self
        pwTextfield.text = ""
    }
    
    private func resetStatus() {
        statusView.isHidden = true
        statusLabel.isHidden = true
        statusLabel.text = ""
    }
    
    private func applyStyled() {
        backButton.neumorphicLayer?.cornerRadius = 12
        backButton.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        titleView.neumorphicLayer?.cornerRadius = 12
        titleView.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        inputFieldView.neumorphicLayer?.cornerRadius = 12
        inputFieldView.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        signInButton.neumorphicLayer?.cornerRadius = 12
        signInButton.neumorphicLayer?.elementBackgroundColor = signInButton.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        signUpView.neumorphicLayer?.cornerRadius = 12
        signUpView.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        statusView.neumorphicLayer?.cornerRadius = 12
        statusView.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        statusView.neumorphicLayer?.elementDepth = 0
    }
    
    private func playStatusAnimation() {
        playStatusAnimation(depthType: .convex)
    }
    
    private func playStatusAnimation(depthType: StyledLayerDepthType) {
        statusView.isHidden = false
        statusView.neumorphicLayer?.depthType = depthType
        statusView.neumorphicLayer?.elementDepth = 5
        
        statusLabel.isHidden = false
        statusLabel.alpha = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.statusLabel.alpha = 1
        })
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        SoundManager.clickEffect()
        self.dismiss(animated: true)
    }
    
    @IBAction func buttonLoginPressed(_ sender: UIButton) {
        SoundManager.clickEffect()
        
        if emailTextfield.text == "" {
            DispatchQueue.main.async {
                self.statusLabel.text = "이메일 아이디를 입력해 주세요"
                self.playStatusAnimation()
            }
            return
        }
        if pwTextfield.text == "" {
            DispatchQueue.main.async {
                self.statusLabel.text = "비밀번호를 입력해 주세요"
                self.playStatusAnimation()
            }
            return
        }
        
        DispatchQueue.main.async {
            self.statusLabel.text = "Welcome ;)"
            self.playStatusAnimation(depthType: .concave)
        }
        
        OnlineManager.signInUser(email: emailTextfield.text, password: pwTextfield.text) { error in
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
