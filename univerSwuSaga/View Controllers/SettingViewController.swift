//
//  SettingViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 29..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,  UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var backgroundVolume: UISlider!
    @IBOutlet weak var effectVolume: UISlider!
    
    @IBOutlet var userSetView: UIView!
    @IBOutlet var gameSetView: UIView!
    
    @IBOutlet var profileImageview: UIImageView!
    @IBOutlet var userIDLabel: UILabel!
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var userScoreLabel: UILabel!
    @IBOutlet var userPlayCountsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = ""
        
        userScoreLabel.text = appDelegate.userMaxScore
        userPlayCountsLabel.text = appDelegate.userPlayCounts
        
        var imageName = appDelegate.userProfilePic // 숫자.jpg 로 저장된 파일 이름
        if (imageName != "") {
            let urlString = "http://condi.swu.ac.kr/student/W02iphone/"
            imageName = urlString + imageName!
            let url = URL(string: imageName!)!
            if let imageData = try? Data(contentsOf: url) {
                profileImageview.image = UIImage(data: imageData)
                // 웹에서 파일 이미지를 접근함
            }
        }
        
        userIDLabel.text = appDelegate.ID
        nameTextfield.text = appDelegate.userName
        
        self.gameSetView.isHidden = false
        self.userSetView.isHidden = true
        
        backgroundVolume.value = (appDelegate.bakgroundAudioPlayer?.volume)!
        effectVolume.value = (appDelegate.clickEffectAudioPlayer?.volume)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        appDelegate.userInfoFetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        self.appDelegate.userInfoDownloadDataFromServer()
    }
    
    @IBAction func adjustBackgroundVolume(_ sender: UISlider) {
        appDelegate.bakgroundAudioPlayer?.volume = backgroundVolume.value
    }
    
    @IBAction func adjustEffectVolume(_ sender: UISlider) {
        for i in 0 ... 3 {
            appDelegate.effectArray[i]?.volume = effectVolume.value
        }
    }
    
    @IBAction func selectOption(_ sender: UISegmentedControl) {
        if let player = appDelegate.clickEffectAudioPlayer {
            player.play()
        }
        
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
        if let player = self.appDelegate.clickEffectAudioPlayer {
            player.play()
        }
        
        guard let myImage = profileImageview.image else {
            let alert = UIAlertController(title: "Select a Picture", message: "Save Failed", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
            return
        }
        
        let myUrl = URL(string: "http://condi.swu.ac.kr/student/W02iphone/USS_upload.php");
        var request = URLRequest(url:myUrl!);
        request.httpMethod = "POST";
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let imageData = UIImageJPEGRepresentation(myImage, 1) else { return }
        
        var body = Data()
        var dataString = "--\(boundary)\r\n"
        dataString += "Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n"
        dataString += "Content-Type: application/octet-stream\r\n\r\n"
        if let data = dataString.data(using: .utf8) {
            body.append(data)
        }
        
        // imageData 위 아래로 boundary 정보 추가
        body.append(imageData)
        
        dataString = "\r\n"
        dataString += "--\(boundary)--\r\n"
        if let data = dataString.data(using: .utf8) { body.append(data) }
        
        request.httpBody = body
        
        var imageFileName: String = ""
        let semaphore = DispatchSemaphore(value: 0)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else { print("Error: not receiving Data"); return; }
            if let utf8Data = String(data: receivedData, encoding: .utf8) { // 서버에 저장한 이미지 파일 이름
                imageFileName = utf8Data
                semaphore.signal()
            }
        }
        task.resume()
        // 이미지 파일 이름을 서버로 부터 받은 후 해당 이름을 DB에 저장하기 위해 wait()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        let urlString: String = "http://condi.swu.ac.kr/student/W02iphone/USS_updateProfile.php"
        guard let requestURL = URL(string: urlString) else { return }
        request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let userID = appDelegate.ID  else { return }
        guard let name = nameTextfield.text  else { return }
        
        var restString: String = "id=" + userID + "&name=" + name
        restString += "&image=" + imageFileName
        request.httpBody = restString.data(using: .utf8)
        
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { return }
            guard let receivedData = responseData else { return }
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                print(utf8Data)
            }
        }
        task2.resume()
        _ = self.navigationController?.popViewController(animated: true)
        
        statusLabel.text = "User info changed"
        
        appDelegate.userInfoDownloadDataFromServer()
    }
    
    @IBAction func deleteUser(_ sender: UIButton) {
        if let player = appDelegate.clickEffectAudioPlayer {
            player.play()
        }
        
        let alert = UIAlertController(title: "User Delete", message: "Are you sure you want to delete it?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/W02iphone/USS_deleteUser.php"
            guard let requestURL = URL(string: urlString) else { return }
            
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            
            guard let id = self.appDelegate.ID else { return }
            
            let restString: String = "id=" + id
            request.httpBody = restString.data(using: .utf8)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return }
                guard let receivedData = responseData else { return }
                if let utf8Data = String(data: receivedData, encoding: .utf8) {
                    print(utf8Data)  // php에서 출력한 echo data가 debug 창에 표시됨
                }
            }
            task.resume()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let MainView = storyboard.instantiateViewController(withIdentifier: "MainView")
            self.present(MainView, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        if let player = appDelegate.clickEffectAudioPlayer {
            player.play()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextfield.becomeFirstResponder()
        textField.resignFirstResponder()
        
        appDelegate.userName = nameTextfield.text
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
