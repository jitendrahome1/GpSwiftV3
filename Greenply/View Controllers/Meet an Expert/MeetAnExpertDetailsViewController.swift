//
//  MeetAnExpertDetailsViewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 29/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MeetAnExpertDetailsViewController: BaseTableViewController {

	@IBOutlet weak var viewRating: FloatRatingView!
	@IBOutlet weak var labelName: UILabel!
	@IBOutlet weak var labelDistance: UILabel!
	@IBOutlet weak var labelPlace: UILabel!
	@IBOutlet weak var imageProfile: UIImageView!
	@IBOutlet weak var imageBackgroundProfile: UIImageView!
	@IBOutlet weak var buttonRateReview: UIButton!
	@IBOutlet weak var buttonLikes: UIButton!
	@IBOutlet weak var buttonCall: UIButton!
	@IBOutlet weak var buttonFollow: UIButton!
	@IBOutlet weak var buttonFollowing: UIButton!
	@IBOutlet weak var buttonFollowers: UIButton!
	@IBOutlet weak var buttonView: UIButton!
	@IBOutlet weak var labelProjects: UILabel!
	@IBOutlet weak var buttonViewAllProj: UIButton!
	@IBOutlet weak var collectionViewProj: UICollectionView!
	@IBOutlet weak var labelIdeas: UILabel!
	@IBOutlet weak var buttonViewAllIdeas: UIButton!
	@IBOutlet weak var collectionViewIdeas: UICollectionView!
	@IBOutlet weak var labelAboutName: UILabel!
	@IBOutlet weak var labelAboutNameDesc: UILabel!
	@IBOutlet weak var labelEducation: UILabel!
	@IBOutlet weak var labelEducationDesc: UILabel!
	@IBOutlet weak var labelWorkExperience: UILabel!
    var strIverExtationNumber: String?
	var objExprience: Experience!
	var objEducation: Education!
	@IBOutlet weak var buttonEduMore: UIButton!
	@IBOutlet weak var labelEduTitle: UILabel!
	@IBOutlet weak var buttonExpMore: UIButton!
	@IBOutlet weak var labelExpTitle: UILabel!
    @IBOutlet weak var labelExpToDate: UILabel!
    @IBOutlet weak var labelEduDesc: UILabel!
	@IBOutlet weak var labelEduFormDate: UILabel!
	@IBOutlet weak var lableEduToDate: UILabel!
    @IBOutlet weak var labelExpFromDate: UILabel!
	@IBOutlet weak var labelServiceArea: UILabel!
	@IBOutlet weak var labelSeviceDesc: UILabel!
	@IBOutlet weak var viewRate: FloatRatingView!
	@IBOutlet weak var labelRatingonDate: UILabel!
	@IBOutlet weak var labelGivenCommentsName: UILabel!
	@IBOutlet weak var labelRateComments: UILabel!
    @IBOutlet weak var labelRateTitle: UILabel!
    @IBOutlet weak var labelFollowing: UILabel!
    @IBOutlet weak var labelFollowers: UILabel!
    
	var arrInfluncerIdeaList = [AnyObject]()
	var arrInfluncerProjectList = [AnyObject]()
	var objInfluencerDetails: Influencer!
	var buttonRating: UIButton!
    var arrRating = [AnyObject]()
    @IBOutlet weak var buttonReportAbus: UIButton!
	@IBOutlet weak var labelViewCount: UILabel!
	@IBOutlet weak var labelLikeCount: UILabel!
	@IBOutlet weak var btnLikeDisLike: UIButton!
	@IBOutlet var viewContents: [UIView]!
    var hightProjectCell: Float =  IS_IPAD() ? 120 : 100
    var hightIdeaCell: Float =  IS_IPAD() ? 120 : 100
    var hightEduCell: Float = IS_IPAD() ? 200 : 180
    var hightExpCell: Float = IS_IPAD() ? 160 : 140

    
	// .................
	var arrWorkExperience = [AnyObject]()
	var arrDistance = [AnyObject]()
	var arrJobCost = [AnyObject]()
	var arrRatings = [AnyObject]()
	// .................
    
    var pageno = 1
    var pageSize = 8
    var totalCount: Int!

	override func viewDidLoad() {
		super.viewDidLoad()
        self.buttonEduMore.setTitle("View All", for: UIControlState())
        self.buttonExpMore.setTitle("View All", for: UIControlState())
		NavigationHelper.helper.headerViewController!.lblNotification.text = ""
		self.eductionLableHideUnhide(true)
		self.experienceLableHideUnhide(true)
		self.buttonViewAllProj.isHidden = true
		self.buttonViewAllIdeas.isHidden = true
		self.tableView.backgroundView = nil

		for (_, view) in viewContents.enumerated() {
			view.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
			view.layer.borderColor = UIColorRGB(224.0, g: 226.0, b: 227.0)?.cgColor
			view.layer.cornerRadius = IS_IPAD() ? 15.0 : 5.0
			view.layer.masksToBounds = true
		}

		imageProfile.backgroundColor = UIColor.brown
		imageProfile.layer.borderWidth = IS_IPAD() ? 3.0 : 2.0
		imageProfile.layer.borderColor = UIColor(red: 163.0 / 255.0, green: 208.0 / 255.0, blue: 107.0 / 255.0, alpha: 1.0).cgColor
		imageProfile.layer.cornerRadius = IS_IPAD() ? imageProfile.frame.size.width / 2: 90 / 2
		imageProfile.layer.masksToBounds = true
		buttonFollow.layer.cornerRadius = buttonFollow.frame.height / 2 - 2

		self.tableView.estimatedRowHeight = 90.0
		self.tableView.rowHeight = UITableViewAutomaticDimension;

	}
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.changeReportAbusImage(self.objInfluencerDetails.abusedStatus!)
		// Code For Display Work Experience

        self.buttonExpMore.titleLabel?.textColor = .green
        self.buttonEduMore.titleLabel?.textColor = .green
        self.labelFollowers.text = "0"
        self.labelFollowing.text = "0"
        let arrExpValue = self.objInfluencerDetails.arrExperienceList

		if arrExpValue.count > 0 || arrExpValue.count > 1 {
			self.buttonExpMore.isHidden = false
			self.experienceLableHideUnhide(false)
            
			objExprience = self.objInfluencerDetails.arrExperienceList[0] as! Experience
			self.labelExpTitle.text = "Organisation: \(self.objExprience.organisation_name!)"
			if let _ = self.objExprience.startDate {
				self.labelExpToDate.text = "From date: \(Date.dateFromTimeInterval(self.objExprience.startDate!).getFormattedStringWithFormat()!)"
			} else {
				self.labelExpToDate.text = "From date: N/A"
			}
			if let _ = self.objExprience.endDate {
				self.labelExpFromDate.text = "To date: \(Date.dateFromTimeInterval(self.objExprience.endDate!).getFormattedStringWithFormat()!)"
			} else {
				self.labelExpFromDate.text = "To date: N/A"
			}

		} else {
          
                self.hightExpCell = IS_IPAD() ? 120 : 100
                self.tableView.reloadData()
            
			self.experienceLableHideUnhide(true)
			self.buttonExpMore.isHidden = true
			self.labelExpTitle.text = "Work experience is not available"
		}
		// End Work Experience

		// Code For Education
		let arrEducationValue = self.objInfluencerDetails.arrEducationList
        if arrEducationValue.count > 0 {
            if arrEducationValue.count > 1 {
            self.buttonEduMore.isHidden = false
            }else{
                self.buttonEduMore.isHidden = true
            }
			
			self.eductionLableHideUnhide(false)
			objEducation = self.objInfluencerDetails.arrEducationList[0] as! Education
			self.labelEduTitle.text = "Degree: \(self.objEducation.degreeName!)"
			self.labelEduDesc.text = "Stream: \(self.objEducation.stream!)"
			if let _ = self.objEducation.startDate {
				self.lableEduToDate.text = "From date: \(Date.dateFromTimeInterval(self.objEducation.startDate!).getFormattedStringWithFormat()!)"
			} else {
				self.lableEduToDate.text = "From date: N/A"
			}
			if let _ = self.objEducation.endDate {
				self.labelEduFormDate.text = "To date: \(Date.dateFromTimeInterval(self.objEducation.endDate!).getFormattedStringWithFormat()!)"
			} else {
				self.labelEduFormDate.text = "To date: N/A"
			}

		} else {
            self.hightEduCell = IS_IPAD() ? 120 : 100
            self.tableView.reloadData()
			self.eductionLableHideUnhide(true)
			self.buttonEduMore.isHidden = true
			self.labelEduTitle.text = "Education is not available"
		}

		// End Education

