//
//  IdeasDetailsController.swift
//  Greenply
//
//  Created by Shatadru Datta on 31/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

enum eIdeaDetails {
	case eIdeaDetailsTitle
	case ePinnedDetailsTitle
}

class IdeasDetailsController: BaseTableViewController {

	var eIdeaTitleStatus: eIdeaDetails = .eIdeaDetailsTitle
	@IBOutlet weak var imgLike: UIImageView!
	@IBOutlet weak var imgPinned: UIImageView!
	@IBOutlet weak var imageBannerIdeasDetails: UIImageView!
	@IBOutlet weak var imageProfileIdeasDetails: UIImageView!
//	@IBOutlet weak var labelIdeasName: UILabel!
    
    @IBOutlet weak var labelIdeasName: UILabel!
  
   
 
    
	@IBOutlet weak var labelIdeasDescription: UILabel!
	@IBOutlet weak var labelIdeasProjType: UILabel!
	@IBOutlet weak var labelIdeasLocation: UILabel!
	@IBOutlet weak var labelDesignType: UILabel!
	@IBOutlet weak var labelRoomType: UILabel!
    //var isCommentBtnShowHide: Bool = true
	var arrComments = [AnyObject]()
	var ideaDetailsObj: IdeaListing!
	var textComment: String!
	var commentDesc: String!

    @IBOutlet weak var btnProfile: UIButton!
	@IBOutlet weak var buttonReportAbus: UIButton!
	@IBOutlet weak var imgReportAbus: UIImageView!
	@IBOutlet weak var imageBottomLayer: UIImageView!
	@IBOutlet weak var labelLikes: UILabel!
	@IBOutlet weak var labelViews: UILabel!

	@IBOutlet weak var buttonFollow: UIButton!

	@IBOutlet weak var labelCommentsDesc: UILabel!
	@IBOutlet weak var labelCommentsName: UILabel!
	@IBOutlet weak var labelCommentsDate: UILabel!
	@IBOutlet weak var buttonCommentsViews: UIButton!
	@IBOutlet weak var buttonAlert: UIButton!
	@IBOutlet weak var labelAboutProject: UILabel!
    @IBOutlet weak var buttonPinned: UIButton!
    
    var linkShare: JSON!
    
	var commentBtn: UIButton!

	@IBOutlet var viewContents: [UIView]!

	override func viewDidLoad() {
		super.viewDidLoad()
        
//            labelIdeasName.type = .continuous
//        labelIdeasName.speed = .duration(8.0)
//             labelIdeasName.animationCurve = .easeOut
//          labelIdeasName.fadeLength = 20
//          labelIdeasName.leadingBuffer = 15
//          labelIdeasName.trailingBuffer = 30
        	self.loadIdeaDetails()
        self.tableView.estimatedRowHeight = 220
      
		// buttonFollow.addTarget(self, action: #selector(self.actionFollow(_:)), forControlEvents: .TouchUpInside)
		self.tableView.backgroundView = nil
		self.tableView.backgroundColor = UIColorRGB(233.0, g: 235.0, b: 236.0)

		imageProfileIdeasDetails.layer.cornerRadius = IS_IPAD() ? imageProfileIdeasDetails.frame.size.height / 2: 50 / 2
		imageProfileIdeasDetails.layer.masksToBounds = true

		buttonFollow.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
		buttonFollow.layer.borderColor = UIColorRGB(149.0, g: 204.0, b: 68.0)?.cgColor
		buttonFollow.layer.cornerRadius = IS_IPAD() ? 20.0 : 10.0
		buttonFollow.layer.masksToBounds = true

	}
    

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
		if eIdeaTitleStatus == .eIdeaDetailsTitle {
			NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_Idea_Details
			labelAboutProject.text = "About Idea"
		}
		else if eIdeaTitleStatus == .ePinnedDetailsTitle {
			NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_PINNED_Details
			labelAboutProject.text = "About Pinned"
		}

