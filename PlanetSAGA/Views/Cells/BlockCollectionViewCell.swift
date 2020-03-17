//
//  BlockCollectionViewCell.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/17.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit

class BlockCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "blockCollectionViewCell"
    
    @IBOutlet weak var blockButton: UIButton!
    
    let bImage1: UIImage = UIImage(named:"block1.png")!
    let bImage2: UIImage = UIImage(named:"block2.png")!
    let bImage3: UIImage = UIImage(named:"block3.png")!
    let bImage4: UIImage = UIImage(named:"block4.png")!
    let bImage5: UIImage = UIImage(named:"block5.png")!
    let bImage6: UIImage = UIImage(named:"block6.png")!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        blockButton.imageView?.image?.withRenderingMode(.alwaysOriginal)
        
        initializeBlockImage()
    }
    
    private func initializeBlockImage() {
        let randNum: UInt32 = arc4random_uniform(UInt32(6))
        
        if randNum == 0 {
            blockButton.setImage(bImage1, for: UIControlState.normal)
        } else if randNum == 1 {
            blockButton.setImage(bImage2, for: UIControlState.normal)
        } else if randNum == 2 {
            blockButton.setImage(bImage3, for: UIControlState.normal)
        } else if randNum == 3 {
            blockButton.setImage(bImage4, for: UIControlState.normal)
        } else if randNum == 4 {
            blockButton.setImage(bImage5, for: UIControlState.normal)
        } else if randNum == 5 {
            blockButton.setImage(bImage6, for: UIControlState.normal)
        }
    }

}
