//
//  ImageManager.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/06/13.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit

final class ImageManager: NSObject {
    
    static func createDefaultProfileImage() -> UIImage {
        let bgColor = UIColor.clear
        return createDefaultProfileImage(bgColor: bgColor)
    }
    
    static func createDefaultProfileImage(bgColor: UIColor?) -> UIImage {
        guard
            let bgColor = bgColor,
            var profileImage = UIImage(named: "ic_profile") else {
                return UIImage()
        }
        
        if bgColor.isDark && bgColor != UIColor.clear {
            profileImage = profileImage.withTintColor(UIColor.white)
        }
        
        let newFrame: CGRect = CGRect(x: 0,
                                      y: 0,
                                      width: profileImage.size.width * 1.5,
                                      height: profileImage.size.height * 1.5)
        
        UIGraphicsBeginImageContextWithOptions(newFrame.size, false, 0.0)
        bgColor.setFill()
        
        let path = UIBezierPath(rect: newFrame)
        path.fill()
        
        let position: CGPoint = CGPoint(x: (newFrame.width - profileImage.size.width) / 2.0,
                                        y: (newFrame.height - profileImage.size.height) / 2.0)
        profileImage.draw(at: position)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
