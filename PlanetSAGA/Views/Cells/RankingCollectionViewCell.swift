//
//  RankingCollectionViewCell.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/04/06.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit

class RankingCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "rankingCollectionViewCell"

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
