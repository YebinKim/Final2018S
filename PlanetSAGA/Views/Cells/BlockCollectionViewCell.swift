//
//  BlockCollectionViewCell.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/17.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit

protocol BlockCollectionViewCellDelegate {
    
    func swipeBlock(_ selectBlock: UIButton, direction: UISwipeGestureRecognizer.Direction)
    
}

class BlockCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "blockCollectionViewCell"
    
    @IBOutlet weak var blockButton: UIButton!
    
    var delegate: BlockCollectionViewCellDelegate!
    
    private let bImage1 = #imageLiteral(resourceName: "block1").withRenderingMode(.alwaysOriginal)
    private let bImage2 = #imageLiteral(resourceName: "block5").withRenderingMode(.alwaysOriginal)
    private let bImage3 = #imageLiteral(resourceName: "block2").withRenderingMode(.alwaysOriginal)
    private let bImage4 = #imageLiteral(resourceName: "block3").withRenderingMode(.alwaysOriginal)
    private let bImage5 = #imageLiteral(resourceName: "block4").withRenderingMode(.alwaysOriginal)
    private let bImage6 = #imageLiteral(resourceName: "block6").withRenderingMode(.alwaysOriginal)

    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeBlockImage()
        addGestureRecognizers()
    }
        
    private func initializeBlockImage() {
        let randNum: UInt32 = arc4random_uniform(UInt32(6))
        
        if randNum == 0 {
            blockButton.setImage(bImage1, for: .normal)
        } else if randNum == 1 {
            blockButton.setImage(bImage2, for: .normal)
        } else if randNum == 2 {
            blockButton.setImage(bImage3, for: .normal)
        } else if randNum == 3 {
            blockButton.setImage(bImage4, for: .normal)
        } else if randNum == 4 {
            blockButton.setImage(bImage5, for: .normal)
        } else if randNum == 5 {
            blockButton.setImage(bImage6, for: .normal)
        }
    }
    
    private func addGestureRecognizers() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        
        for direction in directions {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeBlock))
            swipeGesture.direction = direction
            blockButton.addGestureRecognizer(swipeGesture)
        }
    }
    
    @objc func swipeBlock(_ sender: UISwipeGestureRecognizer) {
        delegate.swipeBlock(blockButton, direction: sender.direction)
    }
    
}
