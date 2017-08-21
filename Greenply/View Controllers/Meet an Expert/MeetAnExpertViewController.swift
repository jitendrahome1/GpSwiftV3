//
//  MeetAnExpertViewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 29/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//


import UIKit

class MeetAnExpertViewController: BaseTableViewController {

	var arrInfluencerList = [AnyObject]()
	var solutionType = ""
	var arrSearchList = [AnyObject]()
	var isSearch: Bool!
	var strVal = ""
    var lat: Double!
    var lon: Double!

	override func viewDidLoad() {
		super.viewDidLoad()
		NavigationHelper.helper.headerViewController!.lblNotification.text = ""
		isSearch = false
		if solutionType == "" {
			solutionType = "influencer"
		}
    
		self.tableView.reloadData()
		self.tableView.backgroundView = nil
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
  

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
            self.getAllInfluencerList()
        NavigationHelper.helper.headerViewController?.textSearch.delegate = self
        NavigationHelper.helper.headerViewController?.btnFiltter.addTarget(self, action: #selector(self.didFilterAction(_:)), for: UIControlEvents.touchUpInside)
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWithIdeas(isHideBackButton: false, isHideFilterButton: false, isHidenotification: false, isHideMenuButton: false, isHideSearchButton: false)
		// NavigationHelper.helper.headerViewController?.addHeaderButton(kFilterBttton)
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_MEET_EXPERT
		NavigationHelper.helper.tabBarViewController!.showTabBar()
		NavigationHelper.helper.tabBarViewController?.clearSelection(exceptIndex: 2)
		self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)

	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

	override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NavigationHelper.helper.headerViewController?.textSearch.resignFirstResponder()
		NavigationHelper.helper.headerViewController?.imgBorder.alpha = 0
		//NavigationHelper.helper.headerViewController?.leadingImgBorder.constant = 130
		NavigationHelper.helper.headerViewController?.buttonSearch.isSelected = false
          Helper.sharedClient.removeLoader(inview: self.view)
	}
    
    func didFilterAction(_ sender: UIButton) {
        let filterVC = otherStoryboard.instantiateViewController(withIdentifier: String(describing: FilterViewController.self)) as! FilterViewController
        filterVC.solutionType = solutionType
        filterVC.didpoptoInfluencer = {array in
            let notificationCount = array["totalNotification"].intValue
            if notificationCount > 0 {
                NavigationHelper.helper.headerViewController!.lblNotification.isHidden = false
                NavigationHelper.helper.headerViewController!.lblNotification.text = String(notificationCount)
            } else {
                NavigationHelper.helper.headerViewController!.lblNotification.isHidden = true
            }
            if array["total"] == 0 {
                Toast.show(withMessage: NO_RECORDS_FOUND)
            }
            self.arrInfluencerList.removeAll()
            for value in array["User"].arrayObject! {
                let objInfluencer = Influencer(withDictionary: value as! [String: AnyObject])
                self.arrInfluencerList.append(objInfluencer)
            }
            self.tableView.reloadData()

        }
        NavigationHelper.helper.contentNavController!.pushViewController(filterVC, animated: true)
    }

}



extension MeetAnExpertViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if isSearch == true {
			return arrSearchList.count
		} else {
			return arrInfluencerList.count
		}

	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MeetAnExpertTableViewCell.self), for: indexPath) as! MeetAnExpertTableViewCell
		if isSearch == true {
			cell.datasource = self.arrSearchList[indexPath.row]
		} else {
			cell.datasource = self.arrInfluencerList[indexPath.row]
		}
		return cell
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return IS_IPAD() ? 165.0 : 132.0
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let meetanExpertDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: MeetAnExpertDetailsViewController.self)) as! MeetAnExpertDetailsViewController
		if isSearch == true {
			meetanExpertDetailsVC.objInfluencerDetails = self.arrSearchList[indexPath.row] as! Influencer
		} else {
			meetanExpertDetailsVC.objInfluencerDetails = self.arrInfluencerList[indexPath.row] as! Influencer
		}
		NavigationHelper.helper.contentNavController!.pushViewController(meetanExpertDetailsVC, animated: true)
	}
}

// API Call
extension MeetAnExpertViewController {
	// get Influencer List
    
