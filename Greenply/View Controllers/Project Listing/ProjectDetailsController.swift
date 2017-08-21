//
//  ProjectDetailsController.swift
//  Greenply
//
//  Created by Shatadru Datta on 31/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ProjectDetailsController: BaseTableViewController {

	@IBOutlet weak var imgLike: UIImageView!
	@IBOutlet weak var collectionImages: UICollectionView!
	@IBOutlet weak var imageBannerProjDetails: UIImageView!
	@IBOutlet weak var imageProfileProjDetails: UIImageView!
	@IBOutlet weak var labelProjDescription: UILabel!
    var isReportSatus: Bool?
    @IBOutlet weak var buttonReportAbus: UIButton!
    @IBOutlet weak var labelProjType: UILabel!
	@IBOutlet weak var labelProjLocation: UILabel!
	@IBOutlet weak var labelDesignType: UILabel!
	@IBOutlet weak var imageBottomLayer: UIImageView!
	@IBOutlet weak var labelProjName: UILabel!
	@IBOutlet weak var labelLikes: UILabel!
	@IBOutlet weak var labelViews: UILabel!
	@IBOutlet weak var buttonFollow: UIButton!
	var objPortfolioDetails: Portfolio!
    var portFolioUserID: Int?
	@IBOutlet var labelProjectType: UILabel!
	@IBOutlet var labelLocationType: UILabel!
	@IBOutlet var labelStyleType: UILabel!
	@IBOutlet var labelRoomType: UILabel!
	@IBOutlet var labelWorkType: UILabel!
	@IBOutlet var labelProjectBudget: UILabel!
	@IBOutlet var labelTags: UILabel!

    @IBOutlet weak var buttonProjectImg: UIButton!
    @IBOutlet weak var buttonShare: UIButton!
	@IBOutlet var viewContents: [UIView]!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.backgroundView = nil
		self.tableView.backgroundColor = UIColorRGB(233.0, g: 235.0, b: 236.0)

		for (index, view) in viewContents.enumerated() {

			view.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
			view.layer.borderColor = UIColorRGB(224.0, g: 226.0, b: 227.0)?.cgColor

			if index == 0 || index == 6 || index == 7 {
				view.layer.cornerRadius = IS_IPAD() ? 10.0 : 5.0
				view.layer.masksToBounds = true
			} else {
				view.layer.masksToBounds = false
			}
		}

		imageProfileProjDetails.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
		imageProfileProjDetails.layer.borderColor = UIColorRGB(149.0, g: 204.0, b: 68.0)?.cgColor
		imageProfileProjDetails.layer.cornerRadius = IS_IPAD() ? imageProfileProjDetails.frame.size.width / 2: 50 / 2
		imageProfileProjDetails.layer.masksToBounds = true

		buttonFollow.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
		buttonFollow.layer.borderColor = UIColorRGB(149.0, g: 204.0, b: 68.0)?.cgColor
		buttonFollow.layer.cornerRadius = IS_IPAD() ? 20.0 : 10.0
		buttonFollow.layer.masksToBounds = true
        
        if let imageProfile = self.objPortfolioDetails.displayProfileImg {
            self.imageProfileProjDetails.setImage(withURL: URL(string: imageProfile)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))
            
        }
        else {
            self.imageProfileProjDetails.image = UIImage(named: "DefultProfileImage")
        }
        self.imageProfileProjDetails.contentMode = .scaleAspectFill

	}
    
    @IBAction func actionProfile(_ sender: UIButton) {
        let imageFullVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: ImageViewController.self)) as! ImageViewController
        imageFullVC.imageURl =  self.objPortfolioDetails.displayProfileImg
        NavigationHelper.helper.contentNavController?.pushViewController(imageFullVC, animated: true)
    
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_Project_Details
		self.showProftfolioDataDetails()
		// call api portfolio Details
		self.getPortFolioDetailsWith(forPortfolioID: objPortfolioDetails.portfolioID)
	}
    
    @IBAction func actionReportAbus(_ sender: UIButton) {
    }
    @IBAction func actionFollow(_ sender: UIButton) {
       
        Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
            if isLogin == true{
                if self.objPortfolioDetails.isFollowStatus == true{
                    if Globals.sharedClient.userID != self.portFolioUserID{
                    APIHandler.handler.unFollow(forUnfollowrID: self.portFolioUserID!, success: { (response) in
                        debugPrint("Un Follow Respose ==> \(response)")
                        Toast.show(withMessage: UNFOLLOW_SUCCESSFULLY)
                        self.changeFollowTitle(false)
                        self.objPortfolioDetails.isFollowStatus = false
                        }, failure: { (error) in
                    })
                    
                    }else{
                        Toast.show(withMessage: USER_CAN_NOT_UNFOLLOW)
                    }
                }
                else if self.objPortfolioDetails.isFollowStatus == false{
                     if Globals.sharedClient.userID != self.portFolioUserID{
                    APIHandler.handler.addFollow(forFollowerID: self.portFolioUserID!, success: { (response) in
                        self.changeFollowTitle(true)
                        self.objPortfolioDetails.isFollowStatus = true
                        debugPrint("Follow Status==>\(response)")
                        Toast.show(withMessage: FOLLOW_SUCCESSFULLY)

                        }, failure: { (error) in
                            
                    })
                      }else{
                        Toast.show(withMessage: USER_CAN_NOT_FOLLOW)
                    }
                }
            }
        }
   
        
    }
	
    @IBAction func likes(_ sender: UIButton) {
        Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
            if isLogin == true{
                
            }
        }
	}
	@IBAction func share(_ sender: UIButton) {
        Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
            if isLogin == true{
              self.socialShare(self.buttonShare, text: self.objPortfolioDetails.portFolioURl!)
            }
        }
	}
	@IBAction func alert(_ sender: UIButton) {
        if isReportSatus == true{
          self.buttonReportAbus.isUserInteractionEnabled = true
             self.reportAbusWith(forReportID: objPortfolioDetails.portfolioID!, abuseType: kReportAbusPortfolio)
        }else{
            self.buttonReportAbus.isUserInteractionEnabled = false
           
        }
        
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK:- action.

	@IBAction func actionImageList(_ sender: AnyObject) {

		let portfolioImageListVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: AllPortfolioImagesListViewController.self)) as! AllPortfolioImagesListViewController
		let imageArr = objPortfolioDetails.arrPortFolioImages

		portfolioImageListVC.arrPortfolioImageList = imageArr
		NavigationHelper.helper.contentNavController?.pushViewController(portfolioImageListVC, animated: true)
	}

	func showProftfolioDataDetails() {
		labelProjName.text = objPortfolioDetails.projectName
		labelLikes.text = "\(objPortfolioDetails.likeCount!)"
		labelViews.text = "\(objPortfolioDetails.viewCount!)"
		labelProjDescription.text = objPortfolioDetails.portfolioDescription

	}
    // Share Function.
    func socialShare(_ sender: UIButton!, text: String) {
        var sharingItems = [AnyObject]()
        if let text = URL(string: text) {
            sharingItems.append(text as AnyObject)
        }
        //let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        
        if IS_IPAD() {
      
            let activityVC = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
            
            let nav = UINavigationController(rootViewController: activityVC)
            nav.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = nav.popoverPresentationController as UIPopoverPresentationController!
            
            popover?.sourceView = sender
           // popover.sourceRect = CGRectMake(self.view.bounds.width/2 + 150, CGRectGetMaxY((sender.superview?.superview?.frame)!), 0, 0)
            self.present(nav, animated: true, completion: nil)
        
        
        
        } else {
             let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityType.copyToPasteboard,UIActivityType.airDrop,UIActivityType.addToReadingList,UIActivityType.assignToContact,UIActivityType.postToTencentWeibo,UIActivityType.postToVimeo,UIActivityType.print,UIActivityType.saveToCameraRoll,UIActivityType.postToWeibo]
           self.present(activityViewController, animated: true, completion: nil)
        }
        
    }

}