// self.getInfluncerDetails(forUserID: objInfluencerDetails.influencerID)
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_MEET_EXPERT
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false)
		NavigationHelper.helper.tabBarViewController!.hideTabBar()
		self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
		// get influencer Details
		self.getinfluencerDetails { (objinfluencer) in

			self.labelName.text = objinfluencer.influencerUserName
			self.labelAboutName.text = "About \(objinfluencer.influencerUserName!)"
			self.labelLikeCount.text = String(objinfluencer.influencerLikeCount!)
            if let _ = objinfluencer.influencerCity{
                self.labelPlace.text = objinfluencer.influencerCity
            }else{
			self.labelPlace.text =  "N/A"
            }
			self.labelViewCount.text = String(objinfluencer.influencerViewCount!)
			self.labelAboutNameDesc.text =  objinfluencer.aboutUs
            self.labelAboutNameDesc.text?.labelJustified(self.labelAboutNameDesc)
    
        self.labelSeviceDesc.text = objinfluencer.influencerserviceArea
            if self.labelSeviceDesc.text == ""{
            self.labelSeviceDesc.text = "Service area not available"
            }
            

			// self.labelEducationDesc.text = objinfluencer.influencerEducations
            if let _ = objinfluencer.influencerDistance{
                if Double(objinfluencer.influencerDistance!) > 999.00 {
                    self.labelDistance.text = "999+ KM"
                } else {
                    self.labelDistance.text = String(objinfluencer.influencerDistance!) + "KM"
                }
            }
            
            else{
                if let _ = objinfluencer.latitude {
                    
                    Helper.sharedClient.distanceBetweenTwoLocations((String(objinfluencer.latitude!)).toDouble(), sourceLongitude: (String(objinfluencer.longitude!)).toDouble()) { (result) in
                        if result > 999.00 {
                            self.labelDistance.text = "999+ KM"
                        } else {
                            self.labelDistance.text = String(result) + "KM"
                        }
                        
                    }
                    
                }
            }
            
            
//			Helper.sharedClient.distanceBetweenTwoLocations((String(objinfluencer.latitude!)).toDouble(), sourceLongitude: (String(objinfluencer.longitude!)).toDouble()) { (result) in
//				self.labelDistance.text = String(result) + "KM"
//			}

			self.changeLikeAndDislike(self.objInfluencerDetails.isLikedStatus!)
			self.checkFollowingORStartFollowingStatus()

			self.imageBackgroundProfile.setImage(withURL: URL(string: objinfluencer.coverProfileImg!)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))
			self.imageProfile.setImage(withURL: URL(string: objinfluencer.displayProfileImg!)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))

		}

		self.setRatingButton()

		viewRate.editable = false
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		buttonRating.removeFromSuperview()
	}

    @IBAction func actionCall(_ sender: UIButton) {
        let dict = ["value":self.strIverExtationNumber!]
        InfluencerCallPopUpViewController.showAddOrClearPopUp(NavigationHelper.helper.mainContainerViewController!, pDictValue: dict as [String : AnyObject]) {
            
        }
        
    
    }
    
    
	@IBAction func actionExpMore(_ sender: UIButton) {
		let moreDetails = mainStoryboard.instantiateViewController(withIdentifier: String(describing: MoreDetailsViewController.self)) as! MoreDetailsViewController

		moreDetails.strMoreType = "EXPERISTION"
		moreDetails.arrDataItems = self.objInfluencerDetails.arrExperienceList
		NavigationHelper.helper.contentNavController!.pushViewController(moreDetails, animated: true)
	}

	@IBAction func actionEduMore(_ sender: UIButton) {

		let moreDetails = mainStoryboard.instantiateViewController(withIdentifier: String(describing: MoreDetailsViewController.self)) as! MoreDetailsViewController
		moreDetails.strMoreType = "EDUCATION"
		moreDetails.arrDataItems = self.objInfluencerDetails.arrEducationList
		NavigationHelper.helper.contentNavController!.pushViewController(moreDetails, animated: true)

	}
	// MARK:-

	// MARK:- Action.
	@IBAction func followAction(_ sender: UIButton) {

		if buttonFollow.titleLabel?.text == TITLE_START_FOllOWING {
			Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
				if isLogin == true {

				}
			}
		}
		else {
			// cal To Api For un Folllwing
			self.setFollowAndUnFollowStaus()
		}

	}

	@IBAction func actionReportAbus(_ sender: UIButton) {

		Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
				if self.objInfluencerDetails.abusedStatus == true {
					self.buttonReportAbus.isUserInteractionEnabled = false
				} else {
					self.buttonReportAbus.isUserInteractionEnabled = true
					Helper.sharedClient.showAlertView(inViewControler: self, alertMessge: WANT_REPORT_ABUSE, indexValue: { (successIndex) in
						if successIndex == 1 {
							self.reportAbusWith(forReportID: self.objInfluencerDetails.influencerID!, abuseType: kReportAbusUser)
						}
					})

				}
			}
		}
	}
	@IBAction func actionLikeUnLike(_ sender: UIButton) {

		Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
				// call APi

				self.influncerLikeDislike(forUserID: Globals.sharedClient.userID, influencerID: self.objInfluencerDetails.influencerID!)
			}

		}

	}
	// MARK:- Action.
	@IBAction func clickProjects(_ sender: UIButton) {

		let portfolioListingVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: ProjectListingController.self)) as! ProjectListingController

		portfolioListingVC.buttonAddProjectStatus = .eHideButton
		portfolioListingVC.ePortfolioTitleStatus = .ePortfolioListingTitle
		portfolioListingVC.pUserID = self.objInfluencerDetails.influencerID!
		NavigationHelper.helper.contentNavController!.pushViewController(portfolioListingVC, animated: true)

	}

	@IBAction func clickIdeas(_ sender: UIButton) {
		let IdeaListingVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: IdeaListingController.self)) as! IdeaListingController
		// NavigationHelper.helper.currentViewController = IdeaListingVC
		// NavigationHelper.helper.navigationController = NavigationHelper.helper.contentNavController as UINavigationController
		NavigationHelper.helper.contentNavController!.pushViewController(IdeaListingVC, animated: true)

	}

	@IBAction func clickRateReview(_ sender: UIButton) {
		let rateandReviewVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: RatingAndReviewController.self)) as! RatingAndReviewController
		// rateandReviewVC.influncerID = objInfluencerDetails.influencerID!
		rateandReviewVC.objInfluencerItems = self.objInfluencerDetails
		NavigationHelper.helper.contentNavController!.pushViewController(rateandReviewVC, animated: true)

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	// Education Lable Hide unhide

	func eductionLableHideUnhide(_ isHideStatus: Bool) {
       
		self.labelEduDesc.isHidden = isHideStatus
		self.labelEduFormDate.isHidden = isHideStatus
		self.lableEduToDate.isHidden = isHideStatus

	}
	// Experience lable Hide Unhide
	func experienceLableHideUnhide(_ isHideStatus: Bool) {
      
		self.labelExpToDate.isHidden = isHideStatus
		self.labelExpFromDate.isHidden = isHideStatus

	}

}
// MARK:- Function.
extension MeetAnExpertDetailsViewController {
	// Add rating Button.
	func setRatingButton() {
		buttonRating = UIButton(type: .system) // let preferred over var here
		buttonRating.frame = CGRect(x: UIScreen.main.bounds.width - 65.0, y: UIScreen.main.bounds.height - 80.0, width: 50.0, height: 50.0)
		buttonRating.tintColor = UIColor.clear
		buttonRating.setBackgroundImage(UIImage(named: "CommentsFlootingEditIcon"), for: UIControlState())
		buttonRating.addTarget(self, action: #selector(self.actionRating(_:)), for: UIControlEvents.touchUpInside)
		NavigationHelper.helper.mainContainerViewController?.view.addSubview(self.buttonRating!)
	}

	func actionRating(_ sender: UIButton) {
		Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
				let writeReviewVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: WriteReviewController.self)) as! WriteReviewController
				// writeReviewVC.influncerID = self.objInfluencerDetails.influencerID!

