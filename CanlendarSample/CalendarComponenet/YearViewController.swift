//
//  UIYearViewController.swift
//  CanlendarSample
//
//  Created by jeongkyu kim on 27/03/2019.
//  Copyright © 2019 jeongkyu kim. All rights reserved.
//

import UIKit

private let smallReuseIdentifier = "MonthSmallCell"

class YearViewController: CalendarViewController {
    
    let pushTransition = PushCollectionTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layout.currentDepth = 1
        
        let header = UINib(nibName: "CalendarYearHeader", bundle: nil)
        
        self.collectionView.register(header, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "YearHeader")
        self.collectionView.collectionViewLayout = self.layout
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.scrollCurrentYear()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if let month = segue.destination as? MonthViewController, let indexPath = sender as? IndexPath {
            month.initIndexPath = indexPath
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: smallReuseIdentifier, for: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? CalendarMonthSmallCell, let info = self.dataHandler.monthInfoOf(indexPath: indexPath) as? MonthInfo {
            cell.setMonth(info: info)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "YearHeader", for: indexPath)
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        if let header = view as? CalendarYearHeader {
            header.year.text = self.dataHandler.titleOfSection(section: indexPath.section)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.navigationController?.delegate = self
        self.performSegue(withIdentifier: "OpenMonth", sender: indexPath)
    }
}

extension YearViewController : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if (fromVC == self) {
            return self.pushTransition
        }
        
        return nil
    }
}
