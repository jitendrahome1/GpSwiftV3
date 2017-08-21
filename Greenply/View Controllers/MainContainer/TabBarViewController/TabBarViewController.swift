//
//  MenuViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/9/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {

	@IBOutlet var buttonTabCollection: [TabButton]!
	@IBOutlet var bottomBorder: UIImageView!
	var lastIndex: Int = 0
   
	override func viewDidLoad() {
		super.viewDidLoad()
  
		NavigationHelper.helper.tabBarViewController = self
//		NavigationHelper.helper.tabBarViewController = self

		for (index, button) in buttonTabCollection.enumerated() {
			button.didTap = {
				button.selected = true
				if index != 3 {
					self.clearSelection(exceptIndex: index)
				} else {
					button.selected = false
				}
				self.moveToViewController(index)
			}
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func clearSelection(exceptIndex exceptionIndex: Int?) {
		for (index, button) in self.buttonTabCollection.enumerated() {

			if index != exceptionIndex {
				button.selected = false
			}
			else {
				button.selected = true
				self.lastIndex = exceptionIndex!
			}
		}
	}

	func showTabBar() {
		NavigationHelper.helper.mainContainerViewController!.nsBtottomConstTabBar.constant = 0
		NavigationHelper.helper.mainContainerViewController!.view.layoutIfNeeded()
//		NavigationHelper.helper.mainContainerViewController?.tabBarControllerView.transform = CGAffineTransformIdentity
	}
	func hideTabBar() {
		NavigationHelper.helper.mainContainerViewController!.nsBtottomConstTabBar.constant = -(NavigationHelper.helper.mainContainerViewController!.NSConstantTapBarHeight.constant)
		NavigationHelper.helper.mainContainerViewController!.view.layoutIfNeeded()
//		NavigationHelper.helper.mainContainerViewController?.mainContainer.translatesAutoresizingMaskIntoConstraints = true
//		NavigationHelper.helper.mainContainerViewController?.tabBarControllerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(NavigationHelper.helper.mainContainerViewController!.tabBarControllerView.frame))
	}

	// MARK: Move To ViewController Function
	func moveToViewController(_ index: Int) {
		NavigationHelper.helper.headerViewController?.hideUnhideSearch()
		switch index {
		case 0:

			if NavigationHelper.helper.contentNavController!.viewControllers.containsObject(DashboardViewController).isPresent {

				if APIManager.manager.isReachable() {
					NavigationHelper.helper.contentNavController!.popToRootViewController(animated: true)
				}

				else {
					let noNetWorkVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: NoNetWorkViewController.self)) as! NoNetWorkViewController

					NavigationHelper.helper.contentNavController!.present(noNetWorkVC, animated: true, completion: nil)

					// reTry action
					noNetWorkVC.didTapRetry = { (sender) in
						if APIManager.manager.isReachable() {
							NavigationHelper.helper.contentNavController?.dismiss(animated: true, completion: nil)
						}

					}
				}
			}
                
             
			else {
				if APIManager.manager.isReachable() {
					let dashboardVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: DashboardViewController.self)) as!DashboardViewController
					NavigationHelper.helper.contentNavController!.pushViewController(dashboardVC, animated: true)
				}
				else {
					let noNetWorkVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: NoNetWorkViewController.self)) as! NoNetWorkViewController
					NavigationHelper.helper.contentNavController!.present(noNetWorkVC, animated: true, completion: nil)

					// reTry action
					noNetWorkVC.didTapRetry = { (sender) in
						if APIManager.manager.isReachable() {
							NavigationHelper.helper.contentNavController?.dismiss(animated: true, completion: nil)
						}

					}

				}

			}
			self.lastIndex = index
		case 1:

			let ideaListingVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: IdeaListingController.self)) as!IdeaListingController

			if !NavigationHelper.helper.contentNavController!.viewControllers.containsObject(IdeaListingController).isPresent {

				NavigationHelper.helper.contentNavController!.pushViewController(ideaListingVC, animated: true)

			}
			else {

				let allViewController: [UIViewController] = NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]

				for aviewcontroller: UIViewController in allViewController
				{
					if aviewcontroller.isKind(of: IdeaListingController.self)
					{
						// self.navigationController?.popToViewController(aviewcontroller, animated: true)

						NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
					}
				}

			}
			self.lastIndex = index
		case 2:
            
            if let _ =  OBJ_FOR_KEY(kCityId){
                let meetExpertVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: MeetAnExpertViewController.self)) as!MeetAnExpertViewController
                if !NavigationHelper.helper.contentNavController!.viewControllers.containsObject(MeetAnExpertViewController).isPresent {
                    
                    NavigationHelper.helper.contentNavController!.pushViewController(meetExpertVC, animated: true)
                }
                else {
                    let allViewController: [UIViewController] = NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
                    
                    for aviewcontroller: UIViewController in allViewController
                    {
                        if aviewcontroller.isKind(of: MeetAnExpertViewController.self)
                        {
                            // self.navigationController?.popToViewController(aviewcontroller, animated: true)
                            
                            NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                        }
                    }
                    
                }
            
            }
            else{
                let locationVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: LocationChangeViewController.self)) as! LocationChangeViewController
                locationVC.checkFirstTime = true

                locationVC.didSelectState = {state, city, stateName, cityName in
                    SET_OBJ_FOR_KEY(state as AnyObject, key: kStateId)
                    SET_OBJ_FOR_KEY(city as AnyObject, key: kCityId)
                    SET_OBJ_FOR_KEY(stateName as AnyObject, key: kSeletedState)
                    SET_OBJ_FOR_KEY(cityName as AnyObject, key: kSeletedCity)
                }
                
//                locationVC.didSelectState = {state, city in
//                    SET_OBJ_FOR_KEY(state, key: kStateId)
//                    SET_OBJ_FOR_KEY(city, key: kCityId)
//                    
//                }
          NavigationHelper.helper.contentNavController?.pushViewController(locationVC, animated: true)
                
            }
            
			   
			self.lastIndex = index
		case 3:
            
            
            if INTEGER_FOR_KEY(kUserID) != 0 {
                
                if OBJ_FOR_KEY(kUserType) as! String == "seeker"  {
                    let profileVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as!ProfileViewController
                    NavigationHelper.helper.contentNavController!.pushViewController(profileVC, animated: true)
                }
                else if OBJ_FOR_KEY(kUserType) as! String == "influencer" && OBJ_FOR_KEY(kUserTypeStatus)!.intValue == 0 {
                    let profileVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as!ProfileViewController
                    NavigationHelper.helper.contentNavController!.pushViewController(profileVC, animated: true)
                }
                else{
                    let influncerProfileVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: InfluencerNewViewController.self)) as! InfluencerNewViewController
                    
                    NavigationHelper.helper.contentNavController!.pushViewController(influncerProfileVC, animated: true)
                }
                
                
            }
            else{
                self.present(UIAlertController.showStandardAlertWith(kAppTitle, alertText: WANT_TO_LOGIN, positiveButtonText: TEXT_YES, negativeButtonText: TEXT_NO, selected_: { (index) in
                    if index == 1 {
                        let loginControllerNavigation = loginStoryboard.instantiateViewController(withIdentifier: "LoginNavigationalController") as! UINavigationController
                        self.present(loginControllerNavigation, animated: true, completion: nil)
                    } else {
                        self.clearSelection(exceptIndex: self.lastIndex)
                    }
                }), animated: true, completion: nil)
            }
            
		default:
			debugPrint("No Selction")
		}
	}

}
