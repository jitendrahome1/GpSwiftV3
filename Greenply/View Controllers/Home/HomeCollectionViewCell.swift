//
//  HomeCollectionViewCell.swift
//  Greenply
//
//  Created by Rupam Mitra on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var imageHome: UIImageView!
	@IBOutlet weak var labelTitle: UILabel!

	override var datasource: AnyObject? {
		didSet {
			labelTitle.text = datasource!["name"] as? String
			imageHome.backgroundColor = UIColor.gray
		}
	}
}
