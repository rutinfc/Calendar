//
//  CalendarViewController.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 27/03/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

class CalendarViewController: UICollectionViewController {
    
    var layout = CalendarLayout()
    var dataHandler = CalendarDataHandler()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView.scrollsToTop = false
        self.collectionView.collectionViewLayout = self.layout
        self.dataHandler.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.layout.traitCollection = self.traitCollection
    }
    
    func scrollTo(indexPath:IndexPath) {
        
        self.collectionView.reloadData()
        
        self.collectionView.performBatchUpdates(nil) { (finish) in
            
            self.collectionView.scrollToItem(at: indexPath, at: .top, animated:false)
            var offset = self.collectionView.contentOffset
            
            guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                return
            }
            
            offset.y -= layout.headerReferenceSize.height
            if offset.y < 0 {
                offset.y = 0
            }
            self.collectionView.contentOffset = offset
        }
    }
    
    func currentIndexPath() -> IndexPath? {
        var offset = self.collectionView.contentOffset
        offset.x += (self.collectionView.safeAreaInsets.left + 10)
        offset.y += (self.collectionView.adjustedContentInset.top + self.layout.headerReferenceSize.height + 10)
        
        return self.collectionView.indexPathForItem(at: offset)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        self.layout.focusIndexPath = self.currentIndexPath()
        
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.layout.traitCollection = self.traitCollection
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.dataHandler.numberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.dataHandler.numberOfSection(section: section)
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        self.dataHandler.checkCurrentYear()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if decelerate == false {
            return
        }
        
//        self.dataHandler.checkCurrentYear()
    }
}

extension CalendarViewController : CalendarDataHandlerDelegate {
    
    func firstVisibleIndexPath() -> IndexPath? {
        return self.collectionView.indexPathsForVisibleItems.first
    }
    
    func scrollCurrentYear() {
        
        let yearSection = CalendarManager.instance.indexOfCurrentYear()
        
        let indexPath = IndexPath(item: 0, section: yearSection)
        
        self.scrollTo(indexPath: indexPath)
    }
}
