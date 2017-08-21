//
//  DashboardMeetTheExpertCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class DashboardMeetTheExpertCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var collectionViewMeetTheExpert: UICollectionView?
	@IBOutlet weak var lblMeetTheExpert: UILabel!
	@IBOutlet weak var viewMeethTheExpert: UIView!

	var dataSource: [AnyObject]? {
		didSet {
			viewMeethTheExpert.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
			viewMeethTheExpert.layer.cornerRadius = IS_IPAD() ? 15.0 : 8.0
			viewMeethTheExpert.layer.borderColor = UIColor(red: 224.0 / 255.0, green: 226.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0).cgColor
			viewMeethTheExpert.layer.masksToBounds = true
			setupCollectionView()
		}
	}
}

extension DashboardMeetTheExpertCollectionViewCell {

	func setupCollectionView() {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: IS_IPAD() ? 20 : 0, bottom: 0, right: IS_IPAD() ? 20 : 0)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = IS_IPAD() ? 70 : 0 // iPhone 15
		layout.scrollDirection = .horizontal
		collectionViewMeetTheExpert!.collectionViewLayout = layout
	}

	// MARK: UICollectionViewDataSource methods
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MeetTheExpertCollectionViewCell.self), for: indexPath) as! MeetTheExpertCollectionViewCell
		cell.datasource = self.dataSource![indexPath.row]
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {

		let meetAnExpertVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: MeetAnExpertViewController.self)) as! MeetAnExpertViewController
        switch indexPath.item {
        case 0:
            meetAnExpertVC.solutionType = "carpenters"
        case 1:
            meetAnExpertVC.solutionType = "interior-decorators"
        case 2:
            meetAnExpertVC.solutionType = "architect"
        default:
            debugPrint("No Code")
        }
		NavigationHelper.helper.contentNavController!.pushViewController(meetAnExpertVC, animated: true)
	}

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		return CGSize(width: IS_IPAD() ? 190 : (self.frame.width - 16) / 3, height: IS_IPAD() ? 210 : self.frame.height - 65) // 100,115
        
        
        
	}
}
