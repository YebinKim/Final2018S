//
//  MenuCell.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/11.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit

protocol MenuCellDelegate {
    
    func performCellSegue(withIdentifier: String, sender: Any?)
    func pushCellViewController(_ viewController: UIViewController, animated: Bool)
    
}

class MenuCell: UITableViewCell {
    
    static let identifier: String = "menuCell"
    
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var menuIconImageView: UIImageView!
    
    var delegate: MenuCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ row: Int) {
        switch row {
        case 1:
            self.menuNameLabel.text = "게임 옵션"
        case 2:
            self.menuNameLabel.text = "나의 점수"
        case 3:
            self.menuNameLabel.text = "전체 랭킹"
        default:
            break
        }
    }
    
    func selectedCell(_ row: Int) {
        switch row {
        case 1:
            self.delegate.performCellSegue(withIdentifier: "toSetting", sender: "game")
        case 2, 3:
            self.delegate.pushCellViewController(ScorePagingViewController(), animated: true)
        default:
            break
        }
    }
}
