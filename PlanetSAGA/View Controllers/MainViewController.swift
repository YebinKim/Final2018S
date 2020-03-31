//
//  MainViewController.swift
//  univerSwuSaga
//
//  Created by 김예빈 on 2018. 5. 22..
//  Copyright © 2018년 김예빈. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class MainViewController: UIViewController {
    
    @IBOutlet weak var playButton: StyledButton!
    @IBOutlet weak var signButton: StyledButton!
    @IBOutlet weak var menuButton: StyledButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var menuViewLeadingConstraint: NSLayoutConstraint!
    
    private lazy var dimmedView: UIView = {
        let dimmedView = UIView(frame: self.view.frame)
        dimmedView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        dimmedView.isHidden = true
        dimmedView.alpha = 0.0
        
        return dimmedView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        
        addObservers()
        
        initializeMenuView()
        initializeMenuTableView()
        initializedimmedView()
        
        applyStyled()
        
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func registerCell() {
        let userInfoCellNib = UINib(nibName: String(describing: UserInfoCell.self), bundle: nil)
        menuTableView.register(userInfoCellNib, forCellReuseIdentifier: UserInfoCell.identifier)
        
        let menuCellNib = UINib(nibName: String(describing: MenuCell.self), bundle: nil)
        menuTableView.register(menuCellNib, forCellReuseIdentifier: MenuCell.identifier)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notification.Name(rawValue: "updateUser"), object: nil)
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
    
    private func applyStyled() {
        playButton.neumorphicLayer?.cornerRadius = 12
        playButton.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        signButton.neumorphicLayer?.cornerRadius = 12
        signButton.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
        
        menuButton.neumorphicLayer?.cornerRadius = 12
        menuButton.neumorphicLayer?.elementBackgroundColor = self.view.backgroundColor?.cgColor ?? UIColor.white.cgColor
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        menuViewLeadingConstraint.constant = 0
        dimmedView.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.view.layoutIfNeeded()
            self.dimmedView.alpha = 1.0
        })
    }
    
    @IBAction func signButtonTapped(_ sender: UIButton) {
        if OnlineManager.online {
            let alert = UIAlertController(title: "Logout?", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                OnlineManager.signOutUser()
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(UIAlertAction(title: "No", style: .destructive))
            
            self.present(alert, animated: true)
        } else {
            self.performSegue(withIdentifier: "toSignIn", sender: nil)
        }
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        SoundManager.clickEffect()
    }
    
    @objc func updateView() {
        if OnlineManager.online {
            DispatchQueue.main.async {
                self.signButton.setImage(UIImage(systemName: "person.badge.minus"), for: .normal)
            }
        } else {
            DispatchQueue.main.async {
                self.signButton.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
            }
        }
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

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoCell.identifier) as? UserInfoCell else {
                print("Error: UserInfoCell configure error")
                return UITableViewCell()
            }
            cell.delegate = self
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier) as? MenuCell else {
                print("Error: MenuCell configure error")
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configureCell(indexPath.row)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier) as? MenuCell else {
                print("Error: MenuCell select error")
                return
            }
            cell.delegate = self
            cell.selectedCell(indexPath.row)
        }
    }
    
}

extension MainViewController: UserInfoCellDelegate, MenuCellDelegate {
    
    func alertPresent(_ alert: UIAlertController, animated: Bool) {
        self.present(alert, animated: animated)
    }
    
    func alertDismiss(animated: Bool) {
        self.dismiss(animated: animated)
    }
    
    func performSegue(withIdentifier: String) {
        self.performSegue(withIdentifier: withIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingVC = segue.destination as? SettingViewController {
            if segue.identifier == "toSettingGame" {
                settingVC.selectedSegmentIndex = 0
            } else {
                settingVC.selectedSegmentIndex = 1
            }
        }
    }
    
}