		NavigationHelper.helper.tabBarViewController!.hideTabBar()
             self.setCommentButton()

		
		self.getIdeaDetailsWithIdeaID(forIdeaID: ideaDetailsObj.IdeaID)
	

	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
        	commentBtn.removeFromSuperview()
//        if isCommentBtnShowHide == true{
//	
//        }
	}
    
    
    @IBAction func actionProfile(_ sender: UIButton) {
        let imageFullVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: ImageViewController.self)) as! ImageViewController
        
        if !(ideaDetailsObj.displayProfileImg == "" || ideaDetailsObj.displayProfileImg == nil)
        {
            imageFullVC.imageURl = ideaDetailsObj.displayProfileImg
            NavigationHelper.helper.contentNavController?.pushViewController(imageFullVC, animated: true)
        }


    }

	@IBAction func alertAction(_ sender: UIButton) {
        
        Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
            if isLogin == true {
                if self.arrComments.count > 0 {
                    let objComments = self.arrComments[0] as! Comments
                    if objComments.commentReportAbus == true {
                        self.buttonAlert.isUserInteractionEnabled = false
                    } else {
                        Helper.sharedClient.showAlertView(inViewControler: self, alertMessge: WANT_REPORT_ABUSE, indexValue: { (successIndex) in
                            if successIndex == 1{
                                self.buttonAlert.isUserInteractionEnabled = true
                                self.reportAbusWith(forReportID: objComments.commentID!, abuseType: kReportAbusComment)
                            }
                        })
                       
                    }
                }
            
            }
        
        }
        
	

	}
	override func viewDidLayoutSubviews() {

		self.viewWillLayoutSubviews()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func actionIdeaImageCover(_ sender: UIButton) {
		let imageFullVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: ImageViewController.self)) as! ImageViewController
        
        if !(ideaDetailsObj.ideaImageOriginal == "" || ideaDetailsObj.ideaImageOriginal == nil){
            imageFullVC.imageURl = ideaDetailsObj.ideaImageOriginal
            NavigationHelper.helper.contentNavController?.pushViewController(imageFullVC, animated: true)
        }
        
	
	}
	// MARK:- Action
	@IBAction func actionComments(_ sender: AnyObject) {
        
        if self.arrComments.count > 0 {
            self.buttonCommentsViews.isUserInteractionEnabled = true
            let commentsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: AllCommentsViewController.self)) as! AllCommentsViewController
            commentsVC.arrAllCommentsList = arrComments
            commentsVC.ideaID = self.ideaDetailsObj.IdeaID
             commentsVC.ideaUserID = self.ideaDetailsObj.IdeaUserID
            NavigationHelper.helper.contentNavController?.pushViewController(commentsVC, animated: true)
        }else{
        self.buttonCommentsViews.isUserInteractionEnabled = false
        }
		
	}
	func loadIdeaDetails()
	{
		labelRoomType.text = ideaDetailsObj.roomValue
		labelDesignType.text = ideaDetailsObj.styleValue
		//labelIdeasDescription.text = ideaDetailsObj.ideaDescription
        let ideaDesc =  ideaDetailsObj.ideaDescription
      
       labelIdeasDescription.text =  ideaDesc!.trimString(forString: ideaDesc)

		labelLikes.text = "\(ideaDetailsObj.likeCount! as Int)"
		labelViews.text = "\(ideaDetailsObj.viewCount! as Int)"
		labelIdeasName.text = ideaDetailsObj.ideaName
		imageBannerIdeasDetails.setImage(withURL: URL(string: ideaDetailsObj.ideaImageMedium!)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .crossDissolve(0.4))
        
        

	}

	@IBAction func actionFollow(_ sender: UIButton) {
		Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
                    self.setFollowAndUnFollowStaus()
			}
		}
	}

	// MARK:- Share
	@IBAction func share(_ sender: UIButton) {
        Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
				// call APi
                self.socialShare(self.buttonPinned ,text: String(describing: self.linkShare))
			}
		}

	}

	// MARK:- Pinned
	@IBAction func Pinned(_ sender: UIButton) {

		Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
				if let pinnedStatus = self.ideaDetailsObj.isPinnedStatus {
					self.setIdeaPinnedStatus(pinnedStatus)
				}
			}
		}
	}
