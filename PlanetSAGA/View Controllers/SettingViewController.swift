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

class SettingViewController: UIViewController,  UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var gameSetView: UIView!
    
    @IBOutlet weak var maxScoreLabel: UILabel!
    @IBOutlet weak var playCountsLabel: UILabel!
    
    @IBOutlet weak var backgroundVolume: UISlider!
    @IBOutlet weak var effectVolume: UISlider!
    
    @IBOutlet weak var userSetView: UIView!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var profileImageview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = ""
        
        if let user = Auth.auth().currentUser {
            PSDatabase.userInfoRef
                .queryEqual(toValue: nil, childKey: user.uid)
                .observeSingleEvent(of: .value, with: { snapshot in
                    guard let child = snapshot.children.allObjects.first,
                        let snapshot = child as? DataSnapshot,
                        let userInfo = UserInfo(snapshot: snapshot) else { return }
                    
                    self.maxScoreLabel.text = String(userInfo.maxScore)
                    self.playCountsLabel.text = String(userInfo.playCounts)
                    
                    self.emailLabel.text = user.email
                    self.nameTextfield.text = userInfo.name
                    
                    let storageRef = PSDatabase.storageRef.child(user.uid)
                    
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error, data == nil {
                            print("Error: \(error.localizedDescription)")
                        } else {
                            self.profileImageview.image = UIImage(data: data!)
                        }
                    }
                })
        }
        
        self.gameSetView.isHidden = false
        self.userSetView.isHidden = true
        
        //        backgroundVolume.value = (appDelegate.bakgroundAudioPlayer?.volume)!
        //        effectVolume.value = (appDelegate.clickEffectAudioPlayer?.volume)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        appDelegate.userInfoFetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        //        self.appDelegate.userInfoDownloadDataFromServer()
    }
    
    @IBAction func adjustBackgroundVolume(_ sender: UISlider) {
        //        appDelegate.bakgroundAudioPlayer?.volume = backgroundVolume.value
    }
    
    @IBAction func adjustEffectVolume(_ sender: UISlider) {
        for i in 0...3 {
            //            appDelegate.effectArray[i]?.volume = effectVolume.value
        }
    }
    
    @IBAction func selectOption(_ sender: UISegmentedControl) {
        SoundManager.clickEffect()
        
        if sender.selectedSegmentIndex == 0 {
            self.gameSetView.isHidden = false
            self.userSetView.isHidden = true
        } else {
            self.gameSetView.isHidden = true
            self.userSetView.isHidden = false
        }
    }
    
    @IBAction func selectProfile(_ sender: UIButton) {
        let myPicker = UIImagePickerController()
        myPicker.delegate = self;
        myPicker.sourceType = .photoLibrary
        self.present(myPicker, animated: true, completion: nil)
    }
    
    @IBAction func saveChange(_ sender: UIButton) {
        SoundManager.clickEffect()
        
        guard let image = profileImageview.image else {
            let alert = UIAlertController(title: "Select a Picture", message: "Save Failed", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            return
        }
        
        guard var imageData = UIImageJPEGRepresentation(image, 1.0) else { return }
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        while imageData.count > 1 * 1024 * 1024 {
            imageData = UIImageJPEGRepresentation(UIImage(data: imageData)!, 0.1)!
        }
        
        if let user = Auth.auth().currentUser {
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            let storageRef = PSDatabase.storageRef.child(user.uid)
            storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        if let urlString = url?.absoluteString {
                            let userInfoRef = PSDatabase.userInfoRef.child(user.uid)
                            userInfoRef.updateChildValues(UserInfo.toProfilePic(profileImageURL: urlString))
                        }
                    })
                }
            }
            
            let userInfoRef = PSDatabase.userInfoRef.child(user.uid)
            userInfoRef.updateChildValues(UserInfo.toName(name: nameTextfield.text!))
        }
        
        statusLabel.text = "User info changed"
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextfield.becomeFirstResponder()
        textField.resignFirstResponder()
        
        return true
    }
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImageview.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel (_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
