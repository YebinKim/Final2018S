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
        guard
            let profileImage = UIImage(named: "ic_profile")?.withTintColor(UIColor.white),
            let bgColor = UIColor(named: "color_main") else {
                return UIImage()
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
