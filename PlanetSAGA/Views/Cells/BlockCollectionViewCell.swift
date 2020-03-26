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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeBlockImage()
        addGestureRecognizers()
    }
    
    private func initializeBlockImage() {
        let randNum = Int.random(in: 0...5)
        blockButton.setImage(Properties.blockImages[randNum], for: .normal)
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
