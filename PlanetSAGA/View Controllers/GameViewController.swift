//
//  GameViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 14..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class GameViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var blockCollectionView: UICollectionView!
    
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
    var subBlock: UIImage?
    
    let bImage1: UIImage = UIImage(named:"block1.png")!
    let bImage2: UIImage = UIImage(named:"block2.png")!
    let bImage3: UIImage = UIImage(named:"block3.png")!
    let bImage4: UIImage = UIImage(named:"block4.png")!
    let bImage5: UIImage = UIImage(named:"block5.png")!
    let bImage6: UIImage = UIImage(named:"block6.png")!
    
    var missionArray: Array<UILabel?> = []
    
    var arrNum1: Int = 0
    var arrNum2: Int = 0
    var flagBtn1: Bool = false
    
    var streak: Int = 0
    var score: Int = 0
    
    var timer: Timer?
    //    var count = 20
    var count = 5
    var timerFlag: Bool = true
    
    private var touchPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        
        transitioningDelegate = self
        initializeABlockCollectionView()
        
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
        
        setUserInfo()
        
        levelPicker.selectRow(2, inComponent: 0, animated: false)
        
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
    
    private func registerCell() {
        let blockCellNib = UINib(nibName: String(describing: BlockCollectionViewCell.self), bundle: nil)
        blockCollectionView.register(blockCellNib, forCellWithReuseIdentifier: BlockCollectionViewCell.identifier)
    }
    
    private func initializeABlockCollectionView() {
        blockCollectionView.delegate = self
        blockCollectionView.dataSource = self
    }
    
    private func setUserInfo() {
        if let user = Auth.auth().currentUser {
            PSDatabase.userInfoRef
                .queryEqual(toValue: nil, childKey: user.uid)
                .observeSingleEvent(of: .value, with: { snapshot in
                    guard let child = snapshot.children.allObjects.first,
                        let snapshot = child as? DataSnapshot,
                        let userInfo = UserInfo(snapshot: snapshot) else { return }
                    
                    self.userNameLabel.text = userInfo.name
                    self.maxScoreLabel.text = String(userInfo.maxScore)
                })
        } else {
            self.userNameLabel.text = "Guest"
            self.maxScoreLabel.text = "0"
        }
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
                
                SoundManager.clickEffect()
                
                flagBtn1 = true
            } else if flagBtn1 == true {
                var tempLabel:Array<String> = Array(repeating: "", count: 2)
                tempLabel = (sender.titleLabel?.text?.split(separator: "b").map(String.init))!
                arrNum2 = Int(tempLabel[0])!
                
                if (arrNum1 == (arrNum2-9)) || (arrNum1 == (arrNum2-1)) || (arrNum1 == (arrNum2+1)) || (arrNum1 == (arrNum2+9)) {
//                    let tempImage:UIImage = (blockArray[arrNum2].image(for: UIControlState.normal))!
//
//                    blockArray[arrNum2].setImage((blockArray[arrNum1].image(for: UIControlState.normal))!, for: UIControlState.normal)
//                    blockArray[arrNum1].setImage(tempImage, for: UIControlState.normal)
                    
                    moveLabel.text = "Move Success"
                    moveView.isHidden = false
                    
                    SoundManager.clickEffect()
                    
                    delay(bySeconds: 1) {
                        self.moveLabel.text = ""
                        self.moveView.isHidden = true
                    }
                } else {
                    moveLabel.text = "Move Fail"
                    moveView.isHidden = false
                    
                    SoundManager.clickEffect()
                    
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
//                    if blockArray[j].image(for: UIControlState.normal) == blockArray[i].image(for: UIControlState.normal) {
//                        streak += 1
//                    } else {
//                        break
//                    }
                }
                if streak >= 2 {
//                    subBlock = blockArray[j].image(for: UIControlState.normal)
//                    for k in 0 ... streak {
//                        if let _ = level {
//                            subMission()
//                        }
//
//                        blockArray[j+k].setImage(nil, for: UIControlState.normal)
//                        score += 250
//                        scoreLabel.text = String(score)
//                    }
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
//                    if blockArray[j].image(for: UIControlState.normal) == blockArray[i].image(for: UIControlState.normal) {
//                        streak += 1
//                    } else {
//                        break
//                    }
                    i += 9
                }
                if streak >= 2 {
//                    subBlock = blockArray[j].image(for: UIControlState.normal)
//                    for k in 0 ... streak {
//                        if let _ = level {
//                            subMission()
//                        }
//
//                        blockArray[j+(k*9)].setImage(nil, for: UIControlState.normal)
//                        score += 250
//                        scoreLabel.text = String(score)
//                    }
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
//                if let _ = blockArray[i+j].image(for: UIControlState.normal) {
//                } else {
//                    let randNum: UInt32 = arc4random_uniform(UInt32(5))
//
//                    if randNum == 0 {
//                        blockArray[i+j].setImage(bImage1, for: UIControlState.normal)
//                    } else if randNum == 1 {
//                        blockArray[i+j].setImage(bImage2, for: UIControlState.normal)
//                    } else if randNum == 2 {
//                        blockArray[i+j].setImage(bImage3, for: UIControlState.normal)
//                    } else if randNum == 3 {
//                        blockArray[i+j].setImage(bImage4, for: UIControlState.normal)
//                    } else if randNum == 4 {
//                        blockArray[i+j].setImage(bImage5, for: UIControlState.normal)
//                    } else if randNum == 5 {
//                        blockArray[i+j].setImage(bImage6, for: UIControlState.normal)
//                    }
//                }
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
//                if let _ = blockArray[i+j].image(for: UIControlState.normal) {
//                } else {
//                    checkSp = true
//                }
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
        }
        
        self.delay(bySeconds: 2) {
            if let user = Auth.auth().currentUser {
                let now = Date().timeIntervalSince1970
                let score = Score(score: self.score, scoreDate: String(now))
                let scoreRef = PSDatabase.scoreRef.child("\(user.uid)\(Int(now))")
                scoreRef.setValue(score.toAnyObject())
                
                self.updateServer()
                
                let alert = UIAlertController(title: "Score saved", message: "Your score has been \nsaved on the server", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "You played as a guest", message: "Can you Join and save score?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func updateServer() {
        guard let user = Auth.auth().currentUser else { return }
        
        PSDatabase.userInfoRef
            .queryEqual(toValue: nil, childKey: user.uid)
            .observeSingleEvent(of: .value, with: { snapshot in
                guard let child = snapshot.children.allObjects.first,
                    let snapshot = child as? DataSnapshot,
                    let userInfo = UserInfo(snapshot: snapshot) else { return }
                
                let maxScore = max(userInfo.maxScore, self.score)
                let playCounts = userInfo.playCounts + 1
                
                let userInfoRef = PSDatabase.userInfoRef.child(user.uid)
                userInfoRef.updateChildValues(UserInfo.toPlayScore(maxScore: maxScore, playCounts: playCounts))
            })
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
    
    @IBAction func buttonBackPressed(_ button: UIButton, for event: UIEvent) {
        SoundManager.clickEffect()
        
        guard let touch = event.allTouches?.first else { return }
        self.touchPoint = touch.location(in: self.view)
        
        self.dismiss(animated: true)
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

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81 // block 개수 = 9 * 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BlockCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: BlockCollectionViewCell.identifier, for: indexPath) as! BlockCollectionViewCell
        
        return cell
    }
    
}

extension GameViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionManager(animationDuration: 1.0, animationType: .present, touchPoint: CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2))
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionManager(animationDuration: 1.0, animationType: .dismiss, touchPoint: touchPoint!)
    }
    
}
