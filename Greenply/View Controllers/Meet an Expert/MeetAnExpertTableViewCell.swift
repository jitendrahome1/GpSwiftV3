//
//  MeetAnExpertTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 29/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MeetAnExpertTableViewCell: BaseTableViewCell {

	@IBOutlet weak var viewMeetAnExpert: UIView!
	@IBOutlet weak var imageMeetAnExpert: UIImageView!
	@IBOutlet weak var labelName: UILabel!
	@IBOutlet weak var labelExperience: UILabel!
	@IBOutlet weak var labelDesignation: UILabel!
	@IBOutlet weak var buttonLike: UIButton!
	@IBOutlet weak var buttonCall: UIButton!
	@IBOutlet weak var buttonFollow: UIButton!
	@IBOutlet weak var labelDistance: UILabel!
	@IBOutlet weak var labelPlace: UILabel!
	var strExperience: String = ""
	var expMutableString: NSMutableAttributedString!
	var desigMutableString: NSMutableAttributedString!

	override var datasource: AnyObject? {
		didSet {
			let objInfluencer = datasource as! Influencer

			labelName.text = objInfluencer.influencerUserName
			buttonLike.setTitle("\(objInfluencer.influencerLikeCount! as Int)", for: UIControlState())

            if objInfluencer.isFollowStatus == true {
                self.buttonFollow.setTitle("Unfollow", for: UIControlState())
            } else {
                self.buttonFollow.setTitle("Follow", for: UIControlState())
            }
            
            
			imageMeetAnExpert.setImage(withURL: URL(string: objInfluencer.displayProfileImg!)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))

			if let influncerType = objInfluencer.influencerType {
				desigMutableString = NSMutableAttributedString(string: "Profession: \(influncerType)", attributes: [NSFontAttributeName: UIFont(name: "Roboto", size: IS_IPAD() ? 18.0 : 13.0)!])
				desigMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColorRGB(160, g: 189, b: 65)!, range: NSMakeRange(12, influncerType.characters.count))
			}

			labelDesignation.attributedText = desigMutableString
			strExperience = objInfluencer.influencerTotalExperiences!

			expMutableString = NSMutableAttributedString(string: "Experience: \(strExperience ) yrs", attributes: [NSFontAttributeName: UIFont(name: "Roboto", size: IS_IPAD() ? 18.0 : 13.0)!])
			expMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColorRGB(160, g: 189, b: 65)!, range: NSMakeRange(12, strExperience.characters.count + 4))
			labelExperience.attributedText = expMutableString
			// Distablce

			if let _ = objInfluencer.influencerDistance {
				if Double(objInfluencer.influencerDistance!) > 999.00 {
					self.labelDistance.text = "999+ KM"
				} else {
					self.labelDistance.text = String(objInfluencer.influencerDistance!) + "KM"
				}
			}
			else {
				if let _ = objInfluencer.latitude {

					Helper.sharedClient.distanceBetweenTwoLocations((String(objInfluencer.latitude!)).toDouble(), sourceLongitude: (String(objInfluencer.longitude!)).toDouble()) { (result) in
						if result > 999.00 {
							self.labelDistance.text = "999+ KM"
						} else {
							self.labelDistance.text = String(result) + "KM"
						}
					}
				}
			}


            if let _ = objInfluencer.influencerCity  {
            labelPlace.text = objInfluencer.influencerCity
            }else{
			labelPlace.text = "N/A"
            }

		}
	}

	override func layoutSubviews() {

		imageMeetAnExpert.layer.cornerRadius = IS_IPAD() ? imageMeetAnExpert.frame.size.width / 2: 70.0 / 2
		imageMeetAnExpert.layer.masksToBounds = true
		viewMeetAnExpert.layer.cornerRadius = IS_IPAD() ? 15.0 : 8.0
		viewMeetAnExpert.layer.masksToBounds = true

	}
}

