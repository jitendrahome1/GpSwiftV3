//
//  ForgotPasswordViewControllerStepTwo.swift
//  Greenply
//
//  Created by Jitendra on 8/29/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ForgotPasswordViewControllerStepTwo: BaseTableViewController {
    
    @IBOutlet weak var textVerificationCode: JATextField!
    @IBOutlet weak var textNewPassword: JATextField!
    @IBOutlet weak var textConfirmPassword: JATextField!
    var UserID: Int?
    weak var touchView: UITapGestureRecognizer!
    override func viewDidLoad() {
        
        textVerificationCode.returnKeyType = .next
        textNewPassword.returnKeyType = .next
        textConfirmPassword.returnKeyType = .default
        self.crossButtonEnabled = true
        self.backButtonEnabled = true
        textVerificationCode.keyboardType = UIKeyboardType.numberPad
        self.setNavigationTitle(TITLE_FORGOT_PASSWORD)
        super.viewDidLoad()
        self.tableView.keyboardDismissMode = .onDrag
        textNewPassword.placeholder = "Password"
        textConfirmPassword.placeholder = "Confirm Password"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func actionUpdate(_ sender: AnyObject) {
        self.view.endEditing(true)
        guard textVerificationCode.hasText && textNewPassword.hasText && textConfirmPassword.hasText && textNewPassword.text == textConfirmPassword.text else {
            if textVerificationCode.text!.isBlank
            {
                Toast.show(withMessage: ENTER_VERIFICATION_CODE)
            } else if textNewPassword.text!.isBlank {
                Toast.show(withMessage: ENTER_PASSWORD)
            } else if textConfirmPassword.text!.isBlank {
                Toast.show(withMessage: ENTER_CONFIRM_PASSWORD)
            } else if !(textNewPassword.text == textConfirmPassword.text) {
                Toast.show(withMessage: PASSWORD_NOT_MATCH)
            }
            
            return
        }
        // Api Calling
        CDSpinner.show(onViewControllerView: self.view)
        APIHandler.handler.verifyOTPForgotPassword(forUser: UserID, otp: textVerificationCode.text, password: textNewPassword.text, success: { (response) in
            debugPrint("Verify Forgot password Response ==>\(response)")
            // move to dashboard
            self.navigationController?.dismiss(animated: true, completion: nil)
        }) { (error) in
        }
        
    }
}

extension ForgotPasswordViewControllerStepTwo
{
    // MARK: UITableViewDelegate methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.row {
        case 0:
            return IS_IPAD() ? 430 : 200
        default:
            return IS_IPAD() ? 85 : 60
        }
    }
    
}

extension ForgotPasswordViewControllerStepTwo {
    
    // MARK: UITextFieldDelegate methods
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool {
        if textField == self.textVerificationCode{
            self.textNewPassword.becomeFirstResponder()
        }else if textField == self.textNewPassword{
            self.textConfirmPassword.becomeFirstResponder()
        }else if textField == textConfirmPassword{
            textField.resignFirstResponder()
        }
   
        return true
    }
}
