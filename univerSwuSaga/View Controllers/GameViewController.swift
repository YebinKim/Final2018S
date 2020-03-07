//
//  GameViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 14..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import CoreData
import UIKit

class GameViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var b0: UIButton!
    @IBOutlet var b1: UIButton!
    @IBOutlet var b2: UIButton!
    @IBOutlet var b3: UIButton!
    @IBOutlet var b4: UIButton!
    @IBOutlet var b5: UIButton!
    @IBOutlet var b6: UIButton!
    @IBOutlet var b7: UIButton!
    @IBOutlet var b8: UIButton!
    @IBOutlet var b9: UIButton!
    @IBOutlet var b10: UIButton!
    @IBOutlet var b11: UIButton!
    @IBOutlet var b12: UIButton!
    @IBOutlet var b13: UIButton!
    @IBOutlet var b14: UIButton!
    @IBOutlet var b15: UIButton!
    @IBOutlet var b16: UIButton!
    @IBOutlet var b17: UIButton!
    @IBOutlet var b18: UIButton!
    @IBOutlet var b19: UIButton!
    @IBOutlet var b20: UIButton!
    @IBOutlet var b21: UIButton!
    @IBOutlet var b22: UIButton!
    @IBOutlet var b23: UIButton!
    @IBOutlet var b24: UIButton!
    @IBOutlet var b25: UIButton!
    @IBOutlet var b26: UIButton!
    @IBOutlet var b27: UIButton!
    @IBOutlet var b28: UIButton!
    @IBOutlet var b29: UIButton!
    @IBOutlet var b30: UIButton!
    @IBOutlet var b31: UIButton!
    @IBOutlet var b32: UIButton!
    @IBOutlet var b33: UIButton!
    @IBOutlet var b34: UIButton!
    @IBOutlet var b35: UIButton!
    @IBOutlet var b36: UIButton!
    @IBOutlet var b37: UIButton!
    @IBOutlet var b38: UIButton!
    @IBOutlet var b39: UIButton!
    @IBOutlet var b40: UIButton!
    @IBOutlet var b41: UIButton!
    @IBOutlet var b42: UIButton!
    @IBOutlet var b43: UIButton!
    @IBOutlet var b44: UIButton!
    @IBOutlet var b45: UIButton!
    @IBOutlet var b46: UIButton!
    @IBOutlet var b47: UIButton!
    @IBOutlet var b48: UIButton!
    @IBOutlet var b49: UIButton!
    @IBOutlet var b50: UIButton!
    @IBOutlet var b51: UIButton!
    @IBOutlet var b52: UIButton!
    @IBOutlet var b53: UIButton!
    @IBOutlet var b54: UIButton!
    @IBOutlet var b55: UIButton!
    @IBOutlet var b56: UIButton!
    @IBOutlet var b57: UIButton!
    @IBOutlet var b58: UIButton!
    @IBOutlet var b59: UIButton!
    @IBOutlet var b60: UIButton!
    @IBOutlet var b61: UIButton!
    @IBOutlet var b62: UIButton!
    @IBOutlet var b63: UIButton!
    @IBOutlet var b64: UIButton!
    @IBOutlet var b65: UIButton!
    @IBOutlet var b66: UIButton!
    @IBOutlet var b67: UIButton!
    @IBOutlet var b68: UIButton!
    @IBOutlet var b69: UIButton!
    @IBOutlet var b70: UIButton!
    @IBOutlet var b71: UIButton!
    @IBOutlet var b72: UIButton!
    @IBOutlet var b73: UIButton!
    @IBOutlet var b74: UIButton!
    @IBOutlet var b75: UIButton!
    @IBOutlet var b76: UIButton!
    @IBOutlet var b77: UIButton!
    @IBOutlet var b78: UIButton!
    @IBOutlet var b79: UIButton!
    @IBOutlet var b80: UIButton!
    
    @IBOutlet var missionImage1: UIImageView!
    @IBOutlet var missionImage2: UIImageView!
    @IBOutlet var missionImage3: UIImageView!
    @IBOutlet var missionImage4: UIImageView!
    @IBOutlet var missionImage5: UIImageView!
    @IBOutlet var missionImage6: UIImageView!
    
    @IBOutlet var missionLabel1: UILabel!
    @IBOutlet var missionLabel2: UILabel!
    @IBOutlet var missionLabel3: UILabel!
    @IBOutlet var missionLabel4: UILabel!
    @IBOutlet var missionLabel5: UILabel!
    @IBOutlet var missionLabel6: UILabel!
    
    @IBOutlet var moveView: UIView!
    @IBOutlet var moveLabel: UILabel!
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var maxScoreLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var resultView: UIView!
    @IBOutlet var resultLabel: UILabel!
    
    @IBOutlet var levelPicker: UIPickerView!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var levelView: UIView!
    var level: Int?
    var subBlock:UIImage?
    
    let bImage1:UIImage = UIImage(named:"block1.png")!
    let bImage2:UIImage = UIImage(named:"block2.png")!
    let bImage3:UIImage = UIImage(named:"block3.png")!
    let bImage4:UIImage = UIImage(named:"block4.png")!
    let bImage5:UIImage = UIImage(named:"block5.png")!
    let bImage6:UIImage = UIImage(named:"block6.png")!
    
    var missionArray:Array<UILabel?> = []
    var blockArray:Array<UIButton?> = Array(repeating: nil, count: 81)
    
    var arrNum1:Int = 0
    var arrNum2:Int = 0
    var flagBtn1:Bool = false
    
    var streak:Int = 0
    var score:Int = 0
    
    var timer:Timer?
    var count = 20
    var timerFlag:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        missionImage1.image = bImage1
        missionImage2.image = bImage2
        missionImage3.image = bImage3
        missionImage4.image = bImage4
        missionImage5.image = bImage5
        missionImage6.image = bImage6
        
        moveView.isHidden = true
        resultView.isHidden = true
        levelView.isHidden = false
        level = nil
        
        userNameLabel.text = appDelegate.userName
        maxScoreLabel.text = appDelegate.userMaxScore
        
        levelPicker.selectRow(2, inComponent: 0, animated: false)
        
        blockArray[0] = b0
        blockArray[1] = b1
        blockArray[2] = b2
        blockArray[3] = b3
        blockArray[4] = b4
        blockArray[5] = b5
        blockArray[6] = b6
        blockArray[7] = b7
        blockArray[8] = b8
        blockArray[9] = b9
        blockArray[10] = b10
        blockArray[11] = b11
        blockArray[12] = b12
        blockArray[13] = b13
        blockArray[14] = b14
        blockArray[15] = b15
        blockArray[16] = b16
        blockArray[17] = b17
        blockArray[18] = b18
        blockArray[19] = b19
        blockArray[20] = b20
        blockArray[21] = b21
        blockArray[22] = b22
        blockArray[23] = b23
        blockArray[24] = b24
        blockArray[25] = b25
        blockArray[26] = b26
        blockArray[27] = b27
        blockArray[28] = b28
        blockArray[29] = b29
        blockArray[30] = b30
        blockArray[31] = b31
        blockArray[32] = b32
        blockArray[33] = b33
        blockArray[34] = b34
        blockArray[35] = b35
        blockArray[36] = b36
        blockArray[37] = b37
        blockArray[38] = b38
        blockArray[39] = b39
        blockArray[40] = b40
        blockArray[41] = b41
        blockArray[42] = b42
        blockArray[43] = b43
        blockArray[44] = b44
        blockArray[45] = b45
        blockArray[46] = b46
        blockArray[47] = b47
        blockArray[48] = b48
        blockArray[49] = b49
        blockArray[50] = b50
        blockArray[51] = b51
        blockArray[52] = b52
        blockArray[53] = b53
        blockArray[54] = b54
        blockArray[55] = b55
        blockArray[56] = b56
        blockArray[57] = b57
        blockArray[58] = b58
        blockArray[59] = b59
        blockArray[60] = b60
        blockArray[61] = b61
        blockArray[62] = b62
        blockArray[63] = b63
        blockArray[64] = b64
        blockArray[65] = b65
        blockArray[66] = b66
        blockArray[67] = b67
        blockArray[68] = b68
        blockArray[69] = b69
        blockArray[70] = b70
        blockArray[71] = b71
        blockArray[72] = b72
        blockArray[73] = b73
        blockArray[74] = b74
        blockArray[75] = b75
        blockArray[76] = b76
        blockArray[77] = b77
        blockArray[78] = b78
        blockArray[79] = b79
        blockArray[80] = b80

        for i in 0 ... 80 {
            let randNum: UInt32 = arc4random_uniform(UInt32(6))
            
            if randNum == 0 {
                blockArray[i]?.setImage(bImage1, for: UIControlState.normal)
            } else if randNum == 1 {
                blockArray[i]?.setImage(bImage2, for: UIControlState.normal)
            } else if randNum == 2 {
                blockArray[i]?.setImage(bImage3, for: UIControlState.normal)
            } else if randNum == 3 {
                blockArray[i]?.setImage(bImage4, for: UIControlState.normal)
            } else if randNum == 4 {
                blockArray[i]?.setImage(bImage5, for: UIControlState.normal)
            } else if randNum == 5 {
                blockArray[i]?.setImage(bImage6, for: UIControlState.normal)
            }
        }
        
        alignedHorz()
        alignedVert()
        
        while(checkSpace()) {
            fillUp()
            alignedHorz()
            alignedVert()
        }
        
        score = 0
        scoreLabel.text = String(score)
        
        missionArray.append(missionLabel1)
        missionArray.append(missionLabel2)
        missionArray.append(missionLabel3)
        missionArray.append(missionLabel4)
        missionArray.append(missionLabel5)
        missionArray.append(missionLabel6)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var tempArray: Array<String?> = Array(repeating: "", count: 5)
        
        for i in 1 ... 5 {
            tempArray[i-1] = String(i)
        }
        
        return tempArray[row]
    }
    
    func getContext () -> NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func selectLevel(_ sender: UIButton) {
        levelLabel.text = "Level " + String(levelPicker.selectedRow(inComponent: 0) + 1) + " Start"
        level = Int(levelPicker.selectedRow(inComponent: 0) + 1)
        
        if levelPicker.selectedRow(inComponent: 0) == 0 {
            for i in 0 ... 5 {
                missionArray[i]?.text = String(1)
            }
        } else if levelPicker.selectedRow(inComponent: 0) == 1 {
            for i in 0 ... 5 {
                missionArray[i]?.text = String(10)
            }
        } else if levelPicker.selectedRow(inComponent: 0) == 2 {
            for i in 0 ... 5 {
                missionArray[i]?.text = String(15)
            }
        } else if levelPicker.selectedRow(inComponent: 0) == 3 {
            for i in 0 ... 5 {
                missionArray[i]?.text = String(20)
            }
        } else if levelPicker.selectedRow(inComponent: 0) == 4 {
            for i in 0 ... 5 {
                missionArray[i]?.text = String(25)
            }
        } else if levelPicker.selectedRow(inComponent: 0) == 5 {
            for i in 0 ... 5 {
                missionArray[i]?.text = String(30)
            }
        }
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        if let _ = level {
            timerFlag = false
            self.startTimer()
            levelView.isHidden = true
        } else {
            let alert = UIAlertController(title: "Select a level", message: "Select a level \nand press the button", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func movedBlock(_ sender: UIButton) {
        if timerFlag == false {
            moveLabel.text = ""
            
            if flagBtn1 == false {
                var tempLabel:Array<String> = Array(repeating: "", count: 2)
                tempLabel = (sender.titleLabel?.text?.split(separator: "b").map(String.init))!
                arrNum1 = Int(tempLabel[0])!
                
                if let player = appDelegate.selectedEffectAudioPlayer {
                    player.play()
                }
                
                flagBtn1 = true
            } else if flagBtn1 == true {
                var tempLabel:Array<String> = Array(repeating: "", count: 2)
                tempLabel = (sender.titleLabel?.text?.split(separator: "b").map(String.init))!
                arrNum2 = Int(tempLabel[0])!
                
                if (arrNum1 == (arrNum2-9)) || (arrNum1 == (arrNum2-1)) || (arrNum1 == (arrNum2+1)) || (arrNum1 == (arrNum2+9)) {
                    let tempImage:UIImage = (blockArray[arrNum2]?.image(for: UIControlState.normal))!
                    
                    blockArray[arrNum2]?.setImage((blockArray[arrNum1]?.image(for: UIControlState.normal))!, for: UIControlState.normal)
                    blockArray[arrNum1]?.setImage(tempImage, for: UIControlState.normal)
                    
                    moveLabel.text = "Move Success"
                    moveView.isHidden = false
                    
                    if let player = appDelegate.moveSuccessEffectAudioPlayer {
                        player.play()
                    }
                    
                    delay(bySeconds: 1) {
                        self.moveLabel.text = ""
                        self.moveView.isHidden = true
                    }
                } else {
                    moveLabel.text = "Move Fail"
                    moveView.isHidden = false
                    
                    if let player = appDelegate.moveFailEffectAudioPlayer {
                        player.play()
                    }
                    
                    delay(bySeconds: 1) {
                        self.moveLabel.text = ""
                        self.moveView.isHidden = true
                    }
                }
                flagBtn1 = false
                
                alignedHorz()
                alignedVert()
                
                while(checkSpace()) {
                    fillUp()
                    alignedHorz()
                    alignedVert()
                }
            }
        }
    }
    
    func alignedHorz() {
        for m in 0 ... 8 {
            for j in (9 * m) ... ((9 * m) + 7) {
                for i in j+1 ... ((9 * m) + 8) {
                    if blockArray[j]?.image(for: UIControlState.normal) == blockArray[i]?.image(for: UIControlState.normal) {
                        streak += 1
                    } else {
                        break
                    }
                }
                if streak >= 2 {
                    subBlock = blockArray[j]?.image(for: UIControlState.normal)
                    for k in 0 ... streak {
                        if let _ = level {
                            subMission()
                        }
                        
                        blockArray[j+k]?.setImage(nil, for: UIControlState.normal)
                        score += 250
                        scoreLabel.text = String(score)
                    }
                }
                streak = 0
            }
        }
    }
    
    func alignedVert() {
        var i:Int = 0
        var j:Int = 0
        var m:Int = 0
        
        while (m <= 8) {
            j = 9 * m
            while(j <= (9 * m) + 8) {
                i = j+9
                while (i <= 80) {
                    if blockArray[j]?.image(for: UIControlState.normal) == blockArray[i]?.image(for: UIControlState.normal) {
                        streak += 1
                    } else {
                        break
                    }
                    i += 9
                }
                if streak >= 2 {
                    subBlock = blockArray[j]?.image(for: UIControlState.normal)
                    for k in 0 ... streak {
                        if let _ = level {
                            subMission()
                        }
                        
                        blockArray[j+(k*9)]?.setImage(nil, for: UIControlState.normal)
                        score += 250
                        scoreLabel.text = String(score)
                    }
                }
                streak = 0
                j += 1
            }
            m += 1
        }
    }
    
    func fillUp() {
        var i:Int = 0
        var j:Int = 0
        
        while (j <= 80) {
            i = 0
            while (i <= 8) {
                if let _ = blockArray[i+j]?.image(for: UIControlState.normal) {
                } else {
                    let randNum: UInt32 = arc4random_uniform(UInt32(5))
                    
                    if randNum == 0 {
                        blockArray[i+j]?.setImage(bImage1, for: UIControlState.normal)
                    } else if randNum == 1 {
                        blockArray[i+j]?.setImage(bImage2, for: UIControlState.normal)
                    } else if randNum == 2 {
                        blockArray[i+j]?.setImage(bImage3, for: UIControlState.normal)
                    } else if randNum == 3 {
                        blockArray[i+j]?.setImage(bImage4, for: UIControlState.normal)
                    } else if randNum == 4 {
                        blockArray[i+j]?.setImage(bImage5, for: UIControlState.normal)
                    } else if randNum == 5 {
                        blockArray[i+j]?.setImage(bImage6, for: UIControlState.normal)
                    }
                }
                i += 1
            }
            j += 9
        }
    }
    
    func checkSpace() -> Bool {
        var i:Int = 0
        var j:Int = 0
        
        var checkSp:Bool = false
        
        while (j <= 80) {
            i = 0
            while (i <= 8) {
                if let _ = blockArray[i+j]?.image(for: UIControlState.normal) {
                } else {
                    checkSp = true
                }
                i += 1
            }
            j += 9
        }
        
        return checkSp
    }
    
    func gameEnd() {
        timerFlag = true
        
        if checkMission() {
            score += (level! * 5000)
            resultLabel.text = "Mission bonus score : \(String(level! * 5000))\nYou Scored \(score) point"
        } else {
            resultLabel.text = "You Scored \(score) point"
        }
        self.resultView.isHidden = false
        
        if (score > Int(maxScoreLabel.text!)!) {
            maxScoreLabel.text = String(score)
            appDelegate.userMaxScore = maxScoreLabel.text
        }
        
        self.delay(bySeconds: 2) {
            if self.appDelegate.flagLogin == false {
                let context = self.getContext()
                let entity = NSEntityDescription.entity(forEntityName: "LocalRecord", in: context)
                
                // LocalRecord record를 새로 생성함
                let object = NSManagedObject(entity: entity!, insertInto: context)
                
                object.setValue(String(self.score), forKey: "localscore")
                object.setValue(Date(), forKey: "playdate")
                
                do {
                    try context.save()
                    print("saved!")
                } catch let error as NSError {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                let alert = UIAlertController(title: "You played as a guest", message: "Can you Join and save score?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                let urlString: String = "http://condi.swu.ac.kr/student/W02iphone/USS_insertScore.php"
                guard let requestURL = URL(string: urlString) else {
                    return
                }
                
                var request = URLRequest(url: requestURL)
                request.httpMethod = "POST"
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let myDate = formatter.string(from: Date())
                
                var restString: String = "id=" + self.appDelegate.ID! + "&score=" + String(self.score)
                restString += "&scoredate=" + myDate + "&scorememo=" + ""
                request.httpBody = restString.data(using: .utf8)
                
                let session = URLSession.shared
                let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else {
                    print("Error: calling POST")
                    return
                    }
                }
                task.resume()
                
                self.updateServer()
                
                let alert = UIAlertController(title: "Score saved", message: "Your score has been \nsaved on the server", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func updateServer() {
        let urlString: String = "http://condi.swu.ac.kr/student/W02iphone/USS_updateScore.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let playCount = self.appDelegate.userPlayCounts
        self.appDelegate.userPlayCounts = String(Int(playCount!)! + 1)
        
        var restString: String = "id=" + self.appDelegate.ID! + "&maxscore=" + self.appDelegate.userMaxScore!
        restString += "&playcounts=" + self.appDelegate.userPlayCounts!
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else {
            print("Error: calling POST")
            return
            }
        }
        task.resume()
    }
    
    func subMission() {
        if subBlock == bImage1 {
            if Int((missionArray[0]?.text)!)! > 0 {
                missionArray[0]?.text = String(Int((missionArray[0]?.text!)!)! - 1)
            }
        } else if subBlock == bImage2 {
            if Int((missionArray[1]?.text)!)! > 0 {
                missionArray[1]?.text = String(Int((missionArray[1]?.text!)!)! - 1)
            }
        } else if subBlock == bImage3 {
            if Int((missionArray[2]?.text)!)! > 0 {
                missionArray[2]?.text = String(Int((missionArray[2]?.text!)!)! - 1)
            }
        } else if subBlock == bImage4 {
            if Int((missionArray[3]?.text)!)! > 0 {
                missionArray[3]?.text = String(Int((missionArray[3]?.text!)!)! - 1)
            }
        } else if subBlock == bImage5 {
            if Int((missionArray[4]?.text)!)! > 0 {
                missionArray[4]?.text = String(Int((missionArray[4]?.text!)!)! - 1)
            }
        } else if subBlock == bImage6 {
            if Int((missionArray[5]?.text)!)! > 0 {
                missionArray[5]?.text = String(Int((missionArray[5]?.text!)!)! - 1)
            }
        }
    }
    
    func checkMission() -> Bool {
        var check: Bool = false
        
        for i in 0 ... 5 {
            if Int((missionArray[i]?.text!)!)! == 0 {
                check = true
            } else {
                check = false
                break
            }
        }
        return check
    }
    
    @IBAction func buttonBackPressed(_ sender: UIButton) {
        if let player = appDelegate.clickEffectAudioPlayer {
            player.play()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func update() {
        timerLabel.text = String(count)
        
        count -= 1
        if(count < 0) {
            self.stopTimer()
            gameEnd()
        }
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
