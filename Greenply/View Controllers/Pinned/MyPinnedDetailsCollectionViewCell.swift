//
//  MyPinnedDetailsCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 13/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MyPinnedDetailsCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var imageMyPinnedDetails: UIImageView!
	@IBOutlet weak var imageProfile: UIImageView!
	@IBOutlet weak var labelStyle: UILabel!
	@IBOutlet weak var labelRoom: UILabel!
	@IBOutlet weak var buttonLikes: UIButton!
	@IBOutlet weak var buttonViews: UIButton!

	override var datasource: AnyObject? {
		didSet {

			let ideaListObj = datasource as! IdeaListing
			buttonLikes.setTitle("\(ideaListObj.likeCount! as Int)", for: UIControlState())
			buttonViews.setTitle("\(ideaListObj.viewCount! as Int)", for: UIControlState())
			labelStyle.text = ideaListObj.styleValue!
			labelRoom.text = "Room: " + ideaListObj.roomValue!
			imageMyPinnedDetails.setImage(withURL: URL(string: ideaListObj.ideaImageThumb!)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .crossDissolve(0.4))
            if let _ = ideaListObj.displayProfileImg{
              imageProfile.setImage(withURL: URL(string: ideaListObj.displayProfileImg!)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))
            }else{
             imageProfile.image = UIImage(named: "DefultProfileImage")
            }
           
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		imageProfile.layoutIfNeeded()
		imageProfile.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
		imageProfile.layer.borderColor = UIColor.white.cgColor
		imageProfile.layer.cornerRadius = imageProfile.frame.size.height / 2
		imageProfile.layer.masksToBounds = true
	}
}
