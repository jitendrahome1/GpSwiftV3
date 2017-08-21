//
//  MenuViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/8/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {

	@IBOutlet weak var tableMenu: UITableView!
	var userType = String()
	var arrMenu = [AnyObject]()
	var arrMenuImage = [UIImage]()
	var viewControllerClass: AnyClass!
	var viewControllerTitle: String!
	var arrayMenuForAnimation = [AnyObject]()
	var isClosed = true
	var menuName: String!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.loadMenuSetup()
	
		NavigationHelper.helper.reloadData = {
			self.loadMenuSetup()
			self.tableMenu.reloadData()
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.

	}

	func loadMenuSetup()
	{
		// Mark: User Login OR Not
		if arrMenu.count > 0 {
			arrMenu.removeAll()
		}
		// NOTE: - When user Become Influencer open influencer Plist

		// menuName = INTEGER_FOR_KEY(kUserID) != 0 ? "influencer" : "user"
        
        if INTEGER_FOR_KEY(kUserID) != 0{
            
        let userStatus = OBJ_FOR_KEY(kUserTypeStatus)
            if userStatus as! Int == 1{
               menuName = "influencer"
            }else{
               menuName = "user"
            }
           
        }
        else{
         menuName = "Guest"
        }

		//menuName = INTEGER_FOR_KEY(kUserID) != 0 ? "user" : "Guest"

		if let path = Bundle.main.path(forResource: menuName, ofType: "plist") {
			let items: NSArray = NSArray(contentsOfFile: path)!
			for item in items {
				arrMenu.append(item as AnyObject)

			}
		}

	}

	// MARK: TableView Delegate and DataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return arrMenu.count
	}

	func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
		return IS_IPAD() ? 80 : 45
	}

	func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {

		let cell: MenuCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuCell.self)) as! MenuCell
		cell.labelMenuTitle.text = arrMenu[indexPath.row]["name"] as? String
		cell.imgMenu?.image = UIImage(named: (arrMenu[indexPath.row]["image"] as? String)!)
		cell.backgroundColor = UIColor.clear
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {

		viewControllerClass = NSClassFromString(SWIFT_CLASS_STRING(arrMenu[indexPath.row]["Class"]! as! String)!)
		viewControllerTitle = arrMenu[indexPath.row]["name"]! as! String
		openStoryboard(arrMenu[indexPath.row]["storyboard"] as? String)

	}
	// func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
	// cell.contentView.alpha = 0;
	//
	// UIView.animateWithDuration(0.2, delay: Double(indexPath.row) * 0.1, options: [.TransitionFlipFromTop], animations: {
	// cell.contentView.alpha = 1.0;
	// }, completion: nil)
	// }
	func openStoryboard(_ isMainStoryboard: String?) {

		// self.slideMenuController()?.closeRight()

		guard viewControllerClass != nil else {
			let alert = UIAlertController(title: "GreenPly", message: "Under Construction...", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
			return
		}

		NavigationHelper.helper.openSidePanel(false)

		if !NavigationHelper.helper.currentViewController!.isKind(of: viewControllerClass!) {
			if NavigationHelper.helper.contentNavController!.viewControllers.containsObject(viewControllerClass!).isPresent {
				if String(describing: viewControllerClass!) != String(describing: DashboardViewController.self) {
					NavigationHelper.helper.contentNavController!.viewControllers.remove(at: NavigationHelper.helper.contentNavController!.viewControllers.containsObject(viewControllerClass!).index!)
				}
			}
			if isMainStoryboard! == "Main"
			{
				self.navigateToViewController(mainStoryboard.instantiateViewController(withIdentifier: String(describing: viewControllerClass!)))
			}
			else if isMainStoryboard! == "Other" {
				self.navigateToViewController(otherStoryboard.instantiateViewController(withIdentifier: String(describing: viewControllerClass!)))
			}
			else if isMainStoryboard! == "Login" {
				self.navigateToViewController(loginStoryboard.instantiateViewController(withIdentifier: String(describing: viewControllerClass!)))
			}

			else if isMainStoryboard! == "Logout" {
				self.present(UIAlertController.showStandardAlertWith(kAppTitle, alertText: WANT_TO_LOGOUT, positiveButtonText: TEXT_YES, negativeButtonText: TEXT_NO, selected_: { (index) in
					if index == 1 {

                    APIHandler.handler.logoutWith(forUserID: Globals.sharedClient.userID, success: { (response) in
                       
                        print("Data \(response)")
                        REMOVE_OBJ_FOR_KEY(kUserID)
                        REMOVE_OBJ_FOR_KEY(kToken)
                        REMOVE_OBJ_FOR_KEY(kUserName)
                        REMOVE_OBJ_FOR_KEY(kUserEmail)
                        REMOVE_OBJ_FOR_KEY(kUserType)
                        REMOVE_OBJ_FOR_KEY(kUserAddress)
                        REMOVE_OBJ_FOR_KEY(kUserContactNumber)
                        REMOVE_OBJ_FOR_KEY(kUserAboutUS)
                        REMOVE_OBJ_FOR_KEY(kDisplayProfile)
                        REMOVE_OBJ_FOR_KEY(kCoverProfile)
                        REMOVE_OBJ_FOR_KEY(kUserLoginDetails)
                        REMOVE_OBJ_FOR_KEY(kCityId)
                        REMOVE_OBJ_FOR_KEY(kStateId)
                        APIManager.manager.header.removeValue(forKey: "access-token")
                        NavigationHelper.helper.reloadMenu()
            
                if NavigationHelper.helper.currentViewController!.isKind(of:DashboardViewController.self) {
                    
                            
                            NavigationHelper.helper.headerViewController?.lblNotification.isHidden = true
                            
                            
                                                    let locationVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: LocationChangeViewController.self)) as! LocationChangeViewController
                                                    locationVC.checkFirstTime = true

                            
                            locationVC.didSelectState = {state, city, stateName, cityName in
                                SET_OBJ_FOR_KEY(state as AnyObject, key: kStateId)
                                SET_OBJ_FOR_KEY(city as AnyObject, key: kCityId)
                                SET_OBJ_FOR_KEY(stateName as AnyObject, key: kSeletedState)
                                SET_OBJ_FOR_KEY(cityName as AnyObject, key: kSeletedCity)
                            }
                            
//                                                    locationVC.didSelectState = {state, city in
//                                                        SET_OBJ_FOR_KEY(state, key: kStateId)
//                                                        SET_OBJ_FOR_KEY(city, key: kCityId)
//                                                    }
                                                    NavigationHelper.helper.contentNavController?.pushViewController(locationVC, animated: true)
                            
                           // NavigationHelper.helper.contentNavController!.popToRootViewControllerAnimated(true)
                        }
                        else
                        {
                           
                            NavigationHelper.helper.headerViewController?.lblNotification.isHidden = true
                            
                            NavigationHelper.helper.contentNavController!.popToRootViewController(animated: true)
                        }
                        
                   


                        
                        }, failure: { (error) in
                        
                        })
						

						
					
                        
                    
					}
					}), animated: true, completion: nil)

			}

			else {
				self.present(UIAlertController.showStandardAlertWith(kAppTitle, alertText: "Work in Progress...", selected_: { (index) in

					}), animated: true, completion: nil)
			}
		}
	}

    
	func navigateToViewController(_ viewController: UIViewController) {

		if viewController.isKind(of: LoginViewController.self)
		{
			let loginControllerNavigation = loginStoryboard.instantiateViewController(withIdentifier: "LoginNavigationalController") as! UINavigationController
			self.present(loginControllerNavigation, animated: true, completion: nil)
		}
		else if viewController.isKind(of: DashboardViewController.self) {
			NavigationHelper.helper.contentNavController!.popToRootViewController(animated: true)
		}
        else if viewController.isKind(of: ProfileViewController.self) {
            if OBJ_FOR_KEY(kUserType) as! String == "seeker"  {
                let profileVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as!ProfileViewController
                NavigationHelper.helper.contentNavController!.pushViewController(profileVC, animated: true)
            }
            else if OBJ_FOR_KEY(kUserType) as! String == "influencer" && OBJ_FOR_KEY(kUserTypeStatus)?.integerValue == 0 {
                let profileVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as!ProfileViewController
                NavigationHelper.helper.contentNavController!.pushViewController(profileVC, animated: true)
            }
            else{
                let influncerProfileVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: InfluencerNewViewController.self)) as! InfluencerNewViewController
                
                NavigationHelper.helper.contentNavController!.pushViewController(influncerProfileVC, animated: true)
            }
        }
       else if viewController.isKind(of: BecomeInfluencerViewController.self) {
            if OBJ_FOR_KEY(kUserTypeStatus)!.intValue == 500 {
               let becomeInfluencerNavigation = mainStoryboard.instantiateViewController(withIdentifier: "BecomeInfluencerViewController") as! BecomeInfluencerViewController
             NavigationHelper.helper.contentNavController!.pushViewController(becomeInfluencerNavigation, animated: true)
           } else {
               let alert = UIAlertController(title: ALERT_TITLE, message: INFLUENCER_VERIFICATION, preferredStyle: UIAlertControllerStyle.alert)
               alert.addAction(UIAlertAction(title: OK, style: UIAlertActionStyle.default, handler: nil))
               self.present(alert, animated: true, completion: nil)
            }
        }
		else
		{
			NavigationHelper.helper.navController = NavigationHelper.helper.contentNavController! as UINavigationController
			// NavigationHelper.helper.currentViewController = viewController
			// NavigationHelper.helper.navigationController.pushViewController(viewController, animated: true)

			NavigationHelper.helper.contentNavController!.pushViewController(viewController, animated: true)
		}
	}

    
	func insertRow(forIndex index: Int) {
		guard !isClosed else {
			return
		}
		arrayMenuForAnimation.append(arrMenu[index])
		tableMenu.insertRows(at: [IndexPath.init(row: index, section: 0)], with: .top)
		let seconds = 0.2
		let delay = seconds * Double(NSEC_PER_SEC) // nanoseconds per seconds
		let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)

		DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
			// here code perfomed with delay
			if index + 1 != self.arrMenu.count {
				self.insertRow(forIndex: index + 1)
			}
		})
	}
}

