//
//  DashboardAboutUsCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class DashboardAboutUsCollectionViewCell: BaseCollectionViewCell {
	var getIndexValue: ((_ indexValue: Int) -> ())?
	@IBOutlet weak var collectionViewAboutUs: UICollectionView?
	@IBOutlet weak var viewAboutUs: UIView!

	var dataSource: [AnyObject]? {
		didSet {

			viewAboutUs.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
			viewAboutUs.layer.cornerRadius = IS_IPAD() ? 15.0 : 8.0
			viewAboutUs.layer.borderColor = UIColor(red: 224.0 / 255.0, green: 226.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0).cgColor
			viewAboutUs.layer.masksToBounds = true
			setupCollectionView()
		}
	}
}

extension DashboardAboutUsCollectionViewCell {

	func setupCollectionView() {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: IS_IPAD() ? 20 : 0, bottom: 0, right: IS_IPAD() ? 20 : 0)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = IS_IPAD() ? 70 : 0
		layout.scrollDirection = .horizontal
		collectionViewAboutUs!.collectionViewLayout = layout
	}

	// MARK: UICollectionViewDataSource methods
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AboutUsCollectionViewCell.self), for: indexPath) as! AboutUsCollectionViewCell
		cell.datasource = self.dataSource![indexPath.row]
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
		

		if indexPath.row == 0 {

			let aboutUsVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: AboutUsViewController.self)) as! AboutUsViewController
			// NavigationHelper.helper.currentViewController = aboutUsVC
			// NavigationHelper.helper.navigationController = NavigationHelper.helper.contentNavController as UINavigationController

			NavigationHelper.helper.contentNavController!.pushViewController(aboutUsVC, animated: true)
		}
		else if indexPath.row == 1 {

			let howItsWorktUsVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: HowItsWorkViewController.self)) as! HowItsWorkViewController
			// NavigationHelper.helper.currentViewController = aboutUsVC

			// NavigationHelper.helper.navigationController = NavigationHelper.helper.contentNavController as UINavigationController
			NavigationHelper.helper.contentNavController!.pushViewController(howItsWorktUsVC, animated: true)

		}
		else if indexPath.row == 2 {
            if getIndexValue != nil {
                getIndexValue!(2)
            }
//
//			let uploadIdeasVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(UploadIdeasTableViewController)) as! UploadIdeasTableViewController
//			NavigationHelper.helper.contentNavController!.pushViewController(uploadIdeasVC, animated: true)

		}

	}

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		// return CGSizeMake(CGRectGetHeight(self.frame) - 20, CGRectGetHeight(self.frame) - 20)
		return CGSize(width: IS_IPAD() ? 190 : (self.frame.width - 16) / 3, height: IS_IPAD() ? 210 : self.frame.height - 45)

		// return CGSizeMake(IS_IPAD() ? 190 : CGRectGetHeight(self.frame) - 30 , IS_IPAD() ? 210 : CGRectGetHeight(self.frame) - 30)
	}

}
