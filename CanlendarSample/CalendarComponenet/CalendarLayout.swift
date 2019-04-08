//
//  CalendarLayout.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 20/03/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

struct CalendarLayoutInfo {
    var horizontal : CGFloat = 0
    var vertical : CGFloat = 0
}

class CalendarTransitionAttributes: UICollectionViewLayoutAttributes {
    
}

class CalendarPushTranslationLayout: UICollectionViewFlowLayout {
    
    var focusIndexPath : IndexPath?
    var addTopSpacing : CGFloat = 0
    
    override class var layoutAttributesClass: AnyClass {
        return CalendarTransitionAttributes.self
    }
    
    override func prepare() {
        super.prepare()
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        attributes?.forEach({ (attribute) in
            
            if attribute.representedElementCategory == .supplementaryView {
                attribute.alpha = 0
            }
            
            if let indexPath = self.focusIndexPath {
                if attribute.indexPath != indexPath {
                    attribute.alpha = 0
                    attribute.zIndex = -1
                } else {
                    attribute.zIndex = 1
                }
            }
        })
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = super.layoutAttributesForItem(at: indexPath)
        
        if let selectedIndexPath = self.focusIndexPath {
            if indexPath != selectedIndexPath {
                attr?.alpha = 0
                attr?.zIndex = -1
            } else {
                attr?.zIndex = 1
            }
        }
        
        return attr
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        
        attr?.alpha = 0
        
        return attr
    }
    
    override func finalizeLayoutTransition() {
        super.finalizeLayoutTransition()
        self.focusIndexPath = nil
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        
        guard let indexPath = self.focusIndexPath, let collectionView = self.collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        guard let attribute = self.layoutAttributesForItem(at: indexPath) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        var top = collectionView.contentInset.top + collectionView.adjustedContentInset.top
        
        top += (self.headerReferenceSize.height + self.addTopSpacing)
        
        return CGPoint(x:0, y:attribute.frame.minY - top)
    }
}

class CalendarPopTranslationLayout: UICollectionViewFlowLayout {
    
    var focusIndexPath : IndexPath?
    var addTopSpacing : CGFloat = 0
    
    override class var layoutAttributesClass: AnyClass {
        return CalendarTransitionAttributes.self
    }
    
    override func prepare() {
        super.prepare()
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
    }
    
    override func finalizeLayoutTransition() {
        super.finalizeLayoutTransition()
        self.focusIndexPath = nil
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        
        guard let indexPath = self.focusIndexPath, let collectionView = self.collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        guard let attribute = self.layoutAttributesForItem(at: indexPath) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        var top = collectionView.contentInset.top + collectionView.adjustedContentInset.top
        
        top += (self.headerReferenceSize.height - self.addTopSpacing)
        
        return CGPoint(x:0, y:attribute.frame.minY - top)
    }
}

class CalendarLayout: UICollectionViewFlowLayout {
    
    fileprivate var compactDepth = [CalendarLayoutInfo](repeating: CalendarLayoutInfo(), count: 3)
    fileprivate var regularDepth = [CalendarLayoutInfo](repeating: CalendarLayoutInfo(), count: 3)
    fileprivate var isChangeBound : Bool = false
    fileprivate var previousLayoutRect : CGRect = CGRect.zero
    fileprivate var previousLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    var focusIndexPath:IndexPath?
    
    var frame : CGRect?

    var hedaerHeight : CGFloat?
    
    var currentDepth = 1 {
        didSet {
            
            if self.currentDepth > 0 {
                self.sectionHeadersPinToVisibleBounds = true
                self.headerReferenceSize = CGSize(width: 50, height: 50)
            } else {
                self.sectionHeadersPinToVisibleBounds = false
                self.headerReferenceSize = CGSize.zero
            }
            
            self.invalidateLayout()
        }
    }
    
    var traitCollection : UITraitCollection? {
        didSet {
            
            if self.traitCollection != oldValue {
                self.invalidateLayout()
            }
        }
    }
    
    override init() {
        super.init()
        
        self.initDepth()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.initDepth()
    }
    
    func initDepth() {
        self.compactDepth[0] = CalendarLayoutInfo(horizontal: 1, vertical: 1)
        self.compactDepth[1] = CalendarLayoutInfo(horizontal: 3, vertical: 4)
        self.compactDepth[2] = CalendarLayoutInfo(horizontal: 5, vertical: 7)
        
        self.regularDepth[0] = CalendarLayoutInfo(horizontal: 1, vertical: 1)
        self.regularDepth[1] = CalendarLayoutInfo(horizontal: 6, vertical: 2)
        self.regularDepth[2] = CalendarLayoutInfo(horizontal: 12, vertical: 4)
    }
    
    override func prepare() {

        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        
        self.itemSize = self.sizeFor(depth: self.currentDepth)
        
        super.prepare()
    }
    
    override func finalizeLayoutTransition() {
        super.finalizeLayoutTransition()
        self.focusIndexPath = nil
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        
        guard let indexPath = self.focusIndexPath, let collectionView = self.collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        guard let attribute = self.layoutAttributesForItem(at: indexPath) else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        var top = collectionView.contentInset.top + collectionView.adjustedContentInset.top
        
        top += self.headerReferenceSize.height
        
        return CGPoint(x:0, y:attribute.frame.minY - top)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        if let bounds = self.collectionView?.bounds {
            
            if newBounds != bounds {
                return true
            }
        }
        
        return false
    }
    
    func sizeFor(depth:Int) -> CGSize {
        
        guard let collectionView = self.collectionView else {
            return CGSize.zero
        }
        
        var inset = UIEdgeInsets.zero
        inset.left = collectionView.safeAreaInsets.left
        inset.right = collectionView.safeAreaInsets.right
        self.sectionInset = inset
        
        let adjustHeightSpacing = (collectionView.adjustedContentInset.top +  collectionView.adjustedContentInset.bottom) + self.headerReferenceSize.height
        let adjustWidthSpacing = collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
        
        var info = self.compactDepth[depth]
        
        if let traitCollection = self.traitCollection, traitCollection.horizontalSizeClass == .regular {
            info = self.regularDepth[depth]
        }
        
        var frame = collectionView.frame
        
        if let inputFrame = self.frame {
           frame = inputFrame
        }

        var width = (floor((frame.width - adjustWidthSpacing) / info.horizontal) * 100) / 100
        if width < 1 {
            width = 1
        }
        
        var height = (round((frame.height - adjustHeightSpacing)  / info.vertical) * 100) / 100
        
        if height < 1 {
            height = 1
        }
        let size = CGSize(width: width, height: height)
        
        return size
    }
}
