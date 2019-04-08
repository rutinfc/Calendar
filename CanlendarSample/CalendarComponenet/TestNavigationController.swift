//
//  TestNavigationController.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 05/04/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

class TestNavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if #available(iOS 11, *) {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if #available(iOS 11, *) {
            translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 90)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        self.subviews.forEach { (view) in
//            print("<---- \(view) | \(view.constraints)")
            
            view.constraints.forEach({ (constraint) in
                if constraint.constant == 44 {
                    constraint.constant = 90
                }
            })
        }
        
        self.constraints.forEach({ (constraint) in
            if constraint.constant == 44 {
                constraint.constant = 90
            }
        })
        
        self.layoutIfNeeded()
//        print("<---- \(self.frame) | \(self.constraints)")
    }
}

class TestNavigationController: UINavigationController {

    init() {
        super.init(navigationBarClass: TestNavigationBar.self, toolbarClass: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: TestNavigationBar.self, toolbarClass: nil)
        
        self.viewControllers = [rootViewController]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
//        fatalError("init(coder:) has not been implemented")
    }
}
