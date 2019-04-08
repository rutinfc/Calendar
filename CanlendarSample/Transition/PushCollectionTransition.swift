//
//  PushCollectionTransition.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 28/03/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

class PushCollectionTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(0.5)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? YearViewController else {
            transitionContext.completeTransition(true)
            return
        }
        
        guard let toVC = transitionContext.viewController(forKey: .to) as? MonthViewController else {
            transitionContext.completeTransition(true)
            return
        }

        transitionContext.containerView.addSubview(fromVC.view)
        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.alpha = 0
        
        var size = fromVC.layout.sizeFor(depth: 0)
        size.height += fromVC.layout.headerReferenceSize.height
        
        let layout = CalendarPushTranslationLayout()
        layout.itemSize = size
        layout.sectionInset = fromVC.layout.sectionInset
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.focusIndexPath = toVC.initIndexPath
        layout.addTopSpacing = 30
        
        let cacheLayout = fromVC.layout
        let cacheOffset = fromVC.collectionView.contentOffset
        
        toVC.layout.focusIndexPath = toVC.initIndexPath
        
        UIView.animate(withDuration: 0.5) {
            
            fromVC.collectionView.setCollectionViewLayout(layout, animated: true) { (finish) in
                
                UIView.animate(withDuration: 0.5, animations: {
                    toVC.layout.currentDepth = 0
                    toVC.view.alpha = 1
                }) { (finish) in
                    fromVC.collectionView.setCollectionViewLayout(cacheLayout, animated: false)
                    fromVC.collectionView.contentOffset = cacheOffset
                    
                    transitionContext.completeTransition(true)
                }
            }
        }
    }
}
