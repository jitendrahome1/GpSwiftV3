//
//  LoginViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/26/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
class LoginViewController: BaseTableViewController, GIDSignInDelegate,GIDSignInUIDelegate {
let googleClientID = "541996200643-mfhklg3ii8fsop8kf2hcck0gl0e5d2oq.apps.googleusercontent.com"
	@IBOutlet weak var textEmailID: JATextField!
	@IBOutlet weak var textPassword: JATextField!
    var  arrCertificates = [AnyObject]()
    var arrUserDetailsObj = [AnyObject]()
    
    var socialLoginSucceed: ((_ succeed: Bool)->())!
	override func viewDidLoad() {
        self.textEmailID.returnKeyType = .next
        self.textPassword.returnKeyType = .default
		self.crossButtonEnabled = true
		self.setNavigationTitle(TITLE_LOGIN)
		super.viewDidLoad()
        textEmailID.text = "gp01@mailinator.com"
        textPassword.text = "123456"
		textPassword.placeholder = "Password"
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: Actions
	@IBAction func actionForgotPassword(_ sender: AnyObject) {
		let forgotPasswordVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: ForgotPasswordViewControllerStepOne.self)) as! ForgotPasswordViewControllerStepOne
		self.navigationController?.pushViewController(forgotPasswordVC, animated: true)

	}

	@IBAction func actionLoginFB(_ sender: AnyObject) {
		
			JASocailLogin.JALoginWithFacebook(delegate: self, sucessData: { (sucessData) -> Void in
           
                if (sucessData as! NSObject).isEqual(false){
                   // nothing work.
                }
                else{
                    SET_OBJ_FOR_KEY(sucessData["name"] as! String as AnyObject, key: kUserName)
                SET_OBJ_FOR_KEY(sucessData["email"] as! String as AnyObject, key: kUserEmail)
                  //SET_OBJ_FOR_KEY("fb",  key: kSocailTypeFacebook)
				print("user Details\(sucessData)")
			// calling to api,
				APIHandler.handler.loginWithWithSocialID(forSocialID: sucessData["id"] as? String, socailType: "fb", success: { (response) in
                    let dictUserDetails = response?.dictionary!["User"]
                    
                    Globals.sharedClient.userID = dictUserDetails!["id"].intValue
                  
                    if dictUserDetails!["otp_status"].intValue != 0 {
                        SET_OBJ_FOR_KEY(dictUserDetails!["access_token"].string! as AnyObject, key: kToken)
                        SET_INTEGER_FOR_KEY(dictUserDetails!["id"].intValue, key: kUserID)
                        SET_OBJ_FOR_KEY(dictUserDetails!["name"].string! as AnyObject, key: kUserName)
                        SET_OBJ_FOR_KEY(dictUserDetails!["user_type"].string! as AnyObject, key: kUserType)
                        SET_OBJ_FOR_KEY(dictUserDetails!["address"].string! as AnyObject, key: kUserAddress)
                        SET_OBJ_FOR_KEY(dictUserDetails!["contact_no"].string! as AnyObject, key: kUserContactNumber)
                        SET_OBJ_FOR_KEY(dictUserDetails!["about_me"].string! as AnyObject, key: kUserAboutUS)
                        SET_OBJ_FOR_KEY(dictUserDetails!["email"].string! as AnyObject, key: kUserEmail)
                    
                        Globals.sharedClient.userID = dictUserDetails!["id"].intValue
                        Globals.sharedClient.loginUserType = dictUserDetails!["user_type"].string
                        NavigationHelper.helper.reloadMenu()
                        self.dismissToDashboard()
                    }else {
                        APIHandler.handler.resendOTP(forUser: dictUserDetails!["id"].intValue, success: { (response) in
                            
                            }, failure: { (error) in
                                self.navigationItem.rightBarButtonItem!.isEnabled = true;
                        })
                        let verifictionCodeVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: VerificationCodeViewController.self)) as! VerificationCodeViewController
                        verifictionCodeVC.UserID = dictUserDetails!["id"].intValue
                        self.navigationController?.pushViewController(verifictionCodeVC, animated: true)
                    }
                 
					print("Geeting responselsocil ==\(response)")
                    
                    
                    
					},failure: { (error) in
                
                        let userRegistrationVC = loginStoryboard.instantiateViewController(withIdentifier: "UserRegistrationViewController") as! UserRegistrationViewController
                        userRegistrationVC.strSocailID = (sucessData["id"] as? String)!
                        userRegistrationVC.strSocialType = "fb"
                        self.navigationController?.pushViewController(userRegistrationVC, animated: true)
                         
                        print("error\(error)")
				})
            }
			}) { (failure) -> Void in
			}
	}

	@IBAction func actionLoginGoogle(_ sender: AnyObject) {

        self.initiateGoogleLoginProtocol { (succeed) in
        
        }
        
		//Toast.show(withMessage: "Under Construction...")
	}

	@IBAction func actionUserRegistration(_ sender: AnyObject) {

		let userRegistrationVC = loginStoryboard.instantiateViewController(withIdentifier: "UserRegistrationViewController") as! UserRegistrationViewController
		self.navigationController?.pushViewController(userRegistrationVC, animated: true)

	}
	@IBAction func loginAction(_ sender: AnyObject) {
		self.view.endEditing(true)
		guard textEmailID.hasText && textPassword.hasText && textEmailID.text!.isValidEmail else {
			if textEmailID.text!.isBlank
			{
				Toast.show(withMessage: ENTER_EMAIL_ID)
			}
			else if !(textEmailID.text!.isValidEmail)
			{
				Toast.show(withMessage: ENTER_VALID_EMAIL)
			}
			else if textPassword.text!.isBlank
			{
				Toast.show(withMessage: ENTER_PASSWORD)
			}
			return
		}

		CDSpinner.show(onViewControllerView: self.view)
		// API Calling
		self.navigationItem.rightBarButtonItem!.isEnabled = false;

		APIHandler.handler.login(email: textEmailID.text!, password: textPassword.text!, success: { (response) in
			
            let dictUserDetails = response!.dictionary!["User"]

            let objUserDetails = User(withDictionary: (response!["User"].dictionaryObject)! as [String : AnyObject])
            
            self.arrUserDetailsObj.append(objUserDetails)
       
            let placesData = NSKeyedArchiver.archivedData(withRootObject: (dictUserDetails?.dictionaryObject)!)
            
            SET_OBJ_FOR_KEY(placesData as AnyObject , key: kUserLoginDetails)
           
            
			if dictUserDetails!["otp_status"].intValue != 0 {
				SET_OBJ_FOR_KEY(dictUserDetails!["access_token"].string! as AnyObject, key: kToken)
				SET_INTEGER_FOR_KEY(dictUserDetails!["id"].intValue, key: kUserID)
				SET_OBJ_FOR_KEY(dictUserDetails!["name"].string! as AnyObject, key: kUserName)
				SET_OBJ_FOR_KEY(dictUserDetails!["user_type"].string! as AnyObject, key: kUserType)
				SET_OBJ_FOR_KEY(dictUserDetails!["address"].string! as AnyObject, key: kUserAddress)
				SET_OBJ_FOR_KEY(dictUserDetails!["contact_no"].string! as AnyObject, key: kUserContactNumber)
				SET_OBJ_FOR_KEY(dictUserDetails!["about_me"].string! as AnyObject, key: kUserAboutUS)
				SET_OBJ_FOR_KEY(dictUserDetails!["email"].string! as AnyObject, key: kUserEmail)
                SET_OBJ_FOR_KEY(dictUserDetails!["totalNotification"].intValue as AnyObject, key: kUserTotalNotification)
                
                    SET_OBJ_FOR_KEY(dictUserDetails!["state"]["id"].intValue as AnyObject, key: kUserStateID)
                	SET_OBJ_FOR_KEY(dictUserDetails!["state"]["name"].string! as AnyObject, key: kUserStateName)
                   Globals.sharedClient.loginUserType = dictUserDetails!["user_type"].string
                
                SET_OBJ_FOR_KEY(dictUserDetails!["city"]["id"].intValue as AnyObject, key: kUserCityID)
                SET_OBJ_FOR_KEY(dictUserDetails!["city"]["name"].string! as AnyObject, key: kUserCityName)
                
                for (index, value) in dictUserDetails!["experiences"].arrayObject!.enumerated() {
                    if index == 0 {
                        let objExperience = Experience(withDictionary: value as! [String : AnyObject])
                        SET_OBJ_FOR_KEY(objExperience.organisation_name! as AnyObject, key: EXP_NAME)
                        //SET_OBJ_FOR_KEY(objExperience.startDate!, key: EXP_STRT_DATE)
                        //SET_OBJ_FOR_KEY(objExperience.endDate!, key: EXP_END_DATE)
                    }
                }
                
                for (index, value) in dictUserDetails!["educations"].arrayObject!.enumerated() {
                    if index == 0 {
                        let objEducations = Education(withDictionary: value as! [String : AnyObject])
                        SET_OBJ_FOR_KEY(objEducations.degreeName! as AnyObject, key: EDU_DEGREE)
                        SET_OBJ_FOR_KEY(objEducations.startDate! as AnyObject, key: EDU_START_DATE)
                        SET_OBJ_FOR_KEY(objEducations.endDate! as AnyObject, key: EDU_END_DATE)
                        SET_OBJ_FOR_KEY(objEducations.stream! as AnyObject, key: EDU_STREAM)
                    }
                }
                
                for (index, value) in dictUserDetails!["trainings"].arrayObject!.enumerated() {
                    if index == 0 {
                        let objTrainings = Training(withDictionary: value as! [String : AnyObject])
                        SET_OBJ_FOR_KEY(objTrainings.training_name! as AnyObject, key: TR_NAME)
                        SET_OBJ_FOR_KEY(objTrainings.startDate! as AnyObject, key: TR_STRT_DATE)
                        SET_OBJ_FOR_KEY(objTrainings.endDate! as AnyObject, key: TR_END_DATE)
                    }
                }
                
                for value in dictUserDetails!["certifications"].arrayObject! {
                    let objCertificate = Certificates(withDictionary: value as! [String : AnyObject])
                    if let _ = objCertificate.certificateFile{
                          self.arrCertificates.append(objCertificate.certificateFile! as AnyObject)   
                    }
               
                    
                }
                SET_OBJ_FOR_KEY(self.arrCertificates as AnyObject, key: CERTIFICATES)
                
                
                
                if let _ = dictUserDetails!["images"]["display_profile"].dictionary{
                    SET_OBJ_FOR_KEY(dictUserDetails!["images"]["display_profile"]["thumb"].string! as AnyObject, key: kDisplayProfile)
                    SET_OBJ_FOR_KEY(dictUserDetails!["images"]["cover_profile"]["original"].string! as AnyObject, key: kCoverProfile)
                }
             
                if let _  = dictUserDetails!["zip"].string {
                  SET_OBJ_FOR_KEY(dictUserDetails!["zip"].string! as AnyObject, key: kUserZipCode)
                }
              
                APIManager.manager.header += ["access-token": "\(OBJ_FOR_KEY(kToken)!)"]
				if let _ = dictUserDetails!["profile"].dictionary
				{
					SET_OBJ_FOR_KEY(dictUserDetails!["profile"]["status"].intValue as AnyObject, key: kUserTypeStatus)
				} else {
					SET_OBJ_FOR_KEY(500 as AnyObject, key: kUserTypeStatus)
				}

				if let birthdate = dictUserDetails!["birth_date"].double {
                    
                   let strDate =  Date.convertTimeStampToBirthDate(birthdate)
					SET_OBJ_FOR_KEY(strDate as AnyObject, key: kUserBirthDate)
                } else {
                    SET_OBJ_FOR_KEY("N/A" as AnyObject, key: kUserBirthDate)
                }
                
				Globals.sharedClient.userID = dictUserDetails!["id"].intValue
				APIManager.manager.header += ["access-token": "\(OBJ_FOR_KEY(kToken)!)"]

				NavigationHelper.helper.reloadMenu()
            
				self.dismissToDashboard()
			} else {
				APIHandler.handler.resendOTP(forUser: dictUserDetails!["id"].intValue, success: { (response) in

					}, failure: { (error) in
					self.navigationItem.rightBarButtonItem!.isEnabled = true;
				})
				let verifictionCodeVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: VerificationCodeViewController.self)) as! VerificationCodeViewController
				verifictionCodeVC.UserID = dictUserDetails!["id"].intValue
				self.navigationController?.pushViewController(verifictionCodeVC, animated: true)
			}
		}) { (error) in
			debugPrint("Error \(error)")
			self.navigationItem.rightBarButtonItem!.isEnabled = true;
			Toast.show(withMessage: INVALID_CREDENTIALS)
		}

	}
	// MARK: Navigation
	func dismissToDashboard() {
		self.navigationController?.dismiss(animated: true, completion: nil)

	}
}

