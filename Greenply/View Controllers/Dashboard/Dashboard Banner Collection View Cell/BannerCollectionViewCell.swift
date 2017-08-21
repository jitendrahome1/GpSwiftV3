//
//  CustomBannerCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var imageBanner: UIImageView!

	override var datasource: AnyObject? {
		didSet {
			imageBanner.backgroundColor = UIColor.brown
		}
	}

}