				writeReviewVC.objInfluencerList = self.objInfluencerDetails
				NavigationHelper.helper.contentNavController!.pushViewController(writeReviewVC, animated: true)
			}
		}
	}
	func checkFollowingORStartFollowingStatus() {

		if INTEGER_FOR_KEY(kUserID) != 0 {
			self.buttonFollow.setTitle("Following", for: UIControlState())
			self.buttonFollow.setImage(UIImage(named: "FollowIcon"), for: UIControlState())
			self.buttonFollow.backgroundColor = UIColorRGB(227, g: 244, b: 30)
			self.buttonFollow.setTitleColor(UIColor.black, for: UIControlState())
			self.changeFollowTitle(objInfluencerDetails.isFollowStatus!)

		}
		else {
			self.buttonFollow.setImage(UIImage(named: ""), for: UIControlState())
			self.buttonFollow.setTitle("Start Following", for: UIControlState())
		}

	}
	func changeLikeAndDislike(_ isLikeStatus: Bool) {
		if isLikeStatus == true {
			self.btnLikeDisLike.setImage(UIImage(named: kFevImageSeleted), for: UIControlState())

		} else {
			self.btnLikeDisLike.setImage(UIImage(named: kFevImageDeSeleted), for: UIControlState())

		}

	}

	// Follow And un follow
	func changeFollowTitle(_ isFollowStatua: Bool) {
		if isFollowStatua == true {
			self.buttonFollow.setTitle("Unfollow", for: UIControlState())
		} else {
			self.buttonFollow.setTitle("Follow", for: UIControlState())
		}
	}

	// MARK:- Get influencer Details...
	func getinfluencerDetails(_ objinfluencer: (_ objinfluencer: Influencer) -> ()) {
		objinfluencer(self.objInfluencerDetails!)

		// Get Rating..
		self.getInfluncerRateAndReviewList({ (pRatingData) in
			if pRatingData.count > 0 {
				let objRating = pRatingData[0] as! Ratings
				self.viewRate.rating = Float(objRating.rating!)
				self.labelRateComments.text = objRating.comment
                self.labelRateTitle.text = objRating.title
				let date = Date.dateFromTimeInterval(Double(objRating.createdAt!)).getFormattedStringWithFormat()
				self.labelRatingonDate.text = date
				self.labelGivenCommentsName.text = objRating.name
			}

		})

	}

	// Chnage Report Abus Status
	func changeReportAbusImage(_ isReportAbusStatus: Bool) {
		if isReportAbusStatus == true {
            self.buttonReportAbus.isUserInteractionEnabled = false
			self.buttonReportAbus.setImage(UIImage(named: kReportAbusRedImage), for: UIControlState())

		} else {
            self.buttonReportAbus.isUserInteractionEnabled = true
			self.buttonReportAbus.setImage(UIImage(named: kReportAbusGreenImage), for: UIControlState())

		}

	}

}

