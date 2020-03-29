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
    
    @IBOutlet weak var backButton: StyledButton!
    
    @IBOutlet weak var titleView: StyledView!
    
    @IBOutlet weak var inputFieldView: StyledView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var pwTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var signUpButton: StyledButton!
    
    @IBOutlet weak var statusView: StyledView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeEmailTextField()
        initializePwTextField()
        initializeNameTextField()
        
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
    
    private func initializeNameTextField() {
        nameTextfield.delegate = self
        nameTextfield.text = ""
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
        
        signUpButton.neumorphicLayer?.cornerRadius = 12
        signUpButton.neumorphicLayer?.elementBackgroundColor = signUpButton.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        inputFieldView.neumorphicLayer?.cornerRadius = 12
        inputFieldView.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        statusView.neumorphicLayer?.cornerRadius = 12
        statusView.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        statusView.neumorphicLayer?.elementDepth = 0
    }
    
    private func playStatusAnimation() {
        statusView.isHidden = false
        statusView.neumorphicLayer?.depthType = .convex
        statusView.neumorphicLayer?.elementDepth = 5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.statusLabel.isHidden = false
        }
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
            playStatusAnimation()
            return
        }
        if pwTextfield.text == "" {
            statusLabel.text = "Insert Password"
            playStatusAnimation()
            return
        }
        if nameTextfield.text == "" {
            statusLabel.text = "Insert Name"
            playStatusAnimation()
            return
        }
        
        guard let email = emailTextfield.text,
            let password = pwTextfield.text,
            let name = nameTextfield.text else { return }
        
        statusLabel.text = "SignUp Success :D"
        statusView.neumorphicLayer?.depthType = .concave
        
        OnlineManager.createUser(email: email, password: password, name: name) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.statusLabel.text = error.localizedDescription
                }
            } else {
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
