//
//  UserRegistrationViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/29/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class UserRegistrationViewController: BaseTableViewController, UITextFieldDelegate, SeacrhDelegateList {

	@IBOutlet weak var textUserName: JATextField!
	@IBOutlet weak var textEmailID: JATextField!
	@IBOutlet weak var textContactNumber: JATextField!
    
    @IBOutlet weak var buttonCity: UIButton!
    @IBOutlet weak var textState: JATextField!
	@IBOutlet weak var textCity: JATextField!
    @IBOutlet weak var textPincode: JATextField!
	@IBOutlet weak var textPassword: JATextField!
	@IBOutlet weak var textConfirmPassword: JATextField!

    var strSocialType: String = ""
    var strSocailID: String = ""
    var arrStateList = [AnyObject]()
     var arrCityList = [AnyObject]()
    var pStateID: Int?
    var pCityID: Int?
    override func viewDidLoad() {
      self.getAllStateList()
        self.setKeyBordReturnStyleType()
		self.crossButtonEnabled = true
		self.backButtonEnabled = true
		super.viewDidLoad()
		self.setNavigationTitle(TITLE_USERREGISTRATION)
        self.textContactNumber.delegate = self
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        
        if let _ =  OBJ_FOR_KEY(kUserName){
         textUserName.text = OBJ_FOR_KEY(kUserName) as? String
        }
        if let _ =  OBJ_FOR_KEY(kUserEmail){
            textEmailID.text = OBJ_FOR_KEY(kUserEmail) as? String
        }
        
//        if let _ =  OBJ_FOR_KEY(kUserSocialID){
//            strSocailID = OBJ_FOR_KEY(kUserSocialID) as? String
//        }else{
//           strSocailID = ""
//        }
//        if let _ =  OBJ_FOR_KEY(kSocailTypeFacebook){
//            strSocialType = OBJ_FOR_KEY(kSocailTypeFacebook) as? String
//        }else{
//            strSocialType = ""
//        }
      
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	// MARK:- Action

	@IBAction func actionUserRegistration(_ sender: UIButton) {
		self.view.endEditing(true)
		guard textUserName.hasText && textEmailID.hasText && textEmailID.text!.isValidEmail && textState.hasText && textCity.hasText && textPincode.hasText && textContactNumber.hasText && textPassword.hasText && textConfirmPassword.hasText && textConfirmPassword.text == textPassword.text else {

			if textUserName.text!.isBlank
			{
				Toast.show(withMessage: ENTER_USERNAME)
			}
			else if textEmailID.text!.isBlank
			{
				Toast.show(withMessage: ENTER_EMAIL_ID)
			}
			else if !(textEmailID.text!.isValidEmail)
			{
				Toast.show(withMessage: ENTER_VALID_EMAIL)
			}
            else if textContactNumber.text!.isBlank {
                
                Toast.show(withMessage: ENTER_MOBILE_NUMBER)
            }
            else if textState.text!.isBlank {
                Toast.show(withMessage: ENTER_STATE)
            }
			else if textCity.text!.isBlank {
				Toast.show(withMessage: ENTER_CITY)
			}
                
            else if textPincode.text!.isBlank {
                Toast.show(withMessage: ENTER_PINCODE)
            }
			
			else if textPassword.text!.isBlank {

				Toast.show(withMessage: ENTER_PASSWORD)
			}
			else if textConfirmPassword.text!.isBlank {

				Toast.show(withMessage: ENTER_CONFIRM_PASSWORD)
			}
			else if !(textConfirmPassword.text == textPassword.text) {
				Toast.show(withMessage: PASSWORD_NOT_MATCH)
			}
			else { }
			return
		}

		CDSpinner.show(onViewControllerView: self.view)
		// API Calling
        APIHandler.handler.userRegistration(username: textUserName.text!, password: textPassword.text!, email: textEmailID.text!, contact_no: textContactNumber.text!, cityID: pCityID!,stateID:self.pStateID!, pincode: textPincode.text!, socialID: strSocailID, socialType:strSocialType, success: { (response) in
			let dictUserDetails = response?.dictionary!["User"]
			let verifictionCodeVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: VerificationCodeViewController.self)) as! VerificationCodeViewController
			verifictionCodeVC.UserID = dictUserDetails!["id"].intValue
			self.navigationController?.pushViewController(verifictionCodeVC, animated: true)

		}) { (error) in
           debugPrint(error)
        Toast.show(withMessage: kEmailExists)
		}
        
       
      // get state list
      
        
	}
    
    
    @IBAction func actionSelectState(_ sender: UIButton) {
        if self.arrStateList.count > 0 {
            let searchVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: SearchTableViewController.self)) as! SearchTableViewController
            searchVC.arrPData = self.arrStateList
              searchVC.eStateCityStatus = .eStateSeleted
            searchVC.delegate = self
            self.navigationController?.pushViewController(searchVC, animated: true)
        }else{
            Toast.show(withMessage: STATE_ERROR)
        }
    }
    
    @IBAction func actionSelectCity(_ sender: UIButton) {
        if self.arrCityList.count > 0 {
            let searchVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: SearchTableViewController.self)) as! SearchTableViewController
            searchVC.arrPData = self.arrCityList
                     searchVC.eStateCityStatus = .eCitySeleted
            searchVC.delegate = self
            self.navigationController?.pushViewController(searchVC, animated: true)
        }else{
            Toast.show(withMessage: CITY_ERROR)
        }
        
    }
    
    // Mark:- Select City Delagte
