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
    
    @IBOutlet weak var blockButton: StyledButton!
    
    var delegate: BlockCollectionViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyStyled()
        addGestureRecognizers()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        initializeBlockImage()
    }
    
    private func initializeBlockImage() {
        blockButton.setTitle("", for: .normal)
    }
    
    private func applyStyled() {
        blockButton.neumorphicLayer?.cornerRadius = 12
        blockButton.neumorphicLayer?.elementBackgroundColor = self.backgroundColor?.cgColor ?? UIColor.white.cgColor
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
