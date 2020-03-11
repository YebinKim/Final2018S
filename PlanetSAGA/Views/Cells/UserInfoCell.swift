//
//  UserInfoCell.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/11.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit
import Firebase

class UserInfoCell: UITableViewCell {
    
    static let identifier: String = "userInfoCell"
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell() {
        if OnlineManager.online {
            DispatchQueue.main.async {
                self.profileImageView.image = OnlineManager.userInfo?.profileImage
                self.nameLabel.text = OnlineManager.userInfo?.name
            }
        }
    }
    
    @IBAction func signButtonTapped(_ sender: UIButton) {
    }
    
}