extension MeetAnExpertDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

	// MARK: UICollectionViewDataSource methods
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == collectionViewProj {
			return self.arrInfluncerProjectList.count
		} else {
			return self.arrInfluncerIdeaList.count
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell: BaseCollectionViewCell?
		if collectionView == collectionViewProj {
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProjectsCollectionViewCell.self), for: indexPath) as! ProjectsCollectionViewCell
			if self.arrInfluncerProjectList.count > 0 {

				let objPortfolio = arrInfluncerProjectList[indexPath.row] as! Portfolio
				cell?.datasource = objPortfolio.arrPortFolioImages[0]

			}

		} else {
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: IdeasCollectionViewCell.self), for: indexPath) as! IdeasCollectionViewCell

			if self.arrInfluncerIdeaList.count > 0 {
				cell?.datasource = self.arrInfluncerIdeaList[indexPath.row]
			}

		}
		return cell!
	}
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if totalCount > self.arrInfluncerProjectList.count {
            if indexPath.item == self.arrInfluncerProjectList.count - 1 {
                pageno = self.arrInfluncerProjectList.count/pageSize + 1  //calculating pageno for load more data
                self.getInfluncerProjectList()
            }
        }
    }
    
    
    

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == collectionViewProj {

			let ProjectDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: ProjectDetailsController.self)) as! ProjectDetailsController
			let objPortfolioList = arrInfluncerProjectList[indexPath.row] as! Portfolio
			ProjectDetailsVC.objPortfolioDetails = objPortfolioList
			NavigationHelper.helper.contentNavController!.pushViewController(ProjectDetailsVC, animated: true)

		}
		else {
			let cell = collectionView.cellForItem(at: indexPath) as! IdeasCollectionViewCell
			let IdeaDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: IdeasDetailsController.self)) as! IdeasDetailsController
			let objIdeaList = cell.datasource
			IdeaDetailsVC.ideaDetailsObj = objIdeaList as! IdeaListing
			NavigationHelper.helper.contentNavController?.pushViewController(IdeaDetailsVC, animated: true)
		}

	}

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		return CGSize(width: 115.0, height: 115)
	}
}

