//
//  CustomAboutUsCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class AboutUsCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var imageAboutUs: UIImageView!
    @IBOutlet weak var labelAboutUs: UILabel!

	override var datasource: AnyObject? {
		didSet {
            labelAboutUs.text = datasource!["name"] as? String
            imageAboutUs.image = UIImage(named: (datasource!["image"] as? String)!)
		}
	}
}
