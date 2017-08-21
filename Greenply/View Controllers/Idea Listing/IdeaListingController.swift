//
//  IdeaListingController.swift
//  Greenply
//
//  Created by Shatadru Datta on 30/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
enum eButtonEdit {
	case eButtonShow
	case eButtonHide
}
enum eIdeaListAPI {
	case eCallIdeaListApiWitUserID
	case eNotCallIdeaListApi
    case eAllIdeaListApi
}
enum eIdeaListTitle {
	case eIdeaListingTitle
	case eMyIdeaTitle
}
class IdeaListingController: BaseViewController, HeaderButtonDeleagte {
	var eButtonEditStatus: eButtonEdit = .eButtonHide
	var eIdeaListApiCallStatus: eIdeaListAPI = .eAllIdeaListApi
	var eIdeaListingTitleStaus: eIdeaListTitle = .eIdeaListingTitle
	@IBOutlet weak var collectionViewIdeasList: UICollectionView!
	var arrIdeasList = [AnyObject]()
    var arrSearchList = [AnyObject]()
    var isSearch: Bool!
    var strVal = ""
    var pageno: Int!
    var pageSize: Int!
    var totalCount: Int!
	override func viewDidLoad() {
		super.viewDidLoad()
    }
    func uiSetup(){
       pageno = 0
      pageSize =  8
        NavigationHelper.helper.headerViewController!.lblNotification.text = ""
        isSearch = false
        NavigationHelper.helper.headerViewController?.delegateButton = self
        NavigationHelper.helper.headerViewController?.textSearch.delegate = self
        if self.eIdeaListingTitleStaus == .eIdeaListingTitle {
            NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_IDEA_LISTING
        }
        else {
            NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_MY_Idea
            
        }
        
        if self.eButtonEditStatus == .eButtonHide {
            NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWithIdeas(isHideBackButton: false, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false, isHideSearchButton: false)
            
            NavigationHelper.helper.tabBarViewController!.showTabBar()
           
            
        }
        else if self.eButtonEditStatus == .eButtonShow {
            NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWithIdeas(isHideBackButton: false, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false, isHideSearchButton: false)
            NavigationHelper.helper.headerViewController?.addHeaderButton(kPluseButton)
            NavigationHelper.helper.tabBarViewController!.hideTabBar()
            
        }
        
        if self.eIdeaListApiCallStatus == .eNotCallIdeaListApi {
            // not call api/
            
           
        }
        NavigationHelper.helper.tabBarViewController?.clearSelection(exceptIndex: 1)
        
    }


	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)
        self.uiSetup()
       
        
        if (self.eIdeaListApiCallStatus == .eNotCallIdeaListApi) {
          self.collectionViewIdeasList.reloadData()
        }
        else if(self.eIdeaListApiCallStatus == .eCallIdeaListApiWitUserID){
             self.arrIdeasList.removeAll()
        self.getMyIdeaList(forUserID: Globals.sharedClient.userID)
        }
        else{
            self.arrIdeasList.removeAll()
            self.getIdeaListingList()
        }
        
        
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NavigationHelper.helper.headerViewController?.textSearch.resignFirstResponder()
        NavigationHelper.helper.headerViewController?.imgBorder.alpha = 0
     //  NavigationHelper.helper.headerViewController?.leadingImgBorder.constant = 180
        NavigationHelper.helper.headerViewController?.buttonSearch.isSelected = false
    }
    
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		// NavigationHelper.helper.tabBarViewController.unSelectedAllButton()
		// NavigationHelper.helper.tabBarViewController.buttonIdea.selected = true

	}
}

extension IdeaListingController: UICollectionViewDataSource, UICollectionViewDelegate {

	func setupCollectionView() {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = IS_IPAD() ? 20.0 : 10.0
		collectionViewIdeasList.collectionViewLayout = layout
	}