extension MeetAnExpertDetailsViewController {
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.row {
		case 0:
			return IS_IPAD() ? 284.0 : 217.0
		case 1:
			return IS_IPAD() ? 80.0 : 72.0
            case 2:
            return CGFloat(self.hightProjectCell)
            case 3:
			return CGFloat(self.hightIdeaCell)
        case 4:
            return  self.labelAboutNameDesc.requiredHeight() +   100//UITableViewAutomaticDimension
        case 5:
			return  CGFloat(self.hightEduCell) //IS_IPAD() ? 200 : 180
		case 6:
			return CGFloat(self.hightExpCell) //IS_IPAD() ? 160 : 140
		case 7..<8:
			return UITableViewAutomaticDimension
        case 8:
            return UITableViewAutomaticDimension
        default:
			return 0
		}
	}
}
// MARK:- Api Calling
extension MeetAnExpertDetailsViewController {

	func influncerLikeDislike(forUserID userID: Int?, influencerID: Int?) {

		if self.objInfluencerDetails.isLikedStatus == true {

			// Influencer Dislike
			APIHandler.handler.influencerDislike(forinfluencerID: influencerID!, success: { (response) in

                if (response?["likeCount"].int!)! < 0 {
                    self.labelLikeCount.text = "0"
                } else {
                    self.labelLikeCount.text = String(describing: response?["likeCount"])
                }
				
				self.changeLikeAndDislike(false)
				self.objInfluencerDetails.isLikedStatus = false
				// self.tableView.reloadData()
				// Toast.show(withMessage: DISLIKE_SUCCESSFULLY)
			}) { (error) in

			}

		} else {
			// Influencer Like
			APIHandler.handler.addInfluencerLike(forUserID: userID!, influencerID: influencerID!, success: { (response) in

				debugPrint(response)
                if (response?["likeCount"].int!)! < 0 {
                    self.labelLikeCount.text = "0"
                } else {
                    self.labelLikeCount.text = String(describing: response?["likeCount"])
                }

				self.changeLikeAndDislike(true)
				self.objInfluencerDetails.isLikedStatus = true
				// self.tableView.reloadData()
			}) { (error) in

			}

		}
	}