extension LoginViewController {

	// MARK: UITableViewDelegate methods
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		switch indexPath.row {
		case 0:
			return IS_IPAD() ? 430 : 200

		case 1:
			return IS_IPAD() ? 100 : 60
		case 3:
			return IS_IPAD() ? 100 : 60
		case 2:
			return IS_IPAD() ? 120 : 96
		default:
			return IS_IPAD() ? 60 : 40
		}

	}

}

extension LoginViewController {

	// MARK: UITextFieldDelegate methods
	func textFieldShouldReturn(_ textField: UITextField!) -> Bool {
        
        if textField == self.textEmailID{
            self.textPassword.becomeFirstResponder()
        }
        else if textField == self.textPassword
        {
        textField.resignFirstResponder()
            
        }
		
		return true
	}
   
    
    // Google
     func initiateGoogleLoginProtocol(_ success:@escaping (_ suceed: Bool)->()) {
        Helper.sharedClient.isGoogleSignIn = true
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = googleClientID
        GIDSignIn.sharedInstance().signIn()
        socialLoginSucceed = success
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil) {
            socialLoginSucceed!(false)
            //debugPrint(error.description)
            return
        }
        
       // SET_OBJ_FOR_KEY(user.userID!, key: kUserSocialID)
        SET_OBJ_FOR_KEY(user.profile.name! as AnyObject, key: kUserName)
        SET_OBJ_FOR_KEY(user.profile.email! as AnyObject, key: kUserEmail)
        // SET_OBJ_FOR_KEY("google",  key: kSocailTypeFacebook)
        
