//
//  Properties.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/26.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit

class Properties: NSObject {
    
    static let blockImages: [UIImage] = [(UIImage(systemName: "moon.fill") ?? UIImage()).withRenderingMode(.alwaysTemplate),
                                         (UIImage(systemName: "star.fill") ?? UIImage()).withRenderingMode(.alwaysTemplate),
                                         (UIImage(systemName: "suit.heart.fill") ?? UIImage()).withRenderingMode(.alwaysTemplate),
                                         (UIImage(systemName: "suit.club.fill") ?? UIImage()).withRenderingMode(.alwaysTemplate),
                                         (UIImage(systemName: "suit.spade.fill") ?? UIImage()).withRenderingMode(.alwaysTemplate),
                                         (UIImage(systemName: "suit.diamond.fill") ?? UIImage()).withRenderingMode(.alwaysTemplate)]
    
}