// Action Report Abus

	@IBAction func actionReportAbus(_ sender: UIButton) {
        Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
            if isLogin == true {
                // call report abus api
                if self.ideaDetailsObj.isReportAbusStatus == true {
                    self.buttonReportAbus.isUserInteractionEnabled = false
                }
                else {
                    Helper.sharedClient.showAlertView(inViewControler: self, alertMessge: WANT_REPORT_ABUSE, indexValue: { (successIndex) in
                        if successIndex == 1{
                            self.buttonReportAbus.isUserInteractionEnabled = true
                            self.reportAbusWith(forReportID: self.ideaDetailsObj.IdeaID!, abuseType: kReportAbusIdea)
                        }
                    })
                    
                }
            }
            }
      

	}
	// MARK:- Views
	@IBAction func Views(_ sender: UIButton) {

	}

	// MARK:- Likes
	@IBAction func likes(_ sender: UIButton) {
		Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
				if let likeStaus = self.ideaDetailsObj.isLikedStatus {
					self.setLikeDislikeStaus(likeStaus)
				}

			}
		}

	}
}

extension IdeasDetailsController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return IS_IPAD() ? 313.0 : 240.0
            
        case 1,3:
           //return  self.labelCommentsDesc.requiredHeight() +   150
            return UITableViewAutomaticDimension
        default:
            return IS_IPAD() ? 130.0 : 105.0
        }
    }
}