    func getAllInfluencerList() {
     
        Helper.sharedClient.showLoaderWith(inview: self.view)
        CurrentLocation.sharedInstance.fetchCurrentUserLocation(onSuccess: { (latitude, longitude) in
            debugPrint("Current Lat==> \(latitude)")
            Globals.sharedClient.lat = latitude
            Globals.sharedClient.lon = longitude
            
            if let _ =  (Globals.sharedClient.lat){
          
             // find the state and city with the lest of lat and long
                
             CurrentLocation.sharedInstance.getStateCityWithLatAndLong( Globals.sharedClient.lat!, longitude:  Globals.sharedClient.lon!, countryDetails: { (stateName, cityName) in
                
                // state and city match
                if (stateName.containsIgnoringCase(OBJ_FOR_KEY(kSeletedState) as! String)) && (cityName.containsIgnoringCase(OBJ_FOR_KEY(kSeletedCity) as! String)){
                    
                      Helper.sharedClient.removeLoader(inview: self.view)
                       self.influencerAllListApiCallingSimple()
                 
                        print("Sate\(stateName)")
                
                }
                
                // city and state not match
                else{
            Helper.sharedClient.removeLoader(inview: self.view)
               self.influencerAllListApiCallingWithLatAndLong()
                    
                    
                }
            
             
             })
                
                
                
            }
            
            
            else{
            // lant and long both nil
                Helper.sharedClient.removeLoader(inview: self.view)
                
            }
        }) { (message) in
   
        
        }
        
        

    
    
    }
       
 }
// API CAlling work

extension MeetAnExpertViewController {
   
// This Api Call when get latituted and longituted
    func influencerAllListApiCallingSimple(){
        APIHandler.handler.getInfluencerListWithoutLatLong(foruser: solutionType, cityID: OBJ_FOR_KEY(kCityId) as? Int, InfluencerType: kInfluencer, success: { (response) in
            
            
            print("Response\(response)")
            let notificationCount = response?["totalNotification"].intValue
            
            
            if notificationCount! > 0 {
                NavigationHelper.helper.headerViewController!.lblNotification.isHidden = false
                NavigationHelper.helper.headerViewController!.lblNotification.text = String(describing: notificationCount)
            } else {
                NavigationHelper.helper.headerViewController!.lblNotification.isHidden = true
            }
            // debugPrint("Influencer List == \(response)")
            self.arrInfluencerList.removeAll()
            if (response?["User"].arrayObject?.count)! > 0 {
                for value in (response?["User"].arrayObject!)! {
                    let objInfluencer = Influencer(withDictionary: value as! [String: AnyObject])
                    self.arrInfluencerList.append(objInfluencer)
                }
            }
                
            else{
                self.noResult(forArrData: response!["User"].arrayObject! as [AnyObject], lableText: NO_RECORDS_FOUND)
            }
            
            self.tableView.reloadData()
            
            
        }) { (error) in
            
        }
    }
    
    // This Api Calling With Passe lat long
    
    func influencerAllListApiCallingWithLatAndLong(){
        APIHandler.handler.getInfluencerList(foruser: solutionType, cityID: OBJ_FOR_KEY(kCityId) as? Int, InfluencerType: kInfluencer, lat: Globals.sharedClient.lat!, lon:   Globals.sharedClient.lon!, success: { (response) in
            
            
            
            
            print("Response\(response)")
            let notificationCount = response?["totalNotification"].intValue
            
            
            if notificationCount! > 0 {
                NavigationHelper.helper.headerViewController!.lblNotification.isHidden = false
                NavigationHelper.helper.headerViewController!.lblNotification.text = String(describing: notificationCount)
            } else {
                NavigationHelper.helper.headerViewController!.lblNotification.isHidden = true
            }
            // debugPrint("Influencer List == \(response)")
            self.arrInfluencerList.removeAll()
            if (response?["User"].arrayObject?.count)! > 0 {
                for value in (response?["User"].arrayObject!)! {
                    let objInfluencer = Influencer(withDictionary: value as! [String: AnyObject])
                    self.arrInfluencerList.append(objInfluencer)
                }
            }
                
            else{
                self.noResult(forArrData: response!["User"].arrayObject! as [AnyObject], lableText: NO_RECORDS_FOUND)
            }
            
            self.tableView.reloadData()
            
            
            
            
            
        }) { (error) in
             Helper.sharedClient.removeLoader(inview: self.view)
        }
    }
    
    
}


extension MeetAnExpertViewController {
    func getFilterInfluencerList() {
       
    }
}


// MARK:- TextFieldDelegate & Search Method
extension MeetAnExpertViewController: UITextFieldDelegate {

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
			self.tableView.reloadData()
		} else {
			isSearch = true
			self.filterContentForSearchText(strVal as NSString)
		}

		return true
	}

	func filterContentForSearchText(_ searchText: NSString)
	{

		arrSearchList = self.arrInfluencerList.filter { (obj) -> Bool in
			let objMeetanExpert = obj as! Influencer
			if (objMeetanExpert.influencerUserName!.lowercased().contains(searchText.lowercased as String)) {

				return true
			} else {
				return false
			}
		}
		self.tableView.reloadData()
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		isSearch = false
		textField.resignFirstResponder()
		return true
	}
}

