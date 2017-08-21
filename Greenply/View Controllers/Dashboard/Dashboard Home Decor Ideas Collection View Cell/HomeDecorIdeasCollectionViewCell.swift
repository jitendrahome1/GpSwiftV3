//
//  CustomHomeDecorIdeasCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class HomeDecorIdeasCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var imageHomeDecor: UIImageView!
    @IBOutlet weak var labelHomeDecor: UILabel!

	override var datasource: AnyObject? {
		didSet {
            
            let ideaListObj = datasource as! IdeaListing
            imageHomeDecor.setImage(withURL: URL(string: ideaListObj.ideaImageThumb!)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .crossDissolve(0.4))
			imageHomeDecor.backgroundColor = UIColor.green
            imageHomeDecor.layer.cornerRadius = IS_IPAD() ? 7.0 : 4.0
            imageHomeDecor.layer.masksToBounds = true
            labelHomeDecor.text = ideaListObj.ideaName
		}
	}

}
