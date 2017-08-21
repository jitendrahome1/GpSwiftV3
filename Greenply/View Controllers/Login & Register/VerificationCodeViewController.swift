//
//  VerificationCodeViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/26/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class VerificationCodeViewController: BaseTableViewController {

	@IBOutlet weak var textVerificationCode: JATextField!
	var UserID: Int?
	override func viewDidLoad() {
		self.backButtonEnabled = false
		self.crossButtonEnabled = true
		super.viewDidLoad()
		self.setNavigationTitle(TITLE_VERIFICATION_CODE)

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
//Mark:Action

	@IBAction func actionNotReceived(_ sender: AnyObject) {
		APIHandler.handler.resendOTP(forUser: UserID!, success: { (response) in

		}) { (error) in

		}
	}

	@IBAction func actionVerificationCode(_ sender: AnyObject) {
		self.view.endEditing(true)
		guard textVerificationCode.hasText else {

			// API Calling
			if textVerificationCode.text!.isBlank
			{
				Toast.show(withMessage: VERIFICATION_CODE_CORRECT)
			}
			return
		}
		CDSpinner.show(onViewControllerView: self.view)
		// API Calling
		APIHandler.handler.verifyOTPUserRegistration(forUser: UserID!, otp: textVerificationCode.text, success: { (response) in
			// move to dashboard
            let dictUserDetails = response?.dictionary!["User"]
            let placesData = NSKeyedArchiver.archivedData(withRootObject: (dictUserDetails?.dictionaryObject)!)
            SET_OBJ_FOR_KEY(placesData as AnyObject , key: kUserLoginDetails)
			
            SET_OBJ_FOR_KEY(dictUserDetails!["access_token"].string! as AnyObject, key: kToken)
		
            
//            SET_INTEGER_FOR_KEY(dictUserDetails!["id"].intValue, key: kUserID)
//			Globals.sharedClient.userID = dictUserDetails!["id"].intValue
//            SET_OBJ_FOR_KEY(dictUserDetails!["username"].string!, key: kUserName)
//            SET_OBJ_FOR_KEY(dictUserDetails!["user_type"].string!, key: kUserType)
//            SET_OBJ_FOR_KEY(dictUserDetails!["address"].string!, key: kUserAddress)
//            SET_OBJ_FOR_KEY(dictUserDetails!["contact_no"].string!, key: kUserContactNumber)
//            SET_OBJ_FOR_KEY(dictUserDetails!["about_me"].string!, key: kUserAboutUS)
//            SET_OBJ_FOR_KEY(dictUserDetails!["email"].string!, key: kUserEmail)
//            if let birthdate = dictUserDetails!["birth_date"].double{
//            SET_OBJ_FOR_KEY(birthdate, key: kUserBirthDate)
//                
//            }

            
            
            
			APIManager.manager.header += ["access-token": "\(OBJ_FOR_KEY(kToken)!)"]
			NavigationHelper.helper.reloadMenu()
			self.dismiss(animated: true, completion: nil)
		}) { (error) in

		}
	}
}

extension VerificationCodeViewController {

	// MARK: UITableViewDelegate methods
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		switch indexPath.row {
		case 0:
			return IS_IPAD() ? 430 : 200
		case 1:
			return IS_IPAD() ? 120 : 100
		default:
			return IS_IPAD() ? 85 : 60
		}
	}
}

extension VerificationCodeViewController {

	// MARK: UITextFieldDelegate methods
	func textFieldShouldReturn(_ textField: UITextField!) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
