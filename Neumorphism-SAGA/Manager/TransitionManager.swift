//
//  TransitionManager.swift
//  PlanetSAGA
//
//  Created by Yebin Kim on 2020/03/12.
//  Copyright © 2020 김예빈. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    weak var context: UIViewControllerContextTransitioning?
    
    private let animationDuration: Double
    private let animationType: AnimationType
    private let touchPoint: CGPoint
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    init(animationDuration: Double, animationType: AnimationType, touchPoint: CGPoint) {
        self.animationDuration = animationDuration
        self.animationType = animationType
        self.touchPoint = touchPoint
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
        }
        
        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            presnetAnimation(with: transitionContext, viewToAnimate: toViewController.view)
        case .dismiss:
            transitionContext.containerView.addSubview(toViewController.view)
            transitionContext.containerView.addSubview(fromViewController.view)
            dismissViewController(with: transitionContext, viewToAnimate: toViewController.view)
        }
    }
    
    func animate(toView: UIView) {
        let triggerPoint = UIView(frame: CGRect(x: touchPoint.x, y: touchPoint.y, width: 0, height: 0))
        
        // Start
        let rect = CGRect(x: triggerPoint.frame.origin.x,
                          y: triggerPoint.frame.origin.y,
                          width: triggerPoint.frame.width,
                          height: triggerPoint.frame.width)
        let circleMaskPathInitial = UIBezierPath(ovalIn: rect)
        
        // End
        let extremePoint = CGPoint(x: triggerPoint.center.x,
                                   y: triggerPoint.center.y)
        let radius = sqrt((extremePoint.x * extremePoint.x) + (extremePoint.y * extremePoint.y)) * 3
        let circleMaskPathFinal = UIBezierPath(ovalIn: triggerPoint.frame.insetBy(dx: -radius,
                                                                                  dy: -radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        toView.layer.mask = maskLayer
        
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.duration = 2.0
        maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
        maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
    
    func presnetAnimation(with transitionContext: UIViewControllerContextTransitioning,
                          viewToAnimate: UIView) {
        viewToAnimate.clipsToBounds = true
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseIn,
                       animations: {
            self.animate(toView: viewToAnimate)
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    func dismissViewController(with transitionContext: UIViewControllerContextTransitioning,
                               viewToAnimate: UIView) {
        viewToAnimate.clipsToBounds = true
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseIn,
                       animations: {
            self.animate(toView: viewToAnimate)
        }) { _ in
            transitionContext.completeTransition(true)
        }
    }
    
}
