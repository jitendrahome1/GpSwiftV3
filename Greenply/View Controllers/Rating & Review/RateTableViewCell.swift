//
//  RateTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 01/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class RateTableViewCell: BaseTableViewCell {

	@IBOutlet weak var viewRate: FloatRatingView!
	@IBOutlet weak var labelDesc: UILabel!
	@IBOutlet weak var labelDate: UILabel!
	@IBOutlet weak var labelName: UILabel!
	@IBOutlet weak var labelExperience: UILabel!
    @IBOutlet weak var labelProfesion: UILabel!
	@IBOutlet weak var viewBGProfile: UIView!
	@IBOutlet weak var labelCommentBy: UILabel!
	@IBOutlet weak var buttonRate: UIButton!
	@IBOutlet weak var buttonCall: UIButton!
	@IBOutlet weak var buttonFollow: UIButton!
	@IBOutlet weak var imgProfile: UIImageView!
	@IBOutlet weak var labelPlace: UILabel!
	@IBOutlet weak var labelDistance: UILabel!
    @IBOutlet weak var labelService: UILabel!
    var distanceValue: Double?
    var objInfluncerDetails: Influencer!
    @IBOutlet weak var labelRateTitle: UILabel!
    var expMutableString: NSMutableAttributedString!
    var desigMutableString: NSMutableAttributedString!

	override var datasource: AnyObject? {
		didSet {
            let objRatings = self.datasource as! Ratings
			//if labelDesc != nil && labelDate != nil && labelCommentBy != nil && labelExperience != nil {
			
				labelDesc.text = objRatings.comment
				let date = Date.dateFromTimeInterval(Double(objRatings.createdAt!)).getFormattedStringWithFormat()
				labelDate.text = date
				labelCommentBy.text = objRatings.name!
                labelRateTitle.text = objRatings.title!
				viewRate.rating = Float(objRatings.rating!)
                labelService.text = objRatings.serviceTaken!
				viewRate.editable = false
                
			//}
		}
	}

	var dataSource: JSON? {
		didSet {

			if imgProfile != nil {
				debugPrint(self.dataSource)
                imgProfile.layoutIfNeeded()
				imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
				imgProfile.contentMode = UIViewContentMode.scaleAspectFill;
				imgProfile.layer.masksToBounds = true

				viewBGProfile.layer.borderWidth = 0.9;
				viewBGProfile.layer.borderColor = UIColorRGB(208.0, g: 225.0, b: 206.0)?.cgColor
                
				if self.dataSource != nil {
					self.labelPlace.text = objInfluncerDetails.influencerCity
                    if let _ = (self.objInfluncerDetails.influencerDistance){
                        if Double(self.objInfluncerDetails.influencerDistance!) > 999.00 {
                            self.labelDistance.text = "999+ KM"
                          
                        } else {
                            self.labelDistance.text = String(self.objInfluncerDetails.influencerDistance!) + "KM"
                        }
                    }
                    else {
                        if let _ = self.dataSource!["latitude"].string{
                            
                            Helper.sharedClient.distanceBetweenTwoLocations((String(describing: self.dataSource!["latitude"])).toDouble(), sourceLongitude: (String(describing: self.dataSource!["latitude"])).toDouble()) { (result) in
                                if result > 999.00 {
                                    self.labelDistance.text = "999+ KM"
                                } else {
                                    self.labelDistance.text = String(result) + "KM"
                                }
                                
                            }
                            
                        }
 
                    }
                    
                    self.buttonRate.setTitle("\(self.objInfluncerDetails.influencerLikeCount!)", for: UIControlState())
                    
                    if self.objInfluncerDetails.isFollowStatus == true {
                        self.buttonFollow.setTitle("Unfollow", for: UIControlState())
                    } else {
                       self.buttonFollow.setTitle("Follow", for: UIControlState())
                    }
                    
//                    Helper.sharedClient.distanceBetweenTwoLocations((String(self.dataSource!["latitude"])).toDouble(), sourceLongitude: (String(self.dataSource!["longitude"])).toDouble()) { (result) in
//                        self.labelDistance.text = String(result) + "KM"
//                    }

                    if let imageURl  =  self.dataSource!["display_profile"].string
                    {
                    self.imgProfile.setImage(withURL: URL(string: imageURl)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))
                    }
					
                    self.labelName.text = self.dataSource!["name"].stringValue
             
                    let strdesignation: String = objInfluncerDetails.influencerType!
                    self.desigMutableString = NSMutableAttributedString(string: "Profession: \(objInfluncerDetails.influencerType!)", attributes: [NSFontAttributeName:UIFont(name: "Roboto", size: IS_IPAD() ? 18.0 : 12.0)!])
                    self.desigMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColorRGB(160, g: 189, b: 65)!, range: NSMakeRange(12, strdesignation.characters.count))
                    self.labelProfesion.attributedText = self.desigMutableString
    
                    self.expMutableString = NSMutableAttributedString(string: "Experience: \(objInfluncerDetails.influencerTotalExperiences!)" + " yrs", attributes: [NSFontAttributeName:UIFont(name: "Roboto", size: IS_IPAD() ? 18.0 : 13.0)!])
                    self.expMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColorRGB(160, g: 189, b: 65)!, range: NSMakeRange(12, self.dataSource!["experience"].stringValue.characters.count+1))
                    self.labelExperience.attributedText = self.expMutableString
				}
			}
		}
	}
}

