//
//  SettingViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 29..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SettingViewController: UIViewController {
    
    @IBOutlet weak var backButton: StyledButton!
    
    @IBOutlet var styledViews: [StyledView]!
    
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!
    @IBOutlet weak var fiveLabel: UILabel!
    
    @IBOutlet weak var settingSegment: UISegmentedControl!
    
    @IBOutlet weak var backgroundVolume: UISlider!
    @IBOutlet weak var effectVolume: UISlider!
    @IBOutlet weak var screenRotateSwitch: UISwitch!
    @IBOutlet weak var maxScoreLabel: UILabel!
    @IBOutlet weak var playCountsLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageChangeButton: UIButton!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var deleteUserButton: UIButton!
    
    private lazy var gameSetArray: [UIView] = [backgroundVolume,
                                               effectVolume,
                                               screenRotateSwitch,
                                               maxScoreLabel,
                                               playCountsLabel]
    
    private lazy var userSetArray: [UIView] = [emailLabel,
                                               pwTextField,
                                               profileImageView,
                                               profileImageChangeButton,
                                               nameTextfield,
                                               rankLabel,
                                               deleteUserButton]
    
    var selectedSegmentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingSegment.selectedSegmentIndex = selectedSegmentIndex
        selectSettingSegment(settingSegment)
        
        initializeUserSetting()
        initializingTextField()
        
        applyStyled()
        
        profileImageView.image = ImageManager.createDefaultProfileImage(bgColor: UIColor(named: "color_main"))
        
        backgroundVolume.value = SoundManager.shared.backgroundVolumeSize
        effectVolume.value = SoundManager.shared.effectVolumeSize
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func initializeUserSetting() {
        if let user = Auth.auth().currentUser {
            PSDatabase.userInfoRef
                .queryEqual(toValue: nil, childKey: user.uid)
                .observeSingleEvent(of: .value, with: { snapshot in
                    guard let child = snapshot.children.allObjects.first,
                        let snapshot = child as? DataSnapshot,
                        let userInfo = UserInfo(snapshot: snapshot) else { return }
                    
                    self.emailLabel.text = user.email
                    self.nameTextfield.text = userInfo.name
                    
                    self.maxScoreLabel.text = String(userInfo.maxScore)
                    self.playCountsLabel.text = String(userInfo.playCounts)
                    
                    let storageRef = PSDatabase.storageRef.child(user.uid)
                    
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error, data == nil {
                            print("Error: \(error.localizedDescription)")
                        } else {
                            self.profileImageView.image = UIImage(data: data!)
                        }
                    }
                })
        } else {
            emailLabel.text = "Guest"
            nameTextfield.text = "Guest"
            
            maxScoreLabel.text = "0"
            playCountsLabel.text = "0"
        }
    }
    
    private func initializingTextField() {
        pwTextField.addTarget(self, action: #selector(pwTextFieldDidChange), for: .editingDidEnd)
        nameTextfield.addTarget(self, action: #selector(nameTextFieldDidChange), for: .editingDidEnd)
    }
    
    private func applyStyled() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 3
        
        backButton.neumorphicLayer?.cornerRadius = 12
        backButton.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        styledViews.forEach {
            $0.neumorphicLayer?.cornerRadius = 12
            $0.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        }
    }
    
    private func uploadProfileImage() {
        guard let image = profileImageView.image else {
            let alert = UIAlertController(title: "Select a Picture", message: "Save Failed", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            return
        }
        
        guard var imageData = image.jpegData(compressionQuality: 1.0) else { return }
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        while imageData.count > 1 * 1024 * 1024 {
            imageData = UIImage(data: imageData)!.jpegData(compressionQuality: 0.1)!
        }
        
        guard let user = OnlineManager.user else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        let storageRef = PSDatabase.storageRef.child(user.uid)
        storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                OnlineManager.updateUserInfo(user.uid)
            }
        }
    }
    
    @objc
    func pwTextFieldDidChange(_ textField: UITextField) {
        let confirmAlert = UIAlertController(title: "비밀번호 재확인", message: nil, preferredStyle: .alert)
        confirmAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "비밀번호를 다시 입력해주세요"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.isSecureTextEntry = true
        })
        
        confirmAlert.addAction(UIAlertAction(title: "입력 완료", style: .default, handler: { action in
            let password = confirmAlert.textFields![0].text
            OnlineManager.updateUserPassword(oldPassword: password, newPassword: textField.text) { error in
                let changeAlert = UIAlertController(title: "비밀번호 변경", message: nil, preferredStyle: .alert)
                
                if let error = error {
                    changeAlert.addAction(UIAlertAction(title: "실패했어요", style: .cancel, handler: nil))
                    print("Update Password Error: \(error.localizedDescription)")
                    return
                } else {
                    changeAlert.addAction(UIAlertAction(title: "성공했어요!", style: .default, handler: nil))
                }
                
                self.present(changeAlert, animated: true, completion: nil)
            }
        }))
        confirmAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: {action in }))
        
        self.present(confirmAlert, animated: true, completion: nil)
    }
    
    @objc
    func nameTextFieldDidChange(_ textField: UITextField) {
        let confirmAlert = UIAlertController(title: "닉네임을 변경할까요?", message: nil, preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: "변경", style: .default, handler: { action in
            OnlineManager.updateUserName(self.nameTextfield.text) {
                let changeAlert = UIAlertController(title: "닉네임 변경을 성공했어요", message: nil, preferredStyle: .alert)
                changeAlert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                self.present(changeAlert, animated: true, completion: nil)
            }
        }))
        confirmAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: {action in }))
        
        self.present(confirmAlert, animated: true, completion: nil)
    }
    
    @IBAction func adjustBackgroundVolume(_ sender: UISlider) {
        SoundManager.shared.adjustBackgroundVolume(sender.value)
    }
    
    @IBAction func adjustEffectVolume(_ sender: UISlider) {
        SoundManager.shared.adjustEffectVolume(sender.value)
    }
    
    @IBAction func selectSettingSegment(_ sender: UISegmentedControl) {
        SoundManager.shared.playClickEffect()
        
        switch sender.selectedSegmentIndex {
        case 0:
            DispatchQueue.main.async {
                self.styledViews.forEach {
                    $0.neumorphicLayer?.depthType = .convex
                }
                
                self.oneLabel.text = "배경음악"
                self.twoLabel.text = "효과음"
                self.threeLabel.text = "화면 회전"
                self.fourLabel.text = "최고 점수"
                self.fiveLabel.text = "플레이 횟수"
                
                self.gameSetArray.forEach { $0.isHidden = false }
                self.userSetArray.forEach { $0.isHidden = true }
            }
        case 1:
            DispatchQueue.main.async {
                self.styledViews.forEach {
                    $0.neumorphicLayer?.depthType = .concave
                }
                
                self.oneLabel.text = "이메일"
                self.twoLabel.text = "비밀번호"
                self.threeLabel.text = "프로필 사진"
                self.fourLabel.text = "닉네임"
                self.fiveLabel.text = "랭킹"
                
                self.gameSetArray.forEach { $0.isHidden = true }
                self.userSetArray.forEach { $0.isHidden = false }
            }
        default:
            print("Error: Unknowned setting index")
            break
        }
    }
    
    @IBAction func selectProfile(_ sender: UIButton) {
        SoundManager.shared.playClickEffect()
        
        let myPicker = UIImagePickerController()
        myPicker.delegate = self;
        myPicker.sourceType = .photoLibrary
        self.present(myPicker, animated: true, completion: nil)
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        SoundManager.shared.playClickEffect()
        
        let confirmAlert = UIAlertController(title: "사용자 탈퇴", message: "탈퇴를 위해 비밀번호를 재확인합니다", preferredStyle: .alert)
        confirmAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "비밀번호를 다시 입력해주세요"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.isSecureTextEntry = true
        })
        confirmAlert.addAction(UIAlertAction(title: "입력 완료", style: .default, handler: { action in
            let password = confirmAlert.textFields![0].text
            OnlineManager.deleteUser(password: password) { error in
                if let error = error {
                    print("Delete User Error: \(error.localizedDescription)")
                    let alert = UIAlertController(title: "탈퇴 실패", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: nil, message: "다음에 다시 만나요!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true)
                }
            }
        }))
        confirmAlert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: {action in }))
        
        self.present(confirmAlert, animated: true)
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        SoundManager.shared.playClickEffect()
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            self.profileImageView.image = image
        }
        self.dismiss(animated: true, completion: {
            self.uploadProfileImage()
        })
    }
    
    func imagePickerControllerDidCancel (_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SettingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextfield.becomeFirstResponder()
        textField.resignFirstResponder()
        
        return true
    }
    
}
