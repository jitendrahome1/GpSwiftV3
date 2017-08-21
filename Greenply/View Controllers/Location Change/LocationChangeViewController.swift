//
//  Location Change.swift
//  Greenply
//
//  Created by Jitendra on 11/25/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class LocationChangeViewController: BaseViewController, SeacrhDelegateList {

	@IBOutlet weak var textState: JATextField!
	@IBOutlet weak var textCity: JATextField!
	@IBOutlet weak var btnState: UIButton!
	@IBOutlet weak var btnCity: UIButton!
    
    
    var checkFirstTime: Bool!
	var arrStateList = [AnyObject]()
	var arrCityList = [AnyObject]()
	var pStateID: Int?
	var pCityID: Int?
    //var didSelectState:((state: Int, city: Int) -> ())!
    
    var didSelectState:((_ state: Int, _ city: Int, _ stateName: String, _ cityName: String) -> ())!
	override func viewDidLoad()
	{
		super.viewDidLoad()
        
	
	}
    
    

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
  
        self.getAllStateList()
        if let _ = self.pStateID{
           self.getCityWith(forStateID: self.pStateID!)
        }
       
   
        
        
        
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: true, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true)
        NavigationHelper.helper.enableSideMenuSwipe = false
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_CHANGE_LOCATION
//        if checkFirstTime == true {
//           NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: true, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true)
//        }
	}

	@IBAction func actionStateSelect(_ sender: UIButton) {
		if self.arrStateList.count > 0 {
			let searchVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: SearchTableViewController.self)) as! SearchTableViewController
			searchVC.arrPData = self.arrStateList
			searchVC.eStateCityStatus = .eStateSeleted
			searchVC.delegate = self
			self.navigationController?.pushViewController(searchVC, animated: true)
		} else {
			Toast.show(withMessage: STATE_ERROR)
		}
	}

	@IBAction func actionCitySelect(_ sender: UIButton) {
		if self.arrCityList.count > 0 {
			let searchVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: SearchTableViewController.self)) as! SearchTableViewController
			searchVC.arrPData = self.arrCityList
			searchVC.eStateCityStatus = .eCitySeleted
			searchVC.delegate = self
			self.navigationController?.pushViewController(searchVC, animated: true)
		} else {
			Toast.show(withMessage: CITY_ERROR)
		}

	}

	@IBAction func actionUpdate(_ sender: UIButton) {
        
        if (self.ValidateFields())
        {
            
              //  didSelectState(state: self.pStateID!, city: self.pCityID!)
            didSelectState!(self.pStateID!, self.pCityID!, self.textState.text!, self.textCity.text!)
                self.navigationController?.popViewController(animated: true)
           
        }
//		if (self.ValidateFields())
//		{
//            if checkFirstTime == true {
//                didSelectState(state: self.pStateID!, city: self.pCityID!)
//                self.navigationController?.popViewControllerAnimated(true)
//            } else {
//                didSelectState(state: self.pStateID!, city: self.pCityID!)
//                self.navigationController?.popViewControllerAnimated(true)
//            }
//        }
        
        // call change state api
	}

	// Mark:- SearchView  deletae
	// MARK:- State get delegate
	func didFinishSelectedState(forItems dictValue: [String: AnyObject]?)
	{
		self.textState.text = ""
		self.textCity.text = ""
		self.textState.text = dictValue!["name"] as? String
		self.pStateID = dictValue!["id"] as? Int
		//self.getCityWith(forStateID: self.pStateID!)

	}
	// MARK:- city get deleagte
	func didFinishSelectedCity(forItems dictValue: [String: AnyObject]?)
	{
		self.textCity.text = ""
		self.textCity.text = dictValue!["name"] as? String

		self.pCityID = dictValue!["id"] as? Int

	}

	// mark-  ValidateFields
	func ValidateFields() -> Bool
	{
		self.view.endEditing(true)
		var result = true

		if textState.text!.isBlank {
			Toast.show(withMessage: ENTER_STATE)

			result = false
		}
		else if textCity.text!.isBlank {
			Toast.show(withMessage: ENTER_CITY)
			result = false
		}
		return result
	}
}
// MARK:- API WORK
extension LocationChangeViewController {
// Get State List....
    
	func getAllStateList() {
		APIHandler.handler.getStates({ (response) in
			self.arrStateList.removeAll()
			self.arrStateList = response!["states"].arrayObject! as [AnyObject]

			print("\(response)")

		}) { (error) in

		}
	}
// get City with state id
	func getCityWith(forStateID stateID: Int?) {
         Helper.sharedClient.showLoaderWith(inview: self.view);
		APIHandler.handler.getCityList(forStateID: self.pStateID!, success: { (response) in
			self.arrCityList.removeAll()
			self.arrCityList = response!["cities"].arrayObject! as [AnyObject]
            DispatchQueue.main.async {
                Helper.sharedClient.removeLoader(inview: self.view);
   
            }

            
//            DispatchQueue.main.asynchronously(execute: {
//            
//                
//                
//            
//            })
			print("City Result\(response)")
		}) { (error) in
            DispatchQueue.main.async(execute: {
                Helper.sharedClient.removeLoader(inview: self.view);
            })
		}
	}
}

