//
//  UIColorExtension.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 05/04/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func rgb(hexValue:Int, alpha:CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0 ,
                       green: CGFloat((hexValue & 0xFF00) >> 8) / 255.0 ,
                       blue: CGFloat((hexValue & 0xFF)) / 255.0 ,
                       alpha: alpha)
    }
    
    func toImage() -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