	func setFollowAndUnFollowStaus() {
		if objInfluencerDetails.isFollowStatus == true {
            
            if (Globals.sharedClient.userID!) != (self.objInfluencerDetails.influencerID!){
                APIHandler.handler.unFollow(forUnfollowrID: self.objInfluencerDetails.influencerID!, success: { (response) in
                    debugPrint("Un Follow Respose ==> \(response)")
                    self.changeFollowTitle(false)
                    self.objInfluencerDetails.isFollowStatus = false
                    }, failure: { (error) in
                })
            }else{
                Toast.show(withMessage: USER_CAN_NOT_UNFOLLOW)
            }
			

		}
		else if objInfluencerDetails.isFollowStatus == false {
            if (Globals.sharedClient.userID!) != (self.objInfluencerDetails.influencerID!){
                // call follow api
                APIHandler.handler.addFollow(forFollowerID: self.objInfluencerDetails.influencerID!, success: { (response) in
                    self.changeFollowTitle(true)
                    self.objInfluencerDetails.isFollowStatus = true
                    
                    }, failure: { (error) in
                        
                })
            }else{
              Toast.show(withMessage: USER_CAN_NOT_FOLLOW)
            }
			

		}
	}

	// MARK:- Get Influncer Idea details.
	func getInfluncerIdeaList() {
		self.arrInfluncerIdeaList.removeAll()

		APIHandler.handler.getIdeaListingWithUserID(forUserID: objInfluencerDetails.influencerID!,pageno: 1, pageSize: 8, success: { (response) in
			if let arrIdesList = response?["Idea"].arrayObject {

				let notificationCount = response?["totalNotification"].intValue
				if notificationCount! > 0 {
					NavigationHelper.helper.headerViewController!.lblNotification.isHidden = false
					NavigationHelper.helper.headerViewController!.lblNotification.text = String(describing: notificationCount)
				} else {
					NavigationHelper.helper.headerViewController!.lblNotification.isHidden = true
				}

				if arrIdesList.count > 0 {
                 self.hightIdeaCell =  IS_IPAD() ? 220.0 : 190.0
					self.buttonViewAllIdeas.isHidden = false
					self.collectionViewIdeas.isHidden = false
					for value in (response?["Idea"].arrayObject!)! {
						let idesListObj = IdeaListing(withDictionary: value as! [String: AnyObject])
						self.arrInfluncerIdeaList.append(idesListObj)
					}
					self.collectionViewIdeas.reloadData()
					
				} else {
                    self.hightIdeaCell =  IS_IPAD() ? 120 : 100
					self.buttonViewAllIdeas.isHidden = true
					self.collectionViewIdeas.isHidden = true
				}
			}
            self.tableView.reloadData()
            
            DispatchQueue.main.async {
                self.userDetails()
 
            }

		}) { (error) in

		}
	}

