//
//  RankingViewCell.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/04/06.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit

class RankingViewCell: UITableViewCell {
    
    static let identifier: String = "rankingViewCell"

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
