//
//  MonthViewController.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 27/03/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

private let largeReuseIdentifier = "MonthLargeCell"

class MonthViewController: CalendarViewController {
    
    let popTransition = PopCollectionTransition()
    
    var topContraints : NSLayoutConstraint?
    var weekdayHeightContraints : NSLayoutConstraint?
    var initIndexPath : IndexPath?
    var weekdayView : UIView?
    
    @IBOutlet weak var backButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "YearHeader")
        self.layout.headerReferenceSize = CGSize.zero
        self.collectionView.register(CalendarMonthLargeCell.self, forCellWithReuseIdentifier: largeReuseIdentifier)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layout.currentDepth = 0
        

        if let view = CalendarWeekdayView.create(xibName: "CalendarWeekdayView") {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
            
            self.topContraints = view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
            self.topContraints?.isActive = true
            self.weekdayHeightContraints = view.heightAnchor.constraint(equalToConstant: 30)
            self.weekdayHeightContraints?.isActive = true
            
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            
            self.weekdayView = view
            self.additionalSafeAreaInsets.top = 30
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        self.topContraints?.constant = (self.view.safeAreaInsets.top - self.additionalSafeAreaInsets.top)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.weekdayView?.bringSubviewToFront(self.view)
        self.topContraints?.constant = self.view.safeAreaInsets.top - (self.additionalSafeAreaInsets.top * 2)
        self.weekdayHeightContraints?.constant = self.additionalSafeAreaInsets.top
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        if let indexPath = self.initIndexPath {
            self.scrollTo(indexPath: indexPath)
        }
        
        UIView.animate(withDuration: 0.4) {
            self.topContraints?.constant = (self.view.safeAreaInsets.top - self.additionalSafeAreaInsets.top)
            self.weekdayView?.layoutIfNeeded()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.weekdayHeightContraints?.constant = 0
        self.weekdayView?.layoutIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexPath = self.currentIndexPath() {
            self.updateTitle(indexPath: indexPath)
        }
    }
    
    func updateTitle(indexPath:IndexPath) {
        
        if self.layout.focusIndexPath == nil {
            self.backButton.setTitle(nil, for: .normal)
            return
        }
        
        let title = self.dataHandler.titleOfSection(section: indexPath.section)
        
        self.backButton.setTitle(title, for: .normal)
    }
    
    @IBAction func close(_ sender: Any) {
        
        self.initIndexPath = self.currentIndexPath()
        
        self.navigationController?.delegate = self
        self.navigationController?.popViewController(animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeReuseIdentifier, for: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? CalendarMonthLargeCell, let info = self.dataHandler.monthInfoOf(indexPath: indexPath) as? MonthInfo {
            cell.setMonth(info: info)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "YearHeader", for: indexPath)
    }
}

extension MonthViewController : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if (fromVC == self) {
            return self.popTransition
        }

        return nil
    }
}
