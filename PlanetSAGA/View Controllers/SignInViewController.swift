//
//  SignInViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 22..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var pwTextfield: UITextField!
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statusLabel.text = ""
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        SoundManager.clickEffect()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonLoginPressed(_ sender: UIButton) {
        SoundManager.clickEffect()
        
        if emailTextfield.text == "" {
            statusLabel.text = "Insert ID"; return;
        }
        if pwTextfield.text == "" {
            statusLabel.text = "Insert Password"; return;
        }
        
        Auth.auth().signIn(withEmail: emailTextfield.text!,
                           password: pwTextfield.text!) { user, error in
            if let error = error {
                self.statusLabel.text = error.localizedDescription
                print("Error: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        if textField == self.emailTextfield { textField.resignFirstResponder()
            self.emailTextfield.becomeFirstResponder()
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
