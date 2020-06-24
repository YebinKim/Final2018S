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

class GameViewController: UIViewController {
    
    @IBOutlet weak var pauseButton: StyledButton!
    @IBOutlet weak var backButton: StyledButton!
    
    @IBOutlet weak var blockCollectionView: UICollectionView!
    
    @IBOutlet weak var missionView: StyledView!
    
    @IBOutlet weak var missionImage1: UIImageView!
    @IBOutlet weak var missionImage2: UIImageView!
    @IBOutlet weak var missionImage3: UIImageView!
    @IBOutlet weak var missionImage4: UIImageView!
    @IBOutlet weak var missionImage5: UIImageView!
    @IBOutlet weak var missionImage6: UIImageView!
    
    @IBOutlet weak var missionLabel1: UILabel!
    @IBOutlet weak var missionLabel2: UILabel!
    @IBOutlet weak var missionLabel3: UILabel!
    @IBOutlet weak var missionLabel4: UILabel!
    @IBOutlet weak var missionLabel5: UILabel!
    @IBOutlet weak var missionLabel6: UILabel!
    
    @IBOutlet weak var timerView: StyledView!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet var resultView: StyledView!
    @IBOutlet var resultLabel: UILabel!
    
    @IBOutlet var levelPicker: UIPickerView!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var levelView: UIView!
    var level: Int?
    
    private lazy var dimmedView: UIView = {
        let dimmedView = UIView(frame: self.view.frame)
        dimmedView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        dimmedView.isHidden = true
        dimmedView.alpha = 0.0
        
        return dimmedView
    }()
    
    private lazy var scoreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private var scoreSubLabels: [CountDownLabel] = []
    
    private var scoreSubLabel: CountDownLabel {
        let label = CountDownLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(named: "color_main")
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }
    
    private var scoreSubView: StyledView {
        let view = StyledView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.neumorphicLayer?.cornerRadius = 12
        view.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        return view
    }
    
    private var blockArray: [Int?] = (0...80).map { _ in Int.random(in: 0...5)}
    
    private var missionArray: Array<UILabel?> = []
    
    private var streak: Int = 0
    private var score: Int = 0
    
    private var count = 20
    private var timer: Timer?
    private var timerFlag: Bool = false
    
    private var touchPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        
        transitioningDelegate = self
        
        initializeBlockCollectionView()
        initializeDimmedView()
        initializeScoreStackView()
        initializeMissionView()
        initializeLevelPicker()
        
        resultView.isHidden = true
        levelView.isHidden = false
        level = nil
        
        applyStyled()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        alignedHorz()
        alignedVert()
        
