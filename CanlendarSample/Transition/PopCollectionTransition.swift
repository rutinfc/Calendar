//
//  PopCollectionTransition.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 02/04/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

class PopCollectionTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(0.5)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? MonthViewController else {
            transitionContext.completeTransition(true)
            return
        }
        
        guard let toVC = transitionContext.viewController(forKey: .to) as? YearViewController else {
            transitionContext.completeTransition(true)
            return
        }
        
        transitionContext.containerView.addSubview(fromVC.view)
        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.alpha = 0
        
        let layout = CalendarPopTranslationLayout()
        layout.itemSize = toVC.layout.sizeFor(depth: 1)
        layout.sectionInset = toVC.layout.sectionInset
        layout.headerReferenceSize = toVC.layout.headerReferenceSize
        layout.minimumLineSpacing = toVC.layout.minimumLineSpacing
        layout.minimumInteritemSpacing = toVC.layout.minimumInteritemSpacing
        layout.addTopSpacing = 30
        
        if let indexPath = fromVC.initIndexPath {
            layout.focusIndexPath = IndexPath(item: 0, section: indexPath.section)
            toVC.layout.focusIndexPath = IndexPath(item: 0, section: indexPath.section)
        }
        
        UIView.animate(withDuration: 0.5) {
            
            fromVC.collectionView.setCollectionViewLayout(layout, animated: true) { (finish) in
                toVC.collectionView.contentOffset = fromVC.collectionView.contentOffset
                UIView.animate(withDuration: 0.5, animations: {
                    toVC.layout.currentDepth = 1
                    toVC.view.alpha = 1
                }) { (finish) in
                    transitionContext.completeTransition(true)
                }
            }
        }
    }
}
