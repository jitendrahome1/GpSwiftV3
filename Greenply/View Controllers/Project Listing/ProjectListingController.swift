//
//  ProjectListingController.swift
//  Greenply
//
//  Created by Shatadru Datta on 30/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

enum eButtonProject {
	case eshowButton
	case eHideButton
}

enum ePortFolioListing {
	case ePortfolioListingTitle
	case eMyPortfolioTitle
}

class ProjectListingController: BaseViewController, HeaderButtonDeleagte {

	var influencerID: Int?
        var isSearch: Bool!
        var strVal = ""
       var arrSearchList = [AnyObject]()
	@IBOutlet weak var collectionViewProjList: UICollectionView!
	var buttonAddProjectStatus: eButtonProject = .eshowButton
	var ePortfolioTitleStatus: ePortFolioListing = .ePortfolioListingTitle
	var pUserID: Int?

	// Change letter
	var pageno = 0
	var pageSize = 8
    var totalCount : Int!
	var arrPortfolioDetailsList = [AnyObject]()
	override func viewDidLoad() {
		super.viewDidLoad()
           isSearch = false
        
		NavigationHelper.helper.headerViewController!.lblNotification.text = ""
		NavigationHelper.helper.tabBarViewController!.hideTabBar()
          NavigationHelper.helper.headerViewController?.textSearch.delegate = self
        
        
		setupCollectionView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        arrPortfolioDetailsList.removeAll()
        pageno = 0
        pageSize =  8
        if ePortfolioTitleStatus == .ePortfolioListingTitle {
			  self.getMyPortfolioLsit(forUserID: pUserID)
            NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_PORTFOLIO_LISTING
			 NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWithIdeas(isHideBackButton: false, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false, isHideSearchButton: false)
            }
		else {
            self.getMyPortfolioLsit(forUserID: Globals.sharedClient.userID)

			NavigationHelper.helper.headerViewController?.delegateButton = self
			NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_MY_PORTFOLIO_LISTING
			
            
             NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWithIdeas(isHideBackButton: false, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false, isHideSearchButton: false)
			NavigationHelper.helper.headerViewController?.addHeaderButton(kPluseButton)
	
		}
        
        
	}

	override func viewDidLayoutSubviews() {

		super.viewDidLayoutSubviews()
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NavigationHelper.helper.headerViewController?.textSearch.resignFirstResponder()
        NavigationHelper.helper.headerViewController?.imgBorder.alpha = 0
   
        NavigationHelper.helper.headerViewController?.buttonSearch.isSelected = false
    }

}

extension ProjectListingController: UICollectionViewDataSource, UICollectionViewDelegate {

	func setupCollectionView() {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = IS_IPAD() ? 20.0 : 10.0
		collectionViewProjList.collectionViewLayout = layout
	}

	// MARK: UICollectionViewDataSource methods
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
        if isSearch == true {
            return arrSearchList.count
        } else {
            return arrPortfolioDetailsList.count
        }
        
      
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProjListCollectionViewCell.self), for: indexPath) as! ProjListCollectionViewCell
        
        cell.shareButtonHandler = { (pButton, shareURL) in
        // share Code
            self.socialShare(pButton, text: shareURL!)
        }
		if buttonAddProjectStatus == .eshowButton {
			cell.buttonAdd.isHidden = false

			cell.editButtonHandler = { (projectID) in
                let userStatus = OBJ_FOR_KEY(kUserTypeStatus) as! Int
                if userStatus  == 1 {
				self.pushUploadIdeaVCWith(forProjectID: projectID)
                }else{
                     Toast.show(withMessage: ONLY_INFLUENCER_EDIT_IMAGE)
                }
				print("id\(projectID)")
			}
		}
		else {
			cell.buttonAdd.isHidden = true
		}
		if arrPortfolioDetailsList.count > 0 {
            
            if isSearch == true {
            	cell.datasource = arrSearchList[indexPath.row]
            }else{
              	cell.datasource = arrPortfolioDetailsList[indexPath.row]
            }
            
		
		}
		cell.layer.cornerRadius = IS_IPAD() ? 15.0 : 10.0
		cell.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
		cell.layer.borderColor = UIColor(red: 210.0 / 255.0, green: 210.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0).cgColor
		cell.layer.masksToBounds = true
		return cell
	}
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //    let pageWidth = self.collectionViewIdeasList.frame.size.width
        //    let currentPage = self.collectionViewIdeasList.contentOffset.x / pageWidth
        let x = self.collectionViewProjList.contentOffset.x
        let w =  self.collectionViewProjList.bounds.size.width
        let currentPage = Int(ceil(x/w))
        
        if let _ = totalCount{
            if totalCount > self.arrPortfolioDetailsList.count {
                if currentPage != self.arrPortfolioDetailsList.count - 1 {
                    pageno = self.arrPortfolioDetailsList.count/pageSize + 1  //calculating pageno for load more data
                    
                    
                    if ePortfolioTitleStatus == .ePortfolioListingTitle {
                        self.getMyPortfolioLsit(forUserID: pUserID)
                        }
                        else{
                            self.getMyPortfolioLsit(forUserID: Globals.sharedClient.userID)
                        }
                      
                  
                    
                }
                
            }
            
        }
        
        
    }
    
