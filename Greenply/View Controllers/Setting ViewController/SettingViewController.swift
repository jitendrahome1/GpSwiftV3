//
//  SettingViewController.swift
//  Greenply
//
//  Created by Jitendra on 11/24/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
class SettingViewController: BaseViewController {
	@IBOutlet weak var tblSetting: UITableView!

	var arrTitle = [String]()
	override func viewDidLoad()
	{
		super.viewDidLoad()
		arrTitle = ["Change Password", "Change Location"]
		self.tblSetting.reloadData()

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true)
		NavigationHelper.helper.tabBarViewController!.hideTabBar()
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_SETTING
	}

}
extension SettingViewController {

	// MARK: UITableViewDataSource methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.arrTitle.count
	}

	func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {

		let cell: SettingCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingCell.self)) as! SettingCell
		
		cell.labelTitle.text = self.arrTitle[indexPath.row]

		return cell
	}
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let changePssVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: ChangePasswordViewController.self)) as! ChangePasswordViewController
            self.navigationController?.pushViewController(changePssVC, animated: true)
            break
        case 1:
            let locationChangeVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: LocationChangeViewController.self)) as! LocationChangeViewController
            locationChangeVC.checkFirstTime = false
          
            
            locationChangeVC.didSelectState = {state, city, stateName, cityName in
                SET_OBJ_FOR_KEY(state as AnyObject, key: kStateId)
                SET_OBJ_FOR_KEY(city as AnyObject, key: kCityId)
                SET_OBJ_FOR_KEY(stateName as AnyObject, key: kSeletedState)
                SET_OBJ_FOR_KEY(cityName as AnyObject, key: kSeletedCity)
            }
            
            
//            locationChangeVC.didSelectState = {state, city in
//                SET_OBJ_FOR_KEY(state, key: kStateId)
//                SET_OBJ_FOR_KEY(city, key: kCityId)
//            }
            self.navigationController?.pushViewController(locationChangeVC, animated: true)
            break
        default: break
            
        }
    }
	func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
	{
		return 51.0
	}
}
