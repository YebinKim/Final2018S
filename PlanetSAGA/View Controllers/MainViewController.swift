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
    
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var menuViewLeadingConstraint: NSLayoutConstraint!
    
    private var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        
        addObservers()
        
        initializeMenuView()
        initializeMenuTableView()
        initializeBackView()
        
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        menuTableView.tableFooterView = nil
    }
    
    private func initializeBackView() {
        backView = UIView(frame: self.view.frame)
        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        backView.isHidden = true
        backView.alpha = 0.0
        self.view.addSubview(backView)
        self.view.bringSubview(toFront: self.menuView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenuView))
        backView.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        menuViewLeadingConstraint.constant = 0
        backView.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.view.layoutIfNeeded()
            self.backView.alpha = 1.0
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
                if #available(iOS 13.0, *) {
                    self.signButton.setImage(UIImage(systemName: "person.badge.minus"), for: .normal)
                } else {
                    self.signButton.setImage(nil, for: .normal)
                    self.signButton.setTitle("SignOut", for: .normal)
                }
            }
        } else {
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                    self.signButton.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
                } else {
                    self.signButton.setImage(nil, for: .normal)
                    self.signButton.setTitle("SignIn", for: .normal)
                }
            }
        }
    }
    
    @objc func dismissMenuView(sender: UITapGestureRecognizer) {
        menuViewLeadingConstraint.constant = -self.menuView.frame.width
        backView.isHidden = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.view.layoutIfNeeded()
            self.backView.alpha = 0.0
        })
    }
    
}

extension MainViewController: UserInfoCellDelegate {
    
    func alertPresent(_ alert: UIAlertController, animated: Bool) {
        self.present(alert, animated: animated)
    }
    
    func alertDismiss(animated: Bool) {
        self.dismiss(animated: animated)
    }
    
    func performSegue(withIdentifier: String, completion: @escaping () -> Void) {
        self.performSegue(withIdentifier: withIdentifier, sender: nil)
        completion()
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoCell.identifier) as! UserInfoCell
            cell.delegate = self
//            cell.configureCell()
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier) as! MenuCell
            
            return cell
        }
    }
    
}
