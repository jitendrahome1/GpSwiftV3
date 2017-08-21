//
//  DashboardHomeDecorIdeasCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class DashboardHomeDecorIdeasCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var collectionViewHomeDecorIdeas: UICollectionView?
	@IBOutlet weak var lblHomeDecorIdeas: UILabel!
	@IBOutlet weak var btnHomeDecorViewAll: UIButton!
    @IBOutlet weak var viewHomeDecor: UIView!
    
    @IBOutlet weak var labelNORecord: UILabel!
    var didOpen: ((_ open: Bool)->())!
	 var dataSource: [AnyObject]? {
        willSet {
            setupCollectionView()
        }
        //
		didSet {
            
            viewHomeDecor.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
            viewHomeDecor.layer.cornerRadius = IS_IPAD() ? 15.0 : 8.0
            viewHomeDecor.layer.borderColor = UIColor(red: 224.0/255.0, green: 226.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor
            viewHomeDecor.layer.masksToBounds = true
            if dataSource?.count > 0{
                collectionViewHomeDecorIdeas?.isHidden = false
                self.labelNORecord.isHidden = true
            }else{
                collectionViewHomeDecorIdeas?.isHidden = true
                self.labelNORecord.isHidden = false
            }
            collectionViewHomeDecorIdeas?.reloadData()
		}
	}
}

extension DashboardHomeDecorIdeasCollectionViewCell: UIScrollViewDelegate {
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        collectionViewHomeDecorIdeas!.collectionViewLayout = layout
    }
    
    
	// MARK: UICollectionViewDataSource methods
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataSource?.count)!
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
   
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeDecorIdeasCollectionViewCell.self), for: indexPath) as! HomeDecorIdeasCollectionViewCell
       //cell.datasource = "Test"
		cell.datasource = dataSource![indexPath.row]
        return cell
	}
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
//        let ideaListVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(IdeaListingController)) as! IdeaListingController
//        NavigationHelper.helper.contentNavController?.pushViewController(ideaListVC, animated: true)
        
        // change letter
//        let ideaListVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(IdeaListingController)) as! IdeaListingController
//        
        
        let cell = collectionView.cellForItem(at: indexPath) as! HomeDecorIdeasCollectionViewCell
        let IdeaDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: IdeasDetailsController.self)) as! IdeasDetailsController
        let objIdeaList = cell.datasource
        IdeaDetailsVC.ideaDetailsObj = objIdeaList as! IdeaListing
        NavigationHelper.helper.contentNavController?.pushViewController(IdeaDetailsVC, animated: true)
    
    }
    
	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		//return CGSizeMake(CGRectGetHeight(self.frame) - 60, CGRectGetHeight(self.frame) - 60)
        return CGSize(width: IS_IPAD() ? 300 : self.frame.height - 70, height: IS_IPAD() ? 220 : self.frame.height - 80)
	}
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if didOpen != nil {
            didOpen(false)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if didOpen != nil {
            didOpen(true)
            
        }
    }
    
    
}
