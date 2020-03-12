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
    func performSegue(withIdentifier: String)
    
}

class UserInfoCell: UITableViewCell {
    
    static let identifier: String = "userInfoCell"
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    
    var delegate: UserInfoCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addObservers()
        
        applyStyle()
        
        initializeProfileImageView()
        initializeNameLabel()
        
        updateView()
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
    
    @objc func updateView() {
        if OnlineManager.online {
            DispatchQueue.main.async {
                self.nameLabel.text = OnlineManager.userInfo?.name
                
                if let image = OnlineManager.userInfo?.profileImage {
                    self.profileImageView.contentMode = .scaleAspectFill
                    self.profileImageView.image = image
                }
            }
        } else {
            DispatchQueue.main.async {
                self.initializeProfileImageView()
                self.initializeNameLabel()
            }
        }
    }
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        self.delegate.performSegue(withIdentifier: "toSettingUser")
    }
    
}
