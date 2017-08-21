//
//  ForgotPasswordViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/29/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ForgotPasswordViewControllerStepOne: BaseTableViewController {

	@IBOutlet weak var textMobileNumber: JATextField!
	@IBOutlet weak var textEmailID: JATextField!
	override func viewDidLoad() {

		self.crossButtonEnabled = true
		self.backButtonEnabled = true
		self.setNavigationTitle(TITLE_FORGOTPASSWORD)
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK:- Action

	@IBAction func actionVerificationCode(_ sender: AnyObject) {
        self.view.endEditing(true)
		guard textEmailID.hasText && textEmailID.text!.isValidEmail else {
          if textEmailID.text!.isBlank && !(textMobileNumber.text!.isBlank){
                Toast.show(withMessage: NOT_IMPLEMENTED)
            }
			else if textEmailID.text!.isBlank
			{
				Toast.show(withMessage: ENTER_EMAIL_ID)
			}
			else if !(textEmailID.text!.isValidEmail)
			{
				Toast.show(withMessage: ENTER_VALID_EMAIL)

			}
          else{}
            
			return
		}
        CDSpinner.show(onViewControllerView: self.view)
		APIHandler.handler.forgotAndResetPassword(textEmailID.text!, success: { (response) in
			debugPrint("forgot password Response==>\(response)")
			let forgotPasswordVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: ForgotPasswordViewControllerStepTwo.self)) as! ForgotPasswordViewControllerStepTwo
			forgotPasswordVC.UserID = response?["user_id"].intValue
			self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
			}, failure: { (error) in

		})

	}
}

extension ForgotPasswordViewControllerStepOne
{
	// MARK: UITableViewDelegate methods
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		switch indexPath.row {
		case 0:
			return IS_IPAD() ? 430 : 200
		case 1, 3:
			return IS_IPAD() ? 100 : 70
		case 2:
			return IS_IPAD() ? 40 : 30
		default:
			return IS_IPAD() ? 150 : 110
		}
	}
}

extension ForgotPasswordViewControllerStepOne {

	// MARK: UITextFieldDelegate methods
	func textFieldShouldReturn(_ textField: UITextField!) -> Bool {
		textField.resignFirstResponder()
		return true
	}
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var searchText =  textField.text
        
        if textField == textMobileNumber{
            if (range.length == 0){
                let stringNew = NSMutableString(string: textField.text!)
                stringNew.insert(string, at: range.location)
                searchText = stringNew as String
            }
            else if(range.length == 1){
                let stringNew = NSMutableString(string: textField.text!)
                stringNew.deleteCharacters(in: range)
                searchText = stringNew as String
            }
            if searchText!.utf16.count == 11 &&   searchText!.utf16.count > 0{
                return false
            }
            else{
                return true
            }
        }
        return true
    }

}
