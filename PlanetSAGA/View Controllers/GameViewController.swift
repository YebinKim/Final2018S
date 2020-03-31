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
    
    @IBOutlet weak var blockCollectionView: UICollectionView!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var menuViewLeadingConstraint: NSLayoutConstraint!
    
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
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var resultView: UIView!
    @IBOutlet var resultLabel: UILabel!
    
    @IBOutlet var levelPicker: UIPickerView!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var levelView: UIView!
    var level: Int?
    var subBlock: UIImage?
    
    private lazy var dimmedView: UIView = {
        let dimmedView = UIView(frame: self.view.frame)
        dimmedView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        dimmedView.isHidden = true
        dimmedView.alpha = 0.0
        
        return dimmedView
    }()
    
    var missionArray: Array<UILabel?> = []
    
    var streak: Int = 0
    var score: Int = 0
    
    var timer: Timer?
    //    var count = 20
    var count = 999
    var timerFlag: Bool = true
    
    private var touchPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        
        initializeMenuView()
        initializeMenuTableView()
        initializedimmedView()
        
        transitioningDelegate = self
        initializeABlockCollectionView()
        
        missionImage1.image = Properties.blockImages[0]
        missionImage2.image = Properties.blockImages[1]
        missionImage3.image = Properties.blockImages[2]
        missionImage4.image = Properties.blockImages[3]
        missionImage5.image = Properties.blockImages[4]
        missionImage6.image = Properties.blockImages[5]
        
        resultView.isHidden = true
        levelView.isHidden = false
        level = nil
        
        levelPicker.selectRow(2, inComponent: 0, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        alignedHorz()
        alignedVert()
        
        while checkSpace()  {
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
    
    private func initializeMenuView() {
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.roundCorners(corners: [.topRight, .bottomRight], radius: menuView.frame.width / 10)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissMenuView))
        swipeGesture.direction = .left
        menuView.addGestureRecognizer(swipeGesture)
    }
    
    private func initializeMenuTableView() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.tableFooterView = UIView()
    }
    
    private func initializedimmedView() {
        self.view.addSubview(dimmedView)
        self.view.bringSubviewToFront(self.menuView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenuView))
        dimmedView.addGestureRecognizer(tapGesture)
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
                })
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
    
    func alignedHorz() {
        for m in 0...8 {
            for j in (9 * m)...((9 * m) + 7) {
                let beforeIndex = IndexPath(item: j, section: 0)
                let beforeCell = blockCollectionView.cellForItem(at: beforeIndex) as? BlockCollectionViewCell
                
                for i in j + 1...((9 * m) + 8) {
                    let curIndex = IndexPath(item: i, section: 0)
                    let curCell = blockCollectionView.cellForItem(at: curIndex) as? BlockCollectionViewCell
                    
                    if beforeCell?.blockButton.image(for: .normal) == curCell?.blockButton.image(for: .normal) {
                        streak += 1
                    } else {
                        break
                    }
                }
                
                if streak >= 2 {
                    subBlock = beforeCell?.blockButton.image(for: .normal)
                    for k in 0 ... streak {
                        if let _ = level {
                            subMission()
                        }
                        
                        let changeIndex = IndexPath(item: j + k, section: 0)
                        let changeCell = blockCollectionView.cellForItem(at: changeIndex) as? BlockCollectionViewCell
                        changeCell?.blockButton.setImage(nil, for: .normal)
                        
                        score += 250
                        scoreLabel.text = String(score)
                    }
                }
                streak = 0
            }
        }
    }
    
    func alignedVert() {
        var i: Int = 0
        var j: Int = 0
        var m: Int = 0
        
        while m <= 8 {
            j = 9 * m
            
            while j <= (9 * m) + 8 {
                let beforeIndex = IndexPath(item: j, section: 0)
                let beforeCell = blockCollectionView.cellForItem(at: beforeIndex) as? BlockCollectionViewCell
                
                i = j + 9
                let curIndex = IndexPath(item: i, section: 0)
                let curCell = blockCollectionView.cellForItem(at: curIndex) as? BlockCollectionViewCell
                
                while i <= 80 {
                    if beforeCell?.blockButton.image(for: .normal) == curCell?.blockButton.image(for: .normal) {
                        streak += 1
                    } else {
                        break
                    }
                    i += 9
                }
                if streak >= 2 {
                    subBlock = beforeCell?.blockButton.image(for: .normal)
                    for k in 0 ... streak {
                        if let _ = level {
                            subMission()
                        }
                        
                        let changeIndex = IndexPath(item: j + (k * 9), section: 0)
                        let changeCell = blockCollectionView.cellForItem(at: changeIndex) as? BlockCollectionViewCell
                        changeCell?.blockButton.setImage(nil, for: .normal)
                        
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
    
    func fillUpBlock(_ block: UIButton?) {
        let randNum = Int.random(in: 0...5)
        block?.setImage(Properties.blockImages[randNum], for: .normal)
    }
    
    func fillUpBlock(index: IndexPath) {
        var curIndex = index
        var beforeIndex = IndexPath(item: curIndex.row - 9, section: 0)
        
        while let beforeCell = blockCollectionView.cellForItem(at: curIndex) as? BlockCollectionViewCell
            , let curCell = blockCollectionView.cellForItem(at: curIndex) as? BlockCollectionViewCell {
                curCell.blockButton.imageView?.image = beforeCell.blockButton.image(for: .normal)
                
                curIndex = beforeIndex
                beforeIndex = IndexPath(item: curIndex.row - 9, section: 0)
        }
        
        let curCell = blockCollectionView.cellForItem(at: curIndex) as? BlockCollectionViewCell
        fillUpBlock(curCell?.blockButton)
    }
    
    func checkSpace() -> Bool {
        guard let visibleCells = blockCollectionView.visibleCells as? [BlockCollectionViewCell] else { return false }
        
        for cell in visibleCells {
            if cell.blockButton.image(for: .normal) == nil {
                fillUpBlock(cell.blockButton)
                return true
            }
        }
        
        return false
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
        
        delay(2) {
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
        if subBlock == Properties.blockImages[0] {
            if Int((missionArray[0]?.text)!)! > 0 {
                missionArray[0]?.text = String(Int((missionArray[0]?.text!)!)! - 1)
            }
        } else if subBlock == Properties.blockImages[1] {
            if Int((missionArray[1]?.text)!)! > 0 {
                missionArray[1]?.text = String(Int((missionArray[1]?.text!)!)! - 1)
            }
        } else if subBlock == Properties.blockImages[2] {
            if Int((missionArray[2]?.text)!)! > 0 {
                missionArray[2]?.text = String(Int((missionArray[2]?.text!)!)! - 1)
            }
        } else if subBlock == Properties.blockImages[3] {
            if Int((missionArray[3]?.text)!)! > 0 {
                missionArray[3]?.text = String(Int((missionArray[3]?.text!)!)! - 1)
            }
        } else if subBlock == Properties.blockImages[4] {
            if Int((missionArray[4]?.text)!)! > 0 {
                missionArray[4]?.text = String(Int((missionArray[4]?.text!)!)! - 1)
            }
        } else if subBlock == Properties.blockImages[5] {
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
    
    func delay(_ seconds: Double, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        menuViewLeadingConstraint.constant = 0
        dimmedView.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.view.layoutIfNeeded()
            self.dimmedView.alpha = 1.0
        })
    }
    
    @objc func dismissMenuView(sender: UITapGestureRecognizer) {
        menuViewLeadingConstraint.constant = -self.menuView.frame.width
        dimmedView.isHidden = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.view.layoutIfNeeded()
            self.dimmedView.alpha = 0.0
        })
    }
    
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81 // block 개수 = 9 * 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BlockCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: BlockCollectionViewCell.identifier,
                                                                               for: indexPath) as! BlockCollectionViewCell
        cell.delegate = self
        
        return cell
    }
    
}

extension GameViewController: BlockCollectionViewCellDelegate {
    
    func swipeBlock(_ selectBlock: UIButton, direction: UISwipeGestureRecognizer.Direction) {
        guard !timerFlag,
            let indexPath = blockCollectionView.indexPathForItem(at: blockCollectionView.convert(selectBlock.center,
                                                                                                 from: selectBlock.superview)) else { return }
        
        var subBlockIndex: IndexPath?
        
        switch direction {
        case .right:
            subBlockIndex = IndexPath(item: indexPath.row + 1, section: 0)
        case .left:
            subBlockIndex = IndexPath(item: indexPath.row - 1, section: 0)
        case .up:
            subBlockIndex = IndexPath(item: indexPath.row - 9, section: 0)
        case .down:
            subBlockIndex = IndexPath(item: indexPath.row + 9, section: 0)
        default:
            print("Undetectable swipe direction")
        }
        
        if let index = subBlockIndex,
            let subBlockCell = blockCollectionView?.cellForItem(at: index) as? BlockCollectionViewCell {
            playBlockAction(selectBlock: selectBlock, subBlock: subBlockCell.blockButton)
            print("Move Success")
        } else {
            print("Move Fail")
        }
    }
    
    private func playBlockAction(selectBlock select: UIButton, subBlock sub: UIButton) {
        guard let selectImage = select.image(for: .normal),
            let subImage = sub.image(for: .normal) else { return }
        
        sub.setImage(selectImage, for: UIControl.State.normal)
        select.setImage(subImage, for: UIControl.State.normal)
        
        alignedHorz()
        alignedVert()
        
        while checkSpace() {
            alignedHorz()
            alignedVert()
        }
        
        SoundManager.clickEffect()
    }
    
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
