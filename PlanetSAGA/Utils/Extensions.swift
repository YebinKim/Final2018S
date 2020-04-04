//
//  Extensions.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/11.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

extension UIColor {
    
    public convenience init(RGB: Int) {
        var rgb = RGB
        rgb = rgb > 0xffffff ? 0xffffff : rgb
        let r = CGFloat(rgb >> 16) / 255.0
        let g = CGFloat(rgb >> 8 & 0x00ff) / 255.0
        let b = CGFloat(rgb & 0x0000ff) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    public func getTransformedColor(saturation: CGFloat, brightness: CGFloat) -> UIColor {
        var hsb = getHSBColor()
        hsb.saturation *= saturation
        hsb.brightness *= brightness
        
        if hsb.saturation > 1 { hsb.saturation = 1 }
        if hsb.brightness > 1 { hsb.brightness = 1 }
        
        return hsb.uiColor
    }
    
    private func getHSBColor() -> HSBColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
}

extension String {
    
    func image(withAttributes attributes: [NSAttributedString.Key: Any]? = nil,
               size: CGSize? = nil) -> UIImage? {
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        UIGraphicsBeginImageContext(size)
        (self as NSString).draw(in: CGRect(origin: .zero, size: size),
                                withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}

extension Int {
    
    var formatted: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
}