        APIHandler.handler.loginWithWithSocialID(forSocialID: user.userID!, socailType: "google", success: { (response) in
            let dictUserDetails = response!.dictionary!["User"]
            
            Globals.sharedClient.userID = dictUserDetails!["id"].intValue
            
            if dictUserDetails!["otp_status"].intValue != 0 {
                SET_OBJ_FOR_KEY(dictUserDetails!["access_token"].string! as AnyObject, key: kToken)
                SET_INTEGER_FOR_KEY(dictUserDetails!["id"].intValue, key: kUserID)
                SET_OBJ_FOR_KEY(dictUserDetails!["name"].string! as AnyObject, key: kUserName)
                SET_OBJ_FOR_KEY(dictUserDetails!["user_type"].string! as AnyObject, key: kUserType)
                SET_OBJ_FOR_KEY(dictUserDetails!["address"].string! as AnyObject, key: kUserAddress)
                SET_OBJ_FOR_KEY(dictUserDetails!["contact_no"].string! as AnyObject, key: kUserContactNumber)
                SET_OBJ_FOR_KEY(dictUserDetails!["about_me"].string! as AnyObject, key: kUserAboutUS)
                SET_OBJ_FOR_KEY(dictUserDetails!["email"].string! as AnyObject, key: kUserEmail)
                APIManager.manager.header += ["access-token": "\(OBJ_FOR_KEY(kToken)!)"]
                Globals.sharedClient.userID = dictUserDetails!["id"].intValue
                   Globals.sharedClient.loginUserType = dictUserDetails!["user_type"].string
                NavigationHelper.helper.reloadMenu()
                self.dismissToDashboard()
            }else {
                APIHandler.handler.resendOTP(forUser: dictUserDetails!["id"].intValue, success: { (response) in
                    
                    }, failure: { (error) in
                        self.navigationItem.rightBarButtonItem!.isEnabled = true;
                })
                let verifictionCodeVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: VerificationCodeViewController.self)) as! VerificationCodeViewController
                verifictionCodeVC.UserID = dictUserDetails!["id"].intValue
                self.navigationController?.pushViewController(verifictionCodeVC, animated: true)
            }
            
            print("Geeting responselsocil ==\(response)")
            
            
            
            },failure: { (error) in
                
                let userRegistrationVC = loginStoryboard.instantiateViewController(withIdentifier: "UserRegistrationViewController") as! UserRegistrationViewController
                userRegistrationVC.strSocailID = user.userID
                userRegistrationVC.strSocialType = "google"
                self.navigationController?.pushViewController(userRegistrationVC, animated: true)
                
                print("error\(error)")
        })
    }
}