	// Get Influncer Project List
	func getInfluncerProjectList() {
		self.arrInfluncerProjectList.removeAll()
		APIHandler.handler.getMyPortfolioListing(objInfluencerDetails.influencerID!, pageNumber:1, perPage: 50, success: { (response) in

            self.totalCount = response?["totalCount"].intValue
			if let arrResult = response?["portfolios"].arrayObject
			{
				if arrResult.count > 0 {
                     self.hightProjectCell =  IS_IPAD() ? 220.0 : 190.0
					self.collectionViewProj.isHidden = false
					self.buttonViewAllProj.isHidden = false
					for value in arrResult {
						let objPortfolio = Portfolio(withDictionary: value as! [String: AnyObject])
						self.arrInfluncerProjectList.append(objPortfolio)
					}
					self.collectionViewProj.reloadData()
				
				} else {
                    self.hightProjectCell =  IS_IPAD() ? 120 : 100
					self.collectionViewProj.isHidden = true
				}

			}
            	self.tableView.reloadData()
			self.getInfluncerIdeaList()
		}) { (error) in

		}

	}

	// MArk:- Get Influncer Rate list
	func getInfluncerRateAndReviewList(_ pRatingData: @escaping (([AnyObject]) -> ())) {

		APIHandler.handler.rateAndReview(forUser: self.objInfluencerDetails.influencerID!, success: { (response) in
			self.arrRating.removeAll()

            DispatchQueue.main.async {
                self.getInfluncerProjectList()
   
            }

			if let _ = response?.dictionaryObject!["reviewlist"] {
				self.buttonRateReview.isUserInteractionEnabled = true
				for value in (response?["reviewlist"]["ratings"].arrayObject!)! {
					let RateListObj = Ratings(withDictionary: value as! [String: AnyObject])
					self.arrRating.append(RateListObj)
				}
				pRatingData(self.arrRating)

			} else {
				self.buttonRateReview.isUserInteractionEnabled = false
			}

		}) { (error) in

		}
	}

	// Working on Report abuse.
	func reportAbusWith(forReportID typeID: Int?, abuseType: String?) {
		APIHandler.handler.reportAbuseWithTypeID(forTypeID: typeID!, abuse_type: abuseType!, success: { (response) in
			self.objInfluencerDetails.abusedStatus = true
			self.changeReportAbusImage(true)
		}) { (error) in

			Toast.show(withMessage: mReportAlredy)
		}
	}
    
    // UserDetails API Call
    func userDetails() {
        APIHandler.handler.userDetails(forUser: self.objInfluencerDetails.influencerID!, success: { (response) in

            
            
            print("Respose\(response)")
           
            self.changeLikeAndDislike(response!["isLiked"].boolValue)
            
                let dictData =   response?["User"]["profile"].dictionaryObject
                if let _ = dictData!["ivr_ext"] as? String {
                self.strIverExtationNumber = dictData!["ivr_ext"] as? String
                }
                else{
                    self.strIverExtationNumber = "N/A"
            }
            	//self.changeFollowTitle(Bool(response["isFollowing"]))
               self.objInfluencerDetails.isFollowStatus = response?["isFollowing"].boolValue
            self.checkFollowingORStartFollowingStatus()
       
            
            self.objInfluencerDetails.abusedStatus = response?["abused"].boolValue
            self.changeReportAbusImage(response!["abused"].boolValue)
            self.labelFollowers.text = String(describing: response?["follower_count"])
            self.labelFollowing.text = String(describing: response?["following_count"])
            }) { (error) in
                debugPrint(error)
        }
    }

}
