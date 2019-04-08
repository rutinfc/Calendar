//
//  UIViewExtension.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 26/03/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    static func create(xibName:String) -> UIView? {
        
        if Bundle.main.path(forResource: xibName, ofType: "nib") == nil {
            return nil
        }
        
        guard let views = Bundle.main.loadNibNamed(xibName, owner: self, options: nil) as? [UIView] else {
            return nil
        }
        
        return views.first
    }
    
    func onOutline() {
        
        self.onOutline(view: self)
    }
    
    func onOutline(view:UIView) {
        
        view.layer.borderColor = UIColor.green.cgColor
        view.layer.borderWidth = 1
        
        view.subviews.forEach { (view) in
            
            self.onOutline(view: view)
        }
    }
}

extension UILabel {
    func animate(font: UIFont, duration: TimeInterval) {
        // let oldFrame = frame
        let labelScale = self.font.pointSize / font.pointSize
        self.font = font
        let oldTransform = transform
        transform = transform.scaledBy(x: labelScale, y: labelScale)
        // let newOrigin = frame.origin
        // frame.origin = oldFrame.origin // only for left aligned text
        // frame.origin = CGPoint(x: oldFrame.origin.x + oldFrame.width - frame.width, y: oldFrame.origin.y) // only for right aligned text
        setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration) {
            //L self.frame.origin = newOrigin
            self.transform = oldTransform
            self.layoutIfNeeded()
        }
    }
}