//    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        if totalCount > self.arrPortfolioDetailsList.count {
//            if indexPath.item == self.arrPortfolioDetailsList.count - 1 {
//                pageno = self.arrPortfolioDetailsList.count/pageSize + 1  //calculating pageno for load more data
//                self.getMyPortfolioLsit(forUserID: Globals.sharedClient.userID)
//            }
//        }
//    }

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		return CGSize(width: (SCREEN_WIDTH / 2 - (IS_IPAD() ? 20.0 : 15.0)), height: (SCREEN_WIDTH / 2 - (IS_IPAD() ? 20.0 : 15.0)))
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		let cell = collectionView.cellForItem(at: indexPath) as! ProjListCollectionViewCell
		let ProjectDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: ProjectDetailsController.self)) as! ProjectDetailsController
		let objPortfolioList = cell.datasource
		ProjectDetailsVC.objPortfolioDetails = objPortfolioList as! Portfolio
		NavigationHelper.helper.contentNavController!.pushViewController(ProjectDetailsVC, animated: true)
	}
}
// MARK: - APi Calling

extension ProjectListingController {

	// MARK: - UserID chnage to meet and expert ID when we get.
	/* NOTE: - Rember For testing we are passsing login user ID , But when we get Meet an ExpertID , then we passed login userID as meet an ExperID
	 */
	func getMyPortfolioLsit(forUserID userID: Int?) {

		//arrPortfolioDetailsList.removeAll()
		// if INTEGER_FOR_KEY(kUserID) != 0 {
		APIHandler.handler.getMyPortfolioListing(userID!, pageNumber: pageno, perPage: pageSize,
			success: { (response) in
				debugPrint("Project List ==>\(response)")
                self.totalCount = response?["totalCount"].intValue
				let notificationCount = response?["totalNotification"].intValue
				if notificationCount! > 0 {
					NavigationHelper.helper.headerViewController!.lblNotification.isHidden = false
					NavigationHelper.helper.headerViewController!.lblNotification.text = String(describing: notificationCount)
				} else {
					NavigationHelper.helper.headerViewController!.lblNotification.isHidden = true
				}
                    if let arrResult = response?["portfolios"].arrayObject
                    {
                    for value in arrResult {
					let objPortfolio = Portfolio(withDictionary: value as! [String: AnyObject])
					self.arrPortfolioDetailsList.append(objPortfolio)
					}
					self.collectionViewProjList.reloadData()
					debugPrint("Portfolio Details==>\(self.arrPortfolioDetailsList)")
				}
				else {
					Toast.show(withMessage: NO_RECORDS_FOUND)
				}

		}) { (error) in

		}
	}
}



// MARK:- Header button Delegate
extension ProjectListingController {
	func didTapMenuButton(_ strButtonType: String) {
		if strButtonType == kPluseButton {
			let userStatus = OBJ_FOR_KEY(kUserTypeStatus)?.int32Value
			if userStatus == 1 {
				
                let editPortfolioVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: UploadProjectNewViewController.self)) as! UploadProjectNewViewController
             
                editPortfolioVC.eProjectStatus = .eAddProject
                NavigationHelper.helper.contentNavController!.pushViewController(editPortfolioVC, animated: true)
                

 
                
            }else{
                Toast.show(withMessage: ONLY_INFLUENCER_UPLOAD_IMAGE)
            }
		}
	}

	// MARK:- Function.
	// Push to upload projet view controller Function.
	func pushUploadIdeaVCWith(forProjectID projectID: Int?) {
        
        let editPortfolioVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: UploadProjectNewViewController.self)) as! UploadProjectNewViewController
        editPortfolioVC.projectID = projectID
        editPortfolioVC.eProjectStatus = .eEditProject
        NavigationHelper.helper.contentNavController!.pushViewController(editPortfolioVC, animated: true)
     
    
        
//		let editPortfolioVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(AddPortfolioViewController)) as! AddPortfolioViewController
//		editPortfolioVC.projectID = projectID
//		editPortfolioVC.eProjectStatus = .eProjectDetails
//		NavigationHelper.helper.contentNavController!.pushViewController(editPortfolioVC, animated: true)
 
 
 
	}

    // Share Function.
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
            _ = sender.convert(CGPoint(x: sender.frame.midX, y: sender.frame.maxY), to: self.view)
               popover?.sourceView = sender
            self.present(nav, animated: true, completion: nil)
        } else {
            let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityType.copyToPasteboard,UIActivityType.airDrop,UIActivityType.addToReadingList,UIActivityType.assignToContact,UIActivityType.postToTencentWeibo,UIActivityType.postToVimeo,UIActivityType.print,UIActivityType.saveToCameraRoll,UIActivityType.postToWeibo]
             self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

// MARK:- TextFieldDelegate & Search Method
extension ProjectListingController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isSearch = true
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            strVal = String(strVal.characters.dropLast())
        } else {
            strVal = strVal + string
        }
        if strVal.isEmpty {
            isSearch = false
            self.collectionViewProjList.reloadData()
        } else {
            isSearch = true
            self.filterContentForSearchText(strVal as NSString)
        }
        return true
    }
    
    func filterContentForSearchText(_ searchText:NSString)
    {
        
        arrSearchList = self.arrPortfolioDetailsList.filter { (obj) -> Bool in
            let objProjectListing = obj as! Portfolio
            if (objProjectListing.projectName!.lowercased().contains(searchText.lowercased as String)) {
                return true
            } else {
                return false
            }
        }
        
        self.collectionViewProjList.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isSearch = false
        textField.resignFirstResponder()
        return true
    }
}


