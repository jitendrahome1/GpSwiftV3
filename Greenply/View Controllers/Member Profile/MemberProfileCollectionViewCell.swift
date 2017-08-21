//
//  MemberProfileCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 30/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MemberProfileCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var imageCollectionIdeas: UIImageView!
    @IBOutlet weak var labelCollectionIdeas: UILabel!

	override var datasource: AnyObject? {
		didSet {
            imageCollectionIdeas.layer.cornerRadius = IS_IPAD() ? 15.0 : 10.0
            imageCollectionIdeas.layer.masksToBounds = true
            labelCollectionIdeas.text = "Out Office"
		}
	}
}
