//
//  WriteReviewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 01/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class WriteReviewController: BaseTableViewController, FloatRatingViewDelegate {

	@IBOutlet weak var buttonServiceTaken: UIButton!
	@IBOutlet weak var buttonServiceNotTaken: UIButton!
	@IBOutlet weak var viewRating: FloatRatingView!
	let checkedImage = UIImage(named: "WriteReviewRadioBtnSelect")
	let unCheckedImage = UIImage(named: "WriteReviewRadioBtnDeselect")
	@IBOutlet weak var viewBGProfile: UIView!
	@IBOutlet weak var labelName: UILabel!
	@IBOutlet weak var labelExperience: UILabel!
	@IBOutlet weak var labelProfession: UILabel!
	@IBOutlet weak var labelInfluencerType: UILabel!
	@IBOutlet weak var imageProfile: UIImageView!
	@IBOutlet weak var viewRate: UIView!
	var objInfluencerList: Influencer!
	@IBOutlet weak var textRateTitle: UITextField!
	@IBOutlet weak var textWriteReview: JAPlaceholderTextView!
	@IBOutlet weak var labelReviewDesc: UILabel!

	@IBOutlet weak var buttonFlowUnFlow: UIButton!
	@IBOutlet weak var labelDistance: UILabel!

	@IBOutlet weak var labelCity: UILabel!
	var rateValue: Float!
	var expMutableString: NSMutableAttributedString!
	var desigMutableString: NSMutableAttributedString!
	var serviceTaken: Int!
	var influncerID: Int?

	@IBOutlet weak var buttonLikeCount: UIButton!
    override func viewDidLoad() {
		super.viewDidLoad()
        self.tableView.delegate = self
		viewRating.delegate = self
		self.getInflunceDetails()
		self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
		// self.backgroundImageView.image = UIImage(named: "")
		self.backgroundImageView.image = UIImage(named: "BackgroundImage")

		viewBGProfile.layer.borderWidth = 0.9;
		viewBGProfile.layer.borderColor = UIColorRGB(208.0, g: 225.0, b: 206.0)?.cgColor

        
        
        if let influncerType = self.objInfluencerList.influencerType{
        	desigMutableString = NSMutableAttributedString(string: "Profession: \(influncerType)", attributes: [NSFontAttributeName: UIFont(name: "Roboto", size: IS_IPAD() ? 18.0 : 13.0)!])
          desigMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColorRGB(160, g: 189, b: 65)!, range: NSMakeRange(12, influncerType.characters.count))
        }
        
		
		labelProfession.attributedText = desigMutableString

		expMutableString = NSMutableAttributedString(string: "Experience: \(objInfluencerList.influencerTotalExperiences!)", attributes: [NSFontAttributeName: UIFont(name: "Roboto", size: IS_IPAD() ? 18.0 : 13.0)!])
		//expMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColorRGB(160, g: 189, b: 65)!, range: NSMakeRange(12, objInfluencerList.influencerTotalExperiences!.characters.count+4))
		labelExperience.attributedText = expMutableString
        buttonServiceTaken.setImage(checkedImage, for: UIControlState())
        serviceTaken = 0

	}

	func getInflunceDetails() {

		if let _ = self.objInfluencerList {
            self.labelName.text = self.objInfluencerList.influencerUserName!
			influncerID = self.objInfluencerList.influencerID
			self.buttonLikeCount.setTitle("\(self.objInfluencerList.influencerLikeCount!)", for: UIControlState())
			if self.objInfluencerList.isFollowStatus == true {

				self.buttonFlowUnFlow.setTitle("Unfollow", for: UIControlState())
			} else {
				self.buttonFlowUnFlow.setTitle("Follow", for: UIControlState())
			}
			labelCity.text = self.objInfluencerList.influencerCity!
            
            
            if let _ = (self.objInfluencerList.influencerDistance){
                if Double(self.objInfluencerList.influencerDistance!) > 999.00 {
                    self.labelDistance.text = "999+ KM"
                    
                } else {
                    self.labelDistance.text = String(self.objInfluencerList.influencerDistance!) + "KM"
                }
            }else{
               self.labelDistance.text = "0.0 KM"
            }
            
//            if let _ = (self.objInfluencerList){
//                if Double(self.objInfluencerList.influencerDistance!) > 999.00 {
//                    self.labelDistance.text = "999+ KM"
//                    
//                } else {
//                    self.labelDistance.text = String(self.objInfluencerList.influencerDistance!) + "KM"
//                }
//            }
            
            

            if let profilePic = self.objInfluencerList.displayProfileImg {
                self.imageProfile.setImage(withURL: URL(string: profilePic)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))
            } else {
                self.imageProfile.image = UIImage(named: "DefultProfileImage")
            }
		}
        
	}
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		imageProfile.layoutIfNeeded()
		imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
		imageProfile.contentMode = UIViewContentMode.scaleAspectFill
		imageProfile.layer.masksToBounds = true
	}

	override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false)
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = "Rate & Review"
		
        
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func actionServiceTaken(_ sender: AnyObject) {
		self.unCheckAll()
		buttonServiceTaken.setImage(checkedImage, for: UIControlState())
		serviceTaken = 0
	}

	@IBAction func actionServiceNotTaken(_ sender: AnyObject) {
		self.unCheckAll()
		buttonServiceNotTaken.setImage(checkedImage, for: UIControlState())
		serviceTaken = 1
	}

	func unCheckAll() {
		buttonServiceTaken.setImage(unCheckedImage, for: UIControlState())
		buttonServiceNotTaken.setImage(unCheckedImage, for: UIControlState())
	}
	// MARK:- Action

	@IBAction func actionRateSubmit(_ sender: AnyObject) {
		debugPrint("RateVlue==>\(rateValue)")
		// call API
		self.view.endEditing(true)
		if let pRateValue = rateValue {
            
            if textRateTitle.text == ""{
            Toast.show(withMessage: SELECT_COMMENT_TITLE)
            }
            
			else if textWriteReview.text == "" {
				Toast.show(withMessage: SELECT_COMMENT)
			} else {
				rateValue = pRateValue
				self.updateRatingView()
			}
		}
		else {
			Toast.show(withMessage: SELECT_RATE)

		}

	}

}



extension WriteReviewController {

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.row {
		case 0:
			return IS_IPAD() ? 150 : 130
		case 1:
			return IS_IPAD() ? 120 : 98
		case 2, 3:
			return IS_IPAD() ? 60 : 55
		case 4:
			return IS_IPAD() ? 265 : 215
		case 5:
			return IS_IPAD() ? 140 : 100
		default:
			return 0
		}
	}
}

// FloatRatingViewDelegate Delegate
extension WriteReviewController {
	func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float)
	{
		rateValue = rating
	}
	func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Float)
	{
		rateValue = rating
	}
}



//MARK: Api Calling
extension WriteReviewController {
	func updateRatingView() {
		// MARK:- For This Time we are passed hard coded value in userID, letter we ill change. when we get userID.
		APIHandler.handler.writeReview(influncerID!, rated_by: Globals.sharedClient.userID!, rating: rateValue, description: textWriteReview.text, title: self.textRateTitle.text, service_taken: serviceTaken, success: { (response) in
			debugPrint("Response Reting:==>\(response)")
			self.navigationController?.popViewController(animated: true)
		}) { (error) in
		}
	}
}

