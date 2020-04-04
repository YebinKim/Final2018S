//
//  HSBColor.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/27.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit

struct HSBColor {
    
    var hue: CGFloat
    var saturation: CGFloat
    var brightness: CGFloat
    var alpha: CGFloat
    
    var uiColor: UIColor {
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
}