// MARK: Call API.
extension IdeasDetailsController {
	func getIdeaDetailsWithIdeaID(forIdeaID ideaId: Int?) {
		APIHandler.handler.getIdeaDetails(ideaId, success: { (response) in
			debugPrint(response)
			debugPrint("Idea Details\(response?["Idea"]["comments"])")
            self.linkShare = response?["Idea"]["idea_url"]
			self.ideaDetailsObj.isFollowStatus = response?["isFollowing"].boolValue
			self.ideaDetailsObj.isLikedStatus = response?["isLiked"].boolValue
       
            
			self.ideaDetailsObj.isPinnedStatus = response?["isPinned"].boolValue
			self.ideaDetailsObj.IdeaUserID = response?["Idea"]["user_id"].int
			self.ideaDetailsObj.isReportAbusStatus = response?["abused"].bool
            self.ideaDetailsObj.likeCount = response?["likeCount"].intValue
			// change like button Staus,
			self.changeLikeButtonImage(self.ideaDetailsObj.isLikedStatus!)
			self.changePinnedImage(self.ideaDetailsObj.isPinnedStatus!)
			// Follow Button
			self.changeFollowTitle(self.ideaDetailsObj.isFollowStatus!)
			self.changeReportAbusImage(self.ideaDetailsObj.isReportAbusStatus!)

            self.loadIdeaDetails()
			self.arrComments.removeAll()
			for value in (response?["Idea"]["comments"].arrayObject!)! {
				let objComments = Comments(withDictionary: value as! [String: AnyObject])
				self.arrComments.append(objComments)
			}

			if self.arrComments.count > 0 {
                 self.buttonCommentsViews.isHidden = false
                  self.buttonAlert.isHidden = false
                self.labelCommentsName.isHidden = false
                        self.labelCommentsDesc.isHidden =  false
				let objComments = self.arrComments[0] as! Comments
				self.labelCommentsName.text = objComments.CommentsUserName
                let properString = objComments.commentsDetails!.removingPercentEncoding
              
            self.labelCommentsDesc.text =  properString?.stringSeparatedWith(forString: properString!, separatedBy: "+")

          
             
				self.labelCommentsDate.text = Date.dateFromTimeInterval(objComments.commentDate!).getFormattedStringWithFormat()

				self.changeReportAbusImageComment(objComments.commentReportAbus!)

            }
            else{
               self.buttonCommentsViews.isHidden = true
                self.labelCommentsDesc.isHidden =  true
                self.labelCommentsName.text = "Be the first one to comment"
//                if IS_IPAD(){
//                 self.labelCommentsDesc.hidden =  true
//                   self.labelCommentsName.text = "Be the first one to comment"
//                }else{
//                     self.labelCommentsDesc.hidden = false
//                   self.labelCommentsDesc.text = "Be the first one to comment"
//                }
               
               // self.labelCommentsName.font =  PRIMARY_FONT(IS_IPAD() ? 18.0 : 8)
                self.buttonAlert.isHidden = true
                // "No Comments available"
   
            }

			//let imageProfileUrl = response["user"]["display_profile"].string
			if let imageProfile = self.ideaDetailsObj.displayProfileImg {
				self.imageProfileIdeasDetails.setImage(withURL: NSURL(string: imageProfile)! as URL, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))

			}
			else {
				self.imageProfileIdeasDetails.image = UIImage(named: "DefultProfileImage")
			}
            self.imageProfileIdeasDetails.contentMode = .scaleAspectFill
			debugPrint("Idea Details List==> \(response?["comments"][0]["comment"])")
			self.tableView.reloadData()

		}) { (error) in

		}
	}
	// MARK:- Call Follow And unFollow Api

	func setFollowAndUnFollowStaus() {
		if ideaDetailsObj.isFollowStatus == true {
            if Globals.sharedClient.userID != self.ideaDetailsObj.IdeaUserID! {
                APIHandler.handler.unFollow(forUnfollowrID: self.ideaDetailsObj.IdeaUserID!, success: { (response) in
                    debugPrint("Un Follow Respose ==> \(response)")
                      Toast.show(withMessage: UNFOLLOW_SUCCESSFULLY)
                    self.changeFollowTitle(false)
                    self.ideaDetailsObj.isFollowStatus = false
                    }, failure: { (error) in
                })
            }else{
                Toast.show(withMessage: USER_CAN_NOT_UNFOLLOW)
            }
			

		}
		else if ideaDetailsObj.isFollowStatus == false {
			// call follow api
              if Globals.sharedClient.userID != self.ideaDetailsObj.IdeaUserID! {
                APIHandler.handler.addFollow(forFollowerID: self.ideaDetailsObj.IdeaUserID!, success: { (response) in
                    self.changeFollowTitle(true)
                    self.ideaDetailsObj.isFollowStatus = true
                    debugPrint("Follow Status==>\(response)")
                    Toast.show(withMessage: FOLLOW_SUCCESSFULLY)

                    
                    }, failure: { (error) in
                        
                })
              }else{
               Toast.show(withMessage: USER_CAN_NOT_FOLLOW)
            }
			

		}
	}

	// MARK:- Idea Pinned
	// Set Pinned.
	func setIdeaPinnedStatus(_ isPinnedStatus: Bool) {
		if isPinnedStatus == true {
            
                if Globals.sharedClient.userID != self.ideaDetailsObj.IdeaUserID! {
                    // call remove pinned api.
                    APIHandler.handler.removeIdeaPin(forIdeaID: self.ideaDetailsObj.IdeaID!, success: { (response) in
                        self.changePinnedImage(false)
                        self.ideaDetailsObj.isPinnedStatus = false
                        Toast.show(withMessage: PINNED_REMOVED)
                        }, failure: { (error) in
                            
                    })
                }
                else{
                       Toast.show(withMessage: USER_CAN_NOT_REMOVE_PIN)
            }
            
		
		}
		else {
            if Globals.sharedClient.userID != self.ideaDetailsObj.IdeaUserID! {
                // call add pinned api
                APIHandler.handler.addIdeaPin(withIdeaID: self.ideaDetailsObj.IdeaID!, success: { (response) in
                    Toast.show(withMessage: PINNED_ADD)
                    self.changePinnedImage(true)
                    self.ideaDetailsObj.isPinnedStatus = true
                    }, failure: { (error) in
                })
            }
            
            else{
              Toast.show(withMessage: USER_CAN_NOT_ADD_PIN)
            }
			
        }
	}