	// MARK: UICollectionViewDataSource methods
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearch == true {
            return arrSearchList.count
        } else {
            return arrIdeasList.count
        }
		
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: IdeasListCollectionViewCell.self), for: indexPath) as! IdeasListCollectionViewCell
		if eButtonEditStatus == .eButtonHide {
			cell.buttonEdit.isHidden = true
		}
		else if eButtonEditStatus == .eButtonShow {
			cell.buttonEdit.isHidden = false
			cell.editButtonHandler = { (ideaID) in
				self.pushUploadIdeaVCWith(forIdeaID: ideaID)
			}
		}

		if arrIdeasList.count > 0 {
            if isSearch == true {
                cell.datasource = arrSearchList[indexPath.row]
            } else {
                cell.datasource = arrIdeasList[indexPath.row]
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
        let x = self.collectionViewIdeasList.contentOffset.x
        let w =  self.collectionViewIdeasList.bounds.size.width
        let currentPage = Int(ceil(x/w))
        
        if let _ = totalCount{
        if totalCount > self.arrIdeasList.count {
        if currentPage != self.arrIdeasList.count - 1 {
        pageno = self.arrIdeasList.count/pageSize + 1  //calculating pageno for load more data
        
        
        if self.eIdeaListingTitleStaus == .eIdeaListingTitle {
        self.getIdeaListingList()
        }
        else{
        self.getMyIdeaList(forUserID: Globals.sharedClient.userID)
        
            }
        
            }
        
            }
        
        }
        
        
    }

//    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        
//        if !(self.eIdeaListApiCallStatus == .eNotCallIdeaListApi) {
//            if totalCount > self.arrIdeasList.count {
//                if indexPath.item == self.arrIdeasList.count - 1 {
//                    pageno = self.arrIdeasList.count/pageSize + 1  //calculating pageno for load more data
//                    self.getIdeaListingList()
//                }
//            }
//        }
//        
//       
//    }
    

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		return CGSize(width: (SCREEN_WIDTH / 2 - (IS_IPAD() ? 20.0 : 15.0)), height: (SCREEN_WIDTH / 2 - (IS_IPAD() ? 20.0 : 15.0)))
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		let cell = collectionView.cellForItem(at: indexPath) as! IdeasListCollectionViewCell
		let IdeaDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: IdeasDetailsController.self)) as! IdeasDetailsController
//        if eButtonEditStatus == .eButtonShow
//        {
//            IdeaDetailsVC.isCommentBtnShowHide = false
//            
//        }
     
		let objIdeaList = cell.datasource
		IdeaDetailsVC.ideaDetailsObj = objIdeaList as! IdeaListing

		NavigationHelper.helper.contentNavController!.pushViewController(IdeaDetailsVC, animated: true)
	}
}

// MARK:- Function.
extension IdeaListingController {
	// Push to UploadIdeasTableViewController Function.
	func pushUploadIdeaVCWith(forIdeaID pIdeaID: Int?) {

        
        let uploadIdeasVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: NewUploadIdeaViewController.self)) as! NewUploadIdeaViewController
        uploadIdeasVC.eUloadIdeaStatus = .eIdeaDetails
//        debugPrint("IdeaID \(pIdeaID!)")
     uploadIdeasVC.IdeaID = pIdeaID!
        NavigationHelper.helper.contentNavController!.pushViewController(uploadIdeasVC, animated: true)
        

 
	
    }
}


