//
//  DasboardViewController.swift
//  Greenply
//
//  Created by Rupam Mitra on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class DashboardViewController: BaseCollectionViewController {

	var aboutUsArray: [AnyObject]?
	var meetTheExpertArray: [AnyObject]?
	var homeDecorIdeasArray: [AnyObject]?
	var arrIdeasList = [AnyObject]()
	var bannerImage: String?

	override func viewDidLoad() {
        
		super.viewDidLoad()
        
 
		self.collectionView?.backgroundColor = UIColorRGB(230.0, g: 230.0, b: 230.0)
        self.collectionView?.bounces = true
		aboutUsArray = Helper.sharedClient.readPlist(forName: "AboutUs")
		meetTheExpertArray = Helper.sharedClient.readPlist(forName: "MeettheProviders")
		homeDecorIdeasArray = Helper.sharedClient.readPlist(forName: "HomeDecorIdeas")
		setupCollectionView()
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: true, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false)
		
       
        
	}

    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        self.view.endEditing(true)
     
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: true, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false)
      
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_DASHBOARD
		NavigationHelper.helper.tabBarViewController!.showTabBar()
		NavigationHelper.helper.tabBarViewController?.clearSelection(exceptIndex: 0)
       
       
        
        
        if let _ = OBJ_FOR_KEY(kCityId){
            self.getDashboard()
        }
        else{
            let locationVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: LocationChangeViewController.self)) as! LocationChangeViewController
            locationVC.checkFirstTime = true
            
            locationVC.didSelectState = {state, city, stateName, cityName in
                SET_OBJ_FOR_KEY(state as AnyObject, key: kStateId)
                SET_OBJ_FOR_KEY(city as AnyObject, key: kCityId)
                SET_OBJ_FOR_KEY(stateName as AnyObject, key: kSeletedState)
                SET_OBJ_FOR_KEY(cityName as AnyObject, key: kSeletedCity)

//                
            }
        

            NavigationHelper.helper.contentNavController?.pushViewController(locationVC, animated: true)
        }
        
   
	}
    
    
    override func viewDidAppear(_ animated: Bool) {

        
    }
	@IBAction func homeDecorIdeas(_ sender: UIButton) {

		let IdealistVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: IdeaListingController.self)) as! IdeaListingController
		// NavigationHelper.helper.currentViewController = IdealistVC

		NavigationHelper.helper.contentNavController!.pushViewController(IdealistVC, animated: true)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewDidLayoutSubviews() {

		super.viewDidLayoutSubviews()

	}
}

extension DashboardViewController {

	func setupCollectionView() {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		self.collectionView?.collectionViewLayout = layout
	}

	// MARK: UICollectionViewDataSource methods
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		var cell: BaseCollectionViewCell?
		switch indexPath.row {
		case 0:
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DashboardBannerCollectionViewCell.self), for: indexPath) as! DashboardBannerCollectionViewCell
			cell?.datasource = bannerImage as AnyObject?
		case 1:
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DashboardHomeDecorIdeasCollectionViewCell.self), for: indexPath) as! DashboardHomeDecorIdeasCollectionViewCell
			// (cell as! DashboardHomeDecorIdeasCollectionViewCell).dataSource = homeDecorIdeasArray!

			(cell as! DashboardHomeDecorIdeasCollectionViewCell).dataSource = arrIdeasList
			// (cell as! DashboardHomeDecorIdeasCollectionViewCell).arrIdeasDataList = arrIdeasList

		case 2:
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DashboardMeetTheExpertCollectionViewCell.self), for: indexPath) as! DashboardMeetTheExpertCollectionViewCell
			(cell as! DashboardMeetTheExpertCollectionViewCell).dataSource = meetTheExpertArray!
		case 3:
            
            
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DashboardAboutUsCollectionViewCell.self), for: indexPath) as! DashboardAboutUsCollectionViewCell
            
            (cell as! DashboardAboutUsCollectionViewCell).getIndexValue = { (indexValue) in
                print("IndexPath\(indexValue)")
                if indexValue == 2{
                    Helper.sharedClient.checkUserAlredyLogin(inViewControler: self) { (isLogin) in
                        if isLogin == true {
                            let uploadIdeasVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: NewUploadIdeaViewController.self)) as! NewUploadIdeaViewController
                            NavigationHelper.helper.contentNavController!.pushViewController(uploadIdeasVC, animated: true)
                            }
                            
                        }
                    }
                }
                
            
			(cell as! DashboardAboutUsCollectionViewCell).dataSource = aboutUsArray!

		default:
			debugPrint("No cell")
		}
		return cell!
	}

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		switch indexPath.row {
		case 0:
			return CGSize(width: SCREEN_WIDTH, height: SCREEN_WIDTH / 3.0)
		case 1:
			return CGSize(width: SCREEN_WIDTH, height: IS_IPAD() ? 330 : 200) // 250
		case 2:
			return CGSize(width: SCREEN_WIDTH, height: IS_IPAD() ? 330 : 180)
		case 3:
			return CGSize(width: SCREEN_WIDTH, height: IS_IPAD() ? 260 : 160)
			// return CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds) , 180)
		default:
			return CGSize(width: SCREEN_WIDTH, height: IS_IPAD() ? 280 : 220)
		}
	}
}

extension DashboardViewController {

	func getDashboard() {
		APIHandler.handler.getDashboard({ (response) in
           
            print("Dashbord Respose\(response)")
            for value in (response?["Idea"].arrayObject!)! {
                let idesListObj = IdeaListing(withDictionary: value as! [String: AnyObject])
                self.arrIdeasList.append(idesListObj)
            }
            let notificationCount = response?["totalNotification"].intValue
            if notificationCount! > 0{
                NavigationHelper.helper.headerViewController!.lblNotification.isHidden = false
                NavigationHelper.helper.headerViewController!.lblNotification.text = String(describing: notificationCount!)
            }else{
                NavigationHelper.helper.headerViewController!.lblNotification.isHidden = true
            }
			self.bannerImage = response?["Banner"]["image"].stringValue
			self.collectionView?.reloadData()
		}) { (error) in

		}
	}
}
