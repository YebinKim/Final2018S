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
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        SoundManager.shared.playClickEffect()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        SoundManager.shared.playClickEffect()
        
        // 필요한 세 가지 자료가 모두 입력 되었는지 확인
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
        if nameTextfield.text == "" {
            DispatchQueue.main.async {
                self.statusLabel.text = "닉네임을 입력해 주세요"
                self.playStatusAnimation()
            }
            return
        }
        
        DispatchQueue.main.async {
            self.statusLabel.text = "SignUp Success :D"
            self.playStatusAnimation(depthType: .concave)
        }
        
        OnlineManager.createUser(email: emailTextfield.text, password: pwTextfield.text, name: nameTextfield.text) { error in
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