extension ProjectDetailsController {
// MARK:- User Details.
    func getAttributeName(_ attributeSearchName: String, pArry: [AnyObject]) -> String?
	{
		let name = NSPredicate(format: "attribute_name contains[c] %@", attributeSearchName)

		let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
		let filteredArray = pArry.filter { compoundPredicate.evaluate(with: $0) }
		// return filteredArray.first!["attribute_value_name"]
		if filteredArray.count > 0 {
			let dict = filteredArray.first
			return dict!["attribute_value_name"] as? String
		}
        else{
            return  "Not available"
        }
	
	}
    // MARK:- 
    // Follow And un follow
    func changeFollowTitle(_ isFollowStatua: Bool){
        if isFollowStatua == true{
            self.buttonFollow.setTitle("Unfollow", for: UIControlState())
        }else{
            self.buttonFollow.setTitle("Follow", for: UIControlState())
        }
    }
    // Change Like button Image.
    func changeLikeButtonImage(_ isLikeStatus: Bool) {
        if isLikeStatus == true {
            self.imgLike.image = UIImage(named: kImageLikeSelected)
        }
        else {
            self.imgLike.image = UIImage(named: kImageLikeDeselected)
        }
    }
    
    
    // Chnage Report Abus Status
    func changeReportAbusImage(_ isReportAbusStatus: Bool) {
        if isReportAbusStatus == true {
            self.buttonReportAbus.isUserInteractionEnabled = false
            self.buttonReportAbus.setImage(UIImage(named:kReportAbusRedImage ), for: UIControlState())
            
        } else {
            self.buttonReportAbus.isUserInteractionEnabled = true
            self.buttonReportAbus.setImage(UIImage(named:kReportAbusGreenImage ), for: UIControlState())
        }
        
    }
}
extension ProjectDetailsController {
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.section {
		case 0:
			switch indexPath.row {
			case 0:
				return 147
			case 1:
				return IS_IPAD() ? 212.0 : 190.0
			case 2:
                return (objPortfolioDetails.portfolioDescription?.requiredHeight(forWidth: SCREEN_WIDTH - ((2 * 16) + 10), andFont: labelProjDescription.font))! + 65.0 + 20.0
			default:
				return IS_IPAD() ? 440 : 340
			}
		case 1:
			switch indexPath.row {
			case 0:
				return IS_IPAD() ? 75.0 : 68.0
			case 1:
				return IS_IPAD() ? 68.0 : 60
			case 2:
				return IS_IPAD() ? 68.0 : 60
			case 3:
				return IS_IPAD() ? 68.0 : 60
			case 4:
				return IS_IPAD() ? 68.0 : 60
			case 5:
				return IS_IPAD() ? 68.0 : 60
			case 6:
				return IS_IPAD() ? 85.0 : 60
			default:
				return 0
			}
		default:
			return 0
		}
	}
}