// Call Api Like and Dislike
	func setLikeDislikeStaus(_ isLikeStaus: Bool) {
		if isLikeStaus == true {
            
            if Globals.sharedClient.userID != self.ideaDetailsObj.IdeaUserID!{
                // call dislike api.
                APIHandler.handler.ideaDislike(forIdeaID: self.ideaDetailsObj.IdeaID!, success: { (response) in
                    debugPrint("Idea DisLike Response\(response)")
                    Toast.show(withMessage: DISLIKE_SUCCESSFULLY)
                    self.ideaDetailsObj.likeCount = response?["likeCount"].intValue
                    self.loadIdeaDetails()
                    self.changeLikeButtonImage(false)
                    self.ideaDetailsObj.isLikedStatus = false
                    }, failure: { (error) in
                        
                })
            }
            else{
                
                Toast.show(withMessage: USER_CAN_NOT_UNLIKE)
   
            }
			
		}
        else {
            
            if Globals.sharedClient.userID != self.ideaDetailsObj.IdeaUserID!
            {
                // call Like Api
                APIHandler.handler.addIdeaLike(forUserID: Globals.sharedClient.userID!, IdeaID: self.ideaDetailsObj.IdeaID!, success: { (response) in
                    
                    debugPrint("Idea Like Response\(response)")
                    Toast.show(withMessage: LIKE_SUCCESSFULLY)
                    self.ideaDetailsObj.likeCount = response?["likeCount"].intValue
                    self.loadIdeaDetails()
                    self.changeLikeButtonImage(true)
                    self.ideaDetailsObj.isLikedStatus = true
                    
                }) { (error) in
                    
                }
            }else{
               Toast.show(withMessage: USER_CAN_NOT_LIKE)
            }
            
            
			
		}

	}

	func addLike(forUserID userID: Int?, ideaID: Int?) {
		APIHandler.handler.addIdeaLike(forUserID: userID, IdeaID: ideaID, success: { (response) in

			debugPrint("Idea Like Response\(response)")
			self.ideaDetailsObj.likeCount = response?["likeCount"].intValue
			self.loadIdeaDetails()
			self.changeLikeButtonImage(true)
			self.ideaDetailsObj.isLikedStatus = true

		}) { (error) in

		}
	}

	// Working on Report abus.
	func reportAbusWith(forReportID typeID: Int?, abuseType: String?) {
		APIHandler.handler.reportAbuseWithTypeID(forTypeID: typeID!, abuse_type: abuseType!, success: { (response) in
			print("Report Value==\(response)")
			if abuseType == kReportAbusIdea {
				self.ideaDetailsObj.isReportAbusStatus = true
				self.changeReportAbusImage(true)
			} else if abuseType == kReportAbusComment {
				let objComments = self.arrComments[0] as! Comments
				objComments.commentReportAbus = true
				self.changeReportAbusImageComment(true)
			}

		}) { (error) in

		}
	}

}

