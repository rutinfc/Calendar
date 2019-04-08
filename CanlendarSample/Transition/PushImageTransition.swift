//
//  PushTransition.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 21/03/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

class PushImageTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var originalCell : UICollectionViewCell?
    var animationView : UIView?
    var animationFinalFrame : CGRect = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(0.5)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.cancelInteractiveTransition()
            return
        }
        
        guard let targetView = self.animationView else {
            transitionContext.cancelInteractiveTransition()
            return
        }
        
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.cancelInteractiveTransition()
            return
        }
        self.originalCell?.alpha = 0
        toView.alpha = 0
        containerView.addSubview(toView)
        containerView.addSubview(targetView)
        
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            toView.alpha = 1
            toView.frame = finalFrame
            var frame = self.animationFinalFrame
            frame.origin.y += 140
//            frame.size.height -= 100
            targetView.frame = frame
            targetView.contentScaleFactor = 0.3
            
        }) { (finish) in
            
            if toView.frame.size != finalFrame.size {
                toView.frame = finalFrame
            }
            
            targetView.removeFromSuperview()
            
            self.originalCell?.alpha = 1
            
            transitionContext.completeTransition((transitionContext.transitionWasCancelled == false))
        }
    }
}
