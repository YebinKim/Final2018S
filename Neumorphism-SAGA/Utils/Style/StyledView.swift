//
//  StyledView.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/27.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit

public class StyledView: UIView, StyledElementProtocol {
    
    public var neumorphicLayer: StyledLayer? {
        return layer as? StyledLayer
    }
    
    public override class var layerClass: AnyClass {
        return StyledLayer.self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        neumorphicLayer?.update()
    }
    
}

public class StyledButton: UIButton, StyledElementProtocol {
    
    public var neumorphicLayer: StyledLayer? {
        return layer as? StyledLayer
    }
    
    public override class var layerClass: AnyClass {
        return StyledLayer.self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        neumorphicLayer?.update()
    }
    
    public override var isHighlighted: Bool {
        didSet {
            if oldValue != isHighlighted {
                neumorphicLayer?.selected = isHighlighted
            }
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            if oldValue != isSelected {
                neumorphicLayer?.depthType = isSelected ? .concave : .convex
            }
        }
    }
    
}

public class StyledTableCell: UITableViewCell, StyledElementProtocol {

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var bg: StyledView?
    
    public var neumorphicLayer: StyledLayer? {
        if bg == nil {
            bg = StyledView(frame: bounds)
            bg?.neumorphicLayer?.masterView = self
            selectedBackgroundView = UIView()
            layer.masksToBounds = true
            backgroundView = bg
        }
        return bg?.neumorphicLayer
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        neumorphicLayer?.update()
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        neumorphicLayer?.selected = highlighted
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        neumorphicLayer?.selected = selected
    }
    
    public func depthTypeUpdated(to type: StyledLayerDepthType) {
        if let l = bg?.neumorphicLayer {
            layer.masksToBounds = l.depthType == .concave
        }
    }
    
}