extension ProjectDetailsController: UICollectionViewDataSource, UICollectionViewDelegate {

	// MARK: UICollectionViewDataSource methods
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.objPortfolioDetails.arrPortFolioImages.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell: BaseCollectionViewCell?
		cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProjectsCollectionViewCell.self), for: indexPath) as! ProjectsCollectionViewCell
		cell?.datasource = objPortfolioDetails.arrPortFolioImages[indexPath.row]
		return cell!
	}

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		return CGSize(width: 115.0, height: 115.0)
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		let portfolioImageListVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: AllPortfolioImagesListViewController.self)) as! AllPortfolioImagesListViewController
		let imageArr = objPortfolioDetails.arrPortFolioImages
		portfolioImageListVC.arrPortfolioImageList = imageArr

		NavigationHelper.helper.contentNavController!.pushViewController(portfolioImageListVC, animated: true)

	}
}

// API Calling
extension ProjectDetailsController {
	func getPortFolioDetailsWith(forPortfolioID portfolioID: Int?) {

		APIHandler.handler.getPortFolioDetails(forPortFolioID: portfolioID, success: { (response) in

			var dict = response?.dictionaryObject
			let arrAttr = dict!["attribute_name"]
    self.objPortfolioDetails.isFollowStatus = response?["user"]["isFollowing"].boolValue
           self.isReportSatus = response?["abused"].boolValue
            self.changeReportAbusImage(self.isReportSatus!)
            self.objPortfolioDetails.isLikedStatus = response?["isLiked"].boolValue
           self.portFolioUserID = dict!["user_id"] as? Int
            self.changeLikeButtonImage(self.objPortfolioDetails.isLikedStatus!)
            self.changeFollowTitle(self.objPortfolioDetails.isFollowStatus!)
            
			self.labelStyleType.text = self.getAttributeName("Design Type", pArry: arrAttr! as! [AnyObject])
			self.labelWorkType.text = self.getAttributeName("Work Type", pArry: arrAttr! as! [AnyObject])
			self.labelProjectBudget.text = self.getAttributeName("Project Budget", pArry: arrAttr! as! [AnyObject])
			 self.labelProjType.text = self.getAttributeName("Project Type", pArry: arrAttr! as! [AnyObject])

			self.labelLocationType.text = self.objPortfolioDetails.location // Not Coming to APi.
			self.labelRoomType.text = "Not available" // Not Coming to APi.

			let arrTag = response!["tags"].arrayObject
            var nameStr: String = ""
			for index in 0..<arrTag!.count {
				
                //nameStr = nameStr + (arrTag![index]["tag_name"]! as? String)!
                
                let arr = arrTag![index] as! [String: AnyObject]
                
                 nameStr = nameStr + (arr["tag_name"] as! String)
                
				if index < arrTag!.count - 1 {
					nameStr = nameStr + ","
				}
			}
    
			self.labelTags.text = nameStr
			

		}) { (error) in

		}

	}
      // MARK:- Call Follow And unFollow Api
    func setFollowAndUnFollowStaus() {
    
    }
    // Working on Report abus.
    func reportAbusWith(forReportID typeID: Int?, abuseType: String?) {
        APIHandler.handler.reportAbuseWithTypeID(forTypeID: typeID!, abuse_type: abuseType!, success: { (response) in
            print("Report Value==\(response)")
            //self.ideaDetailsObj.isReportAbusStatus = true
            self.changeReportAbusImage(false)
        }) { (error) in
            
        }
    }
    

}