        while checkSpace()  {
            fillUpBlock()
            alignedHorz()
            alignedVert()
        }
    }
    
    private func registerCell() {
        let blockCellNib = UINib(nibName: String(describing: BlockCollectionViewCell.self), bundle: nil)
        blockCollectionView.register(blockCellNib, forCellWithReuseIdentifier: BlockCollectionViewCell.identifier)
    }
    
    private func initializeBlockCollectionView() {
        blockCollectionView.delegate = self
        blockCollectionView.dataSource = self
    }
    
    private func initializeDimmedView() {
        self.view.addSubview(dimmedView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenuView))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    private func initializeScoreStackView() {
        self.view.addSubview(scoreStackView)
        scoreStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        scoreStackView.topAnchor.constraint(equalTo: self.timerView.bottomAnchor, constant: 64).isActive = true
    }
    
    private func initializeMissionView() {
        missionImage1.image = Properties.blockImages[0]
        missionImage2.image = Properties.blockImages[1]
        missionImage3.image = Properties.blockImages[2]
        missionImage4.image = Properties.blockImages[3]
        missionImage5.image = Properties.blockImages[4]
        missionImage6.image = Properties.blockImages[5]
        
        missionArray.append(missionLabel1)
        missionArray.append(missionLabel2)
        missionArray.append(missionLabel3)
        missionArray.append(missionLabel4)
        missionArray.append(missionLabel5)
        missionArray.append(missionLabel6)
    }
    
    private func initializeLevelPicker() {
        levelPicker.setValue(UIColor(named: "color_back"), forKeyPath: "textColor")
        levelPicker.selectRow(2, inComponent: 0, animated: false)
    }
    
    private func applyStyled() {
        pauseButton.neumorphicLayer?.cornerRadius = 12
        pauseButton.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        backButton.neumorphicLayer?.cornerRadius = 12
        backButton.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        timerView.neumorphicLayer?.cornerRadius = 12
        timerView.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        missionView.neumorphicLayer?.cornerRadius = 12
        missionView.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        resultView.neumorphicLayer?.cornerRadius = 12
        resultView.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        resultView.neumorphicLayer?.elementDepth = 0
    }
    
    private func addScoreStackView() {
        let newScoreSubView = scoreSubView
        let newScoreSubLabel = scoreSubLabel
        
        scoreStackView.addArrangedSubview(newScoreSubView)
        newScoreSubView.addSubview(newScoreSubLabel)
        
        newScoreSubLabel.topAnchor.constraint(equalTo: newScoreSubView.topAnchor).isActive = true
        newScoreSubLabel.bottomAnchor.constraint(equalTo: newScoreSubView.bottomAnchor).isActive = true
        newScoreSubLabel.leadingAnchor.constraint(equalTo: newScoreSubView.leadingAnchor).isActive = true
        newScoreSubLabel.trailingAnchor.constraint(equalTo: newScoreSubView.trailingAnchor).isActive = true
        
        scoreSubLabels.append(newScoreSubLabel)
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
    
    private func updateServer() {
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
    
    private func calculateScore() {
        let scoreString = String(score).map { String($0) }
        
        while scoreString.count > scoreSubLabels.count {
            addScoreStackView()
        }
        
        guard scoreSubLabels.count != 0 else { return }
        
        for i in 0..<scoreSubLabels.count {
            scoreSubLabels[i].text = scoreString[i]
        }
    }
    
    private func alignedHorz() {
        for m in 0...8 {
            for j in (9 * m)...((9 * m) + 7) {
                for i in j + 1...((9 * m) + 8) {
                    if blockArray[j] == blockArray[i] {
                        streak += 1
                    } else {
                        break
                    }
                }
                
                if streak >= 2 {
                    for k in 0 ... streak {
                        if let index = blockArray[k], timerFlag {
                            score += 50
                            calculateScore()
                            subMission(index: index)
                        }
                        
                        blockArray[j + k] = nil
                    }
                }
                streak = 0
            }
        }
    }
    
    private func alignedVert() {
        var i: Int = 0
        var j: Int = 0
        var m: Int = 0
        
        while m <= 8 {
            j = 9 * m
            
            while j <= (9 * m) + 8 {
                i = j + 9
                
                while i <= 80 {
                    if blockArray[j] == blockArray[i] {
                        streak += 1
                    } else {
                        break
                    }
                    i += 9
                }
                if streak >= 2 {
                    for k in 0 ... streak {
                        if let index = blockArray[k], timerFlag {
                            score += 50
                            calculateScore()
                            subMission(index: index)
                        }
                        
                        blockArray[j + (k * 9)] = nil
                    }
                }
                streak = 0
                j += 1
            }
            m += 1
        }
    }
    
    private func fillUpBlock() {
        for (index, block) in blockArray.enumerated() {
            if block == nil {
                fillUpBlock(index: index)
            }
        }
    }
    
    private func fillUpBlock(index curIndex: Int) {
        let upIndex = curIndex - 9
        
        if upIndex > 0 {
            blockArray[curIndex] = blockArray[upIndex]
            
            fillUpBlock(index: upIndex)
        } else {
            let randNum = Int.random(in: 0...5)
            blockArray[curIndex] = randNum
        }
    }
    
    private func checkSpace() -> Bool {
        for block in blockArray {
            if block == nil {
                return true
            }
        }
        
        blockCollectionView.reloadData()
        
        return false
    }
    
    private func gameEnd() {
        timerFlag = false
        
        resultView.isHidden = false
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.blockCollectionView.alpha = 0.0
        }) { _ in
            self.resultView.neumorphicLayer?.elementDepth = 5
        }
        
        if checkMission() {
            score += (level! * 5000)
            resultLabel.text = "미션 클리어 보너스: \(String(level! * 5000))\n\(score) 점을 획득하셨습니다"
        } else {
            resultLabel.text = "\(score) 점을 획득하셨습니다"
        }
        
        delay(2) {
            if let user = Auth.auth().currentUser {
                let now = Date().timeIntervalSince1970
                let score = Score(score: self.score, scoreDate: String(now))
                let scoreRef = PSDatabase.scoreRef.child("\(user.uid)\(Int(now))")
                scoreRef.setValue(score.toAnyObject())
                
                self.updateServer()
                
                let alert = UIAlertController(title: "점수 저장", message: "점수가 서버에 저장되었습니다", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "게스트 플레이", message: "계정을 만들고 서버에 점수를 저장할까요?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "계정 생성", style: .default, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "다음에 할게요", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func subMission(index: Int) {
        guard let remainText = missionArray[index]?.text, let remain = Int(remainText) else { return }
        if remain > 0 {
            missionArray[index]?.text = String(remain - 1)
        }
    }
    
    private func checkMission() -> Bool {
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
    
    @IBAction func selectLevel(_ sender: UIButton) {
        let selectLevel = levelPicker.selectedRow(inComponent: 0) + 1
        levelLabel.text = "난이도 \(selectLevel) 으로 게임을 시작할까요?"
        level = selectLevel
        
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
        if level != nil {
            timerFlag = true
            startTimer()
            levelView.isHidden = true
        } else {
            let alert = UIAlertController(title: "레벨 미선택", message: "레벨을 선택해주세요", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func buttonBackPressed(_ button: UIButton, for event: UIEvent) {
        SoundManager.shared.playClickEffect()
        
        guard let touch = event.allTouches?.first else { return }
        self.touchPoint = touch.location(in: self.view)
        
        self.dismiss(animated: true)
    }
    
    func startTimer() {
        timerLabel.text = String(count)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    @objc func update() {
        if timerFlag {
            count -= 1
            timerLabel.text = String(count)
        }
        
        if count <= 0 {
            stopTimer()
            gameEnd()
        }
    }
    
    func delay(_ seconds: Double, closure: @escaping () -> Void) {
        let dispatchTime = DispatchTime.now() + seconds
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: closure)
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        dimmedView.isHidden = false
        timerFlag = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.dimmedView.alpha = 1.0
            self.blockCollectionView.alpha = 0.0
        })
    }
    
    @objc func dismissMenuView(sender: UITapGestureRecognizer) {
        dimmedView.isHidden = true
        timerFlag = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.dimmedView.alpha = 0.0
            self.blockCollectionView.alpha = 1.0
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
        
        if let index = blockArray[indexPath.row] {
            cell.blockButton.setImage(Properties.blockImages[index], for: .normal)
        }
        
        return cell
    }
    
}

extension GameViewController: BlockCollectionViewCellDelegate {
    
    func swipeBlock(_ selectBlock: UIButton, direction: UISwipeGestureRecognizer.Direction) {
        guard timerFlag,
            let selectIndex = blockCollectionView.indexPathForItem(at: blockCollectionView
                .convert(selectBlock.center,
                         from: selectBlock.superview)) else { return }
        var subIndex: IndexPath?
        
        switch direction {
        case .right:
            subIndex = IndexPath(item: selectIndex.row + 1, section: 0)
        case .left:
            subIndex = IndexPath(item: selectIndex.row - 1, section: 0)
        case .up:
            subIndex = IndexPath(item: selectIndex.row - 9, section: 0)
        case .down:
            subIndex = IndexPath(item: selectIndex.row + 9, section: 0)
        default:
            print("Undetectable swipe direction")
        }
        
        if let subIndex = subIndex {
            playBlockAction(selectIndex: selectIndex, subIndex: subIndex)
            print("Move Success")
        } else {
            print("Move Fail")
        }
    }
    
    private func playBlockAction(selectIndex select: IndexPath, subIndex sub: IndexPath) {
        blockArray.swapAt(select.row, sub.row)
        
        alignedHorz()
        alignedVert()
        
        while checkSpace() {
            fillUpBlock()
            alignedHorz()
            alignedVert()
        }
        
        SoundManager.shared.playClickEffect()
    }
    
}

extension GameViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
