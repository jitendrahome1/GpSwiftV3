//
//  DashboardBannerCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class DashboardBannerCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var collectionViewBanner: UICollectionView?
	@IBOutlet weak var imageView: UIImageView?

	override var datasource: AnyObject? {
		didSet {
			if datasource != nil {
				imageView?.setImage(withURL: URL(string: (datasource as? String)!)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .crossDissolve(0.4))
			}
		}
	}
}

extension DashboardBannerCollectionViewCell {

	// MARK: UICollectionViewDataSource methods
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BannerCollectionViewCell.self), for: indexPath) as! BannerCollectionViewCell
		return cell
	}

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		return CGSize(width: SCREEN_WIDTH, height: self.frame.height)
	}
}
