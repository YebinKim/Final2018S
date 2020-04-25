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
                                               rankLabel]
    
    var selectedSegmentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingSegment.selectedSegmentIndex = selectedSegmentIndex
        selectSettingSegment(settingSegment)
        
        initializeUserSetting()
        initializingTextField()
        
        applyStyled()
        
        //        backgroundVolume.value = (appDelegate.bakgroundAudioPlayer?.volume)!
        //        effectVolume.value = (appDelegate.clickEffectAudioPlayer?.volume)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        appDelegate.userInfoFetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        //        self.appDelegate.userInfoDownloadDataFromServer()
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
        print("password change")
    }
    
    @objc
    func nameTextFieldDidChange(_ textField: UITextField) {
        OnlineManager.updateUserName(nameTextfield.text)
    }
    
    @IBAction func adjustBackgroundVolume(_ sender: UISlider) {
        SoundManager.adjustBackgroundVolume(sender.value)
    }
    
    @IBAction func adjustEffectVolume(_ sender: UISlider) {
        SoundManager.adjustEffectVolume(sender.value)
    }
    
    @IBAction func selectSettingSegment(_ sender: UISegmentedControl) {
        SoundManager.clickEffect()
        
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
        SoundManager.clickEffect()
        
        let myPicker = UIImagePickerController()
        myPicker.delegate = self;
        myPicker.sourceType = .photoLibrary
        self.present(myPicker, animated: true, completion: nil)
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        SoundManager.clickEffect()
        
        let alert = UIAlertController(title: "User Delete", message: "Are you sure you want to delete it?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/W02iphone/USS_deleteUser.php"
            guard let requestURL = URL(string: urlString) else { return }
            
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            
            //            guard let id = self.appDelegate.ID else { return }
            
            //            let restString: String = "id=" + id
            //            request.httpBody = restString.data(using: .utf8)
            //
            //            let session = URLSession.shared
            //            let task = session.dataTask(with: request) { (responseData, response, responseError) in
            //                guard responseError == nil else { return }
            //                guard let receivedData = responseData else { return }
            //                if let utf8Data = String(data: receivedData, encoding: .utf8) {
            //                    print(utf8Data)  // php에서 출력한 echo data가 debug 창에 표시됨
            //                }
            //            }
            //            task.resume()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let MainView = storyboard.instantiateViewController(withIdentifier: "MainView")
            self.present(MainView, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        SoundManager.clickEffect()
        
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