//    func didFinishCitySelected(selectCity: String?) {
//        self.textCity.text =  selectCity!
//        self.tableView.reloadData()
//    }
    
    
    
// Mark:- SearchView  deletae
    // MARK:- State get delegate
    func didFinishSelectedState(forItems dictValue: [String: AnyObject]?)
    {
        self.textState.text = ""
        self.textCity.text = ""
      self.textState.text = dictValue!["name"] as? String
       self.pStateID = dictValue!["id"] as? Int
        self.getCityWith(forStateID: self.pStateID!)
        
    }
     // MARK:- city get deleagte
    func didFinishSelectedCity(forItems dictValue: [String: AnyObject]?)
    {
        self.textCity.text = ""
        self.textCity.text = dictValue!["name"] as? String
      
        self.pCityID = dictValue!["id"] as? Int
       
        
    }
    
    //  function change keybord 
    
    func setKeyBordReturnStyleType(){
        self.textUserName.returnKeyType = .next
        self.textEmailID.returnKeyType = .next
        self.textUserName.returnKeyType = .next
        self.textPassword.returnKeyType = .next
        self.textConfirmPassword.returnKeyType = .default
    }
    // Get State List....
    func getAllStateList(){
        APIHandler.handler.getStates({ (response) in
            self.arrStateList.removeAll()
            self.arrStateList = response!["states"].arrayObject! as [AnyObject]
           
            print("\(response)")
            
        }) { (error) in
            
        }
    }
    // get City with state id
    func getCityWith(forStateID stateID:Int?){
        APIHandler.handler.getCityList(forStateID: self.pStateID!, success: { (response) in
            self.arrCityList.removeAll()
            self.arrCityList = response!["cities"].arrayObject! as [AnyObject]
            print("City Result\(response)")
        }) { (error) in
            
        }
    }
    
}
extension UserRegistrationViewController {

	// MARK: UITextFieldDelegate methods
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		switch indexPath.row {
		case 0:
			return IS_IPAD() ? 430 : 200
		case 1..<9:
			return IS_IPAD() ? 80 : 60
		default:
			return IS_IPAD() ? 80 : 70
		}
	}
}



extension UserRegistrationViewController {

	// MARK: UITextFieldDelegate methods
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textUserName{
            textEmailID.becomeFirstResponder()
        }
        else if textField == self.textEmailID{
            textContactNumber.becomeFirstResponder()
        }
        else if textField == self.textPassword{
            textConfirmPassword.becomeFirstResponder()
        }
        else if textField == self.textConfirmPassword{
            textConfirmPassword.resignFirstResponder()
        }
			return true
	}
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         var searchText =  textField.text

        if textField == textContactNumber{
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
        
        if textField == textPincode{
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
            if searchText!.utf16.count == 7 &&   searchText!.utf16.count > 0{
                return false
            }
            else{
                return true
            }
        }

        
        return true
         }
}
