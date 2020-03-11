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
        
        initializeMenuView()
        initializeMenuTableView()
        initializeBackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = Auth.auth().currentUser {
//            DispatchQueue.main.async {
//                self.signButton.setTitle("SignOut", for: .normal)
//            }
            
            PSDatabase.userInfoRef
                .queryEqual(toValue: nil, childKey: user.uid)
                .observeSingleEvent(of: .value, with: { snapshot in
                    guard let child = snapshot.children.allObjects.first,
                        let snapshot = child as? DataSnapshot,
                        let userInfo = UserInfo(snapshot: snapshot) else { return }

//                    DispatchQueue.main.async {
//                        self.nameLabel.text = userInfo.name
//                    }
                    
                    let storageRef = PSDatabase.storageRef.child(user.uid)

                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error, data == nil {
                            print("Error: \(error.localizedDescription)")
                        } else {
//                            DispatchQueue.main.async {
//                                self.profileImageview.image = UIImage(data: data!)
//                            }
                        }
                    }
                })
        } else {
//            DispatchQueue.main.async {
//                self.signButton.setTitle("SignIn", for: .normal)
//            }
        }
    }
    
    private func initializeMenuView() {
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
    
    @objc func dismissMenuView(sender: UITapGestureRecognizer) {
        menuViewLeadingConstraint.constant = -self.menuView.frame.width
        backView.isHidden = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.view.layoutIfNeeded()
            self.backView.alpha = 0.0
        })
    }
    
    @IBAction func buttonLogoutPressed(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            let alert = UIAlertController(title: "Logout?", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                do {
                    try Auth.auth().signOut()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
                self.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            self.performSegue(withIdentifier: "toSignIn", sender: nil)
        }
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        SoundManager.clickEffect()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