// MARK:- Change Button Image.
extension IdeasDetailsController {
	// Change Like button Image.
	func changeLikeButtonImage(_ isLikeStatus: Bool) {
		if isLikeStatus == true {
			self.imgLike.image = UIImage(named: kImageLikeSelected)
		}
		else {
			self.imgLike.image = UIImage(named: kImageLikeDeselected)
		}
	}
	// Chnage Pinned Button Image
	func changePinnedImage(_ isPinnedStaus: Bool) {
		if isPinnedStaus == true {
			self.imgPinned.image = UIImage(named: kImagePinnedSelected)
		}
		else {
			self.imgPinned.image = UIImage(named: kImagePinnedDselected)
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

	// Chnage Report Abus Status
	func changeReportAbusImage(_ isReportAbusStatus: Bool) {
		if isReportAbusStatus == true {
			
			self.buttonReportAbus.setImage(UIImage(named: kReportAbusRedImage), for: UIControlState())

		} else {
			self.buttonReportAbus.setImage(UIImage(named: kReportAbusGreenImage), for: UIControlState())
			

		}

	}

	// Chnage Report Abus Status
	func changeReportAbusImageComment(_ isReportAbusStatus: Bool) {
		if isReportAbusStatus == true {
			self.buttonAlert.setImage(UIImage(named: kReportAbusRedImage), for: UIControlState())

		} else {
			self.buttonAlert.setImage(UIImage(named: kReportAbusGreenImage), for: UIControlState())
		}
	}
}

extension IdeasDetailsController {
	func setCommentButton() {
		commentBtn = UIButton(type: .system) // let preferred over var here
		commentBtn.frame = CGRect(x: UIScreen.main.bounds.width - 65.0, y: UIScreen.main.bounds.height - 48, width: 45.0, height: 45.0)
		commentBtn.tintColor = UIColor.clear
		commentBtn.setBackgroundImage(UIImage(named: "CommentsFlootingIcon"), for: UIControlState())
		commentBtn.addTarget(self, action: #selector(IdeasDetailsController.buttonComments(_:)), for: UIControlEvents.touchUpInside)
		NavigationHelper.helper.mainContainerViewController?.view.addSubview(self.commentBtn!)
	}

    
    
	@IBAction func buttonComments(_ sender: UIButton) {

		Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
			if isLogin == true {
                
                if Globals.sharedClient.userID != self.ideaDetailsObj.IdeaUserID!{
                    self.commentBtn.isUserInteractionEnabled = false
                    CommentPopupController.showAddOrClearPopUp(NavigationHelper.helper.mainContainerViewController!, didSubmit: { (text, popUp) in
                        // API Calling
                        APIHandler.handler.writeComment(forUser: INTEGER_FOR_KEY(kUserID), ideaID: self.ideaDetailsObj.IdeaID, comment:
                            
                            text.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed), success: { (response) in
                    
                            
                            
                            debugPrint("UserDetails Response -> \(response)")
                            popUp?.dismissAnimate()
                            self.getIdeaDetailsWithIdeaID(forIdeaID: self.ideaDetailsObj.IdeaID)
                            
                        }) { (error) in
                            debugPrint("Error \(error)")
                        }
                        
                    }) {
                        debugPrint("Finish")
                        self.commentBtn.isUserInteractionEnabled = true
                    }
                }
                else{
                    Toast.show(withMessage: USER_CAN_NOT_COMMENT)
                }
                }
            
                
                
				
		}
	}
}


extension IdeasDetailsController {
    func socialShare(_ sender: UIButton!, text: String) {
        var sharingItems = [AnyObject]()
        if let text = URL(string: text) {
            sharingItems.append(text as AnyObject)
        }
       
        
        if IS_IPAD() {
            let activityVC = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
            
            let nav = UINavigationController(rootViewController: activityVC)
            nav.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = nav.popoverPresentationController as UIPopoverPresentationController!
           
            popover?.sourceView = sender
         
            self.present(nav, animated: true, completion: nil)
            
            
        } else {
             let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityType.copyToPasteboard,UIActivityType.airDrop,UIActivityType.addToReadingList,UIActivityType.assignToContact,UIActivityType.postToTencentWeibo,UIActivityType.postToVimeo,UIActivityType.print,UIActivityType.saveToCameraRoll,UIActivityType.postToWeibo]
          self.present(activityViewController, animated: true, completion: nil)
        }
        
    }
}
