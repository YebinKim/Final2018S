//
//  UserInfoCell.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/11.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit
import Firebase

protocol UserInfoCellDelegate {
    
    func alertPresent(_ alert: UIAlertController, animated: Bool)
    func alertDismiss(animated: Bool)
    func performSegue(withIdentifier: String, completion: @escaping () -> Void)
    
}

class UserInfoCell: UITableViewCell {
    
    static let identifier: String = "userInfoCell"
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signButton: UIButton!
    
    var delegate: UserInfoCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addObservers()
        
        applyStyle()
        
        initializeProfileImageView()
        initializeNameLabel()
        initializeSignButton()
        
        updateView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: Notification.Name(rawValue: "updateUser"), object: nil)
    }
    
    private func applyStyle() {
        profileImageView.tintColor = UIColor.black
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 3
    }
    
    private func initializeProfileImageView() {
        if #available(iOS 13.0, *) {
            self.profileImageView.contentMode = .center
            self.profileImageView.image = UIImage(systemName: "person")?.withRenderingMode(.alwaysTemplate)
        } else {
            self.profileImageView.image = "Guest".image()
        }
    }
    
    private func initializeNameLabel() {
        nameLabel.text = "Guest"
    }
    
    private func initializeSignButton() {
        if #available(iOS 13.0, *) {
            self.signButton.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
        } else {
            self.signButton.setImage(nil, for: .normal)
            self.signButton.setTitle("SignIn", for: .normal)
        }
    }
    
    @objc func updateView() {
        if OnlineManager.online {
            DispatchQueue.main.async {
                self.nameLabel.text = OnlineManager.userInfo?.name
                
                if let image = OnlineManager.userInfo?.profileImage {
                    self.profileImageView.contentMode = .scaleAspectFill
                    self.profileImageView.image = image
                }
                
                if #available(iOS 13.0, *) {
                    self.signButton.setImage(UIImage(systemName: "person.badge.minus"), for: .normal)
                } else {
                    self.signButton.setImage(nil, for: .normal)
                    self.signButton.setTitle("SignOut", for: .normal)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.initializeProfileImageView()
                self.initializeNameLabel()
                self.initializeSignButton()
            }
        }
    }
    
    @IBAction func signButtonTapped(_ sender: UIButton) {
        if OnlineManager.online {
            let alert = UIAlertController(title: "Logout?", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                OnlineManager.signOutUser()
                self.delegate.alertDismiss(animated: true)
            })
            alert.addAction(UIAlertAction(title: "No", style: .destructive))
            
            self.delegate.alertPresent(alert, animated: true)
        } else {
            self.delegate.performSegue(withIdentifier: "toSignIn") {
                
            }
        }
    }
    
}