//MARK:- API Calling
extension IdeaListingController {
	func getIdeaListingList() {

		//self.arrIdeasList.removeAll()
        APIHandler.handler.getIdeaListingList(pageno, pageSize: pageSize, success: { (response) in
			debugPrint("Idea List \(response))")
            self.totalCount = response!["total"].intValue
            let notificationCount = response!["totalNotification"].intValue
            if notificationCount > 0 {
                NavigationHelper.helper.headerViewController!.lblNotification.isHidden = false
                NavigationHelper.helper.headerViewController!.lblNotification.text = String(notificationCount)
            }
            
            else {
                NavigationHelper.helper.headerViewController!.lblNotification.isHidden = true
            }
            if (response!["Idea"].arrayObject?.count)! > 0 {
			
                for value in response!["Idea"].arrayObject! {
                
                print("value\(value)")
                
				let idesListObj = IdeaListing(withDictionary: value as! [String: AnyObject])
				self.arrIdeasList.append(idesListObj)
			}
            self.noResult(forArrData: response!["Idea"].arrayObject! as [AnyObject], lableText: NO_IDEA)
           
            }
            
            else {
              self.noResult(forArrData: response!["Idea"].arrayObject! as [AnyObject], lableText: NO_IDEA)
            }
			self.collectionViewIdeasList.reloadData()
		}) { (error) in
            if error!._code == NSURLErrorTimedOut {
//                self.noResult(forArrData: self.arrIdeasList, lableText: NO_IDEA)
            Toast.show(withMessage: REQUEST_TIME_OUT)
            }
        
        }
	}

	// Mark:- Get Idea List With UserID,
	func getMyIdeaList(forUserID userID: Int?) {
		//self.arrIdeasList.removeAll()
		APIHandler.handler.getIdeaListingWithUserID(forUserID: userID!,pageno: pageno, pageSize: pageSize, success: { (response) in
            self.totalCount = response!["total"].intValue
            let notificationCount = response!["totalNotification"].intValue
            if notificationCount > 0{
                NavigationHelper.helper.headerViewController!.lblNotification.isHidden = false
                NavigationHelper.helper.headerViewController!.lblNotification.text = String(notificationCount)
            }else{
                NavigationHelper.helper.headerViewController!.lblNotification.isHidden = true
            }
			if (response!["Idea"].arrayObject?.count)! > 0 {

				for value in response!["Idea"].arrayObject! {
					let idesListObj = IdeaListing(withDictionary: value as! [String: AnyObject])
					self.arrIdeasList.append(idesListObj)
				}
				debugPrint("Portfolio Details==>\(self.arrIdeasList)")
                
                      self.noResult(forArrData: response!["Idea"].arrayObject! as [AnyObject], lableText: NO_IDEA)
                
			}
			else {
                self.noResult(forArrData: response!["Idea"].arrayObject! as [AnyObject], lableText: NO_IDEA)
				//Toast.show(withMessage: NO_RECORDS_FOUND)
			}
			self.collectionViewIdeasList.reloadData()
		}) { (error) in

		}
	}
}

// MARK:- Header Button Delegate
extension IdeaListingController {
	func didTapMenuButton(_ strButtonType: String) {
		if strButtonType == kPluseButton {

            let uploadIdeasVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: NewUploadIdeaViewController.self)) as! NewUploadIdeaViewController
            uploadIdeasVC.eUloadIdeaStatus = .eUploadIdea
            NavigationHelper.helper.contentNavController!.pushViewController(uploadIdeasVC, animated: true)
            
            /*
            let uploadIdeasVC = otherStoryboard.instantiateViewControllerWithIdentifier(String(UploadIdeasTableViewController)) as! UploadIdeasTableViewController
			uploadIdeasVC.eUloadIdeaStatus = .eUploadIdea
			NavigationHelper.helper.contentNavController!.pushViewController(uploadIdeasVC, animated: true)
		
        */
        }
        
        else {
            
		}
	}
}

// MARK:- TextFieldDelegate & Search Method
extension IdeaListingController: UITextFieldDelegate {
    
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
            self.collectionViewIdeasList.reloadData()
        } else {
            isSearch = true
            self.filterContentForSearchText(strVal as NSString)
        }
        return true
    }
    
    func filterContentForSearchText(_ searchText:NSString)
    {
        
        arrSearchList = self.arrIdeasList.filter { (obj) -> Bool in
            let objIdeaListing = obj as! IdeaListing
            if (objIdeaListing.ideaName!.lowercased().contains(searchText.lowercased as String)) {
                return true
            } else {
                return false
            }
        }
   
        self.collectionViewIdeasList.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isSearch = false
        textField.resignFirstResponder()
        return true
    }
}


