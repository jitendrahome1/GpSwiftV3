//
//  BecomeInfluencerViewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 06/10/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class BecomeInfluencerViewController: BaseTableViewController {
    @IBOutlet weak var textName: JATextField!
    @IBOutlet weak var textMobileNumber: JATextField!
    @IBOutlet weak var textType: JATextField!
    @IBOutlet weak var textViewAboutMe: JAPlaceholderTextView!
    @IBOutlet weak var labelUploadFile: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var imageBackground: UIImageView!
    
    var profsavedImg: UIImage!
    var backsavedImg: UIImage!
    var becomeInfluencerArray: [AnyObject]?
    var arrayType = [String]()
    var strTypeId: String!
    var strBase64: String!
    var fileType: String!
    //CoverProfile
    var proffiletype: String!
    var profbase64: String!
    var proffilesize: Int!
    var proffilename: String!
    var userBirthDate: String?
    var strUserEmail: String?
    //DisplayProfile
    var dispfiletype: String!
    var dispbase64: String!
    var dispfilesize: Int!
    var displfilename: String!
    var objUser: User!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = nil
        self.tableView.keyboardDismissMode = .onDrag
        textMobileNumber.keyboardType = .numberPad
        becomeInfluencerArray = Helper.sharedClient.readPlist(forName: "BecomeInfluencer")
   
        self.initialSetup()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: false, isHideMenuButton: false)
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_INFLUENCER
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //******* MARK- USER DEFINE FUNCTION ********
    // MARk:- Initial setup
   
    func initialSetup(){
        if let data = OBJ_FOR_KEY(kUserLoginDetails) as? Data {
            let mySavedList = NSKeyedUnarchiver.unarchiveObject(with: data)
            self.objUser = User(withDictionary: mySavedList as! [String: AnyObject])
            
            
            textName.text = self.objUser.name
            textMobileNumber.text =  self.objUser.userContactNumber
            textType.text = self.objUser.userType
            textViewAboutMe.text = self.objUser.userAboutUS
            
            self.strUserEmail  = self.objUser.userEmail
            
            
            if let birthDate = self.objUser.userBirthDate
            {
                let strBirthDate = birthDate
                self.userBirthDate = Date.convertTimeStampToBirthDate(strBirthDate)
            } else {
                self.userBirthDate = ""
            }
            
            let backgroundQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
            backgroundQueue.async(execute: {
                
                self.imageProfile.setImage(withURL: URL(string:self.objUser.profileImageOriginal!)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))
                self.imageBackground.setImage(withURL: URL(string: self.objUser.coverImageOriginal!)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))
                DispatchQueue.main.async(execute: {
                    self.getUserTypeAPICalling()
                    
                    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width/2
                    self.imageProfile.layer.masksToBounds = true
                    self.imageProfile.layoutIfNeeded()
                })
                
            })
            
            
        }
        
        
    }
    
    // MARK:- This function Validate Fields....
    func ValidateFields() -> Bool{
        
        let result = true
        self.view.endEditing(true)
        
        if textName.text == "" || textName.text == nil  {
            Toast.show(withMessage: ENTER_USERNAME)
            return false
        }
        else if textMobileNumber.text == "" || textMobileNumber.text == nil {
            Toast.show(withMessage: ENTER_MOBILE_NUMBER)
            return false
        }
        else if textType.text == "" || textType.text == nil  {
            Toast.show(withMessage: ENTER_TYPE)
            return false
        }
        else if textViewAboutMe.text == "" || textViewAboutMe.text == nil {
            Toast.show(withMessage: ENTER_ABOUTME)
            return false
        }
        else if strBase64 == "" || strBase64 == nil {
            Toast.show(withMessage: UPLOAD_FILE)
            return false
        }
        return result
        
        
    }
  
    
    // MARK:- This Function Convert the image to base 64.
    func imageConvertBase64(){
        if (profbase64 != nil) && (dispbase64 != nil)  {
            DispatchQueue.main.async(execute: {
                Helper.sharedClient.removeLoader(inview: self.view);
                self.becomeInfluencerAPICalling()
                
            })
        }
        else{
            
            let dataProfileImage: NSData = UIImagePNGRepresentation(self.imageProfile.image!)! as NSData
            
            self.profbase64 = dataProfileImage.base64EncodedString(options: .lineLength64Characters)
            self.proffiletype = MIMEType.mimeType(for: dataProfileImage as Data!)
            
            
            let imageSizeProfile: Int = dataProfileImage.length
            self.proffilesize = imageSizeProfile / 1024
            
            
            
            let dataBackImage: NSData = UIImagePNGRepresentation(self.imageBackground.image!)! as NSData
            self.dispbase64 = dataBackImage.base64EncodedString(options: .lineLength64Characters)
            self.dispfiletype = MIMEType.mimeType(for: dataBackImage as Data!)
            let backGroundExtension = self.dispfiletype.components(separatedBy: ("/"))
            
            self.displfilename = "Image" + ".\(backGroundExtension[1])"
            
            let imageSizeBack: Int = dataBackImage.length
            self.dispfilesize = imageSizeBack / 1024
            if (profbase64 != nil) && (dispbase64 != nil)  {
                DispatchQueue.main.async(execute: {
                    Helper.sharedClient.removeLoader(inview: self.view);
                    self.becomeInfluencerAPICalling()
                    
                })
                
            }
        }
        
        
        
        
        
        
    }

        
    // **** USER ACTION WORK *****
    //MARK:- This Function Save Data
    @IBAction func saveAction(_ sender: UIButton) {
        if !(self.ValidateFields())
        {
            print(" some thing is missing")
            return;
        }
        self.imageConvertBase64()
    }
    
    //MARK:- This Function browse the file and select the data
    @IBAction func browseAction(_ sender: UIButton) {
        GPImagePickerController.pickImage(onController: self, didPick: { (image) in
            let imagesData: Data = UIImagePNGRepresentation(image)!
            self.fileType = MIMEType.mimeType(for: imagesData)
            let fileExtension = self.fileType.components(separatedBy: "/")
            self.labelUploadFile.text = "Image" + ".\(fileExtension[1])"

            self.strBase64 = imagesData.base64EncodedString(options: .lineLength64Characters)
            }, didCancel: {
                
        })
    }
    //MARK:- This Function  select the profile image
    @IBAction func profImage(_ sender: UIButton) {
        GPImagePickerController.pickImage(onController: self, didPick: { (image) in
            self.profbase64 = ""
            self.imageProfile.image = image
            self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width/2
            self.imageProfile.layer.masksToBounds = true
            
            
            let imagesData: Data = UIImagePNGRepresentation(image)!
            self.proffiletype = MIMEType.mimeType(for: imagesData)
          
          
            self.profbase64 = imagesData.base64EncodedString(options: .lineLength64Characters)
            let imageSize: Int = imagesData.count
            self.proffilesize = imageSize / 1024
            
            }, didCancel: {
                
        })
        
    }
    
    //MARK:- This Function  select the background image
    @IBAction func backgroundImg(_ sender: UIButton) {
        GPImagePickerController.pickImage(onController: self, didPick: { (image) in
            self.dispbase64 = "";
            self.imageBackground.image = image
            
            let imagesData: Data = UIImagePNGRepresentation(image)!
            self.dispfiletype = MIMEType.mimeType(for: imagesData)
            let fileExtension = self.dispfiletype.components(separatedBy: "/")
       self.displfilename = "Image" + ".\(fileExtension[1])"
            self.dispbase64 = imagesData.base64EncodedString(options: .lineLength64Characters)
            let imageSize: Int = imagesData.count
            self.dispfilesize = imageSize / 1024
            
            }, didCancel: {
                
        })
        
    }
    
    
}
//******* MARK- DELEGATE AND API WORK ********

//MARK: -TableViewDatasource
extension BecomeInfluencerViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (becomeInfluencerArray?.count)!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: String?
        if IS_IPAD() {
            height = (((becomeInfluencerArray![indexPath.row] as! [String: AnyObject])["heightOfRowiPad"]!) as! String)
        } else {
            height = (((becomeInfluencerArray![indexPath.row] as! [String: AnyObject])["heightOfRowiPhone"]!) as! String)
        }
        var floatHeight: CGFloat?
        if let number = NumberFormatter().number(from: height!) {
            floatHeight = CGFloat(number)
        }
        return floatHeight!
    }
}

//MARK:- TextFieldDelegate
extension BecomeInfluencerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textName {
            textMobileNumber.becomeFirstResponder()
        } else if textField == textMobileNumber {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textType{
            self.view.endEditing(true)
        }
        
        
        if textField == textType {
            GPPickerViewController.showPickerController(self, isDatePicker: false, pickerArray: self.arrayType, position: .bottom, pickerTitle: "", preSelected: "") { (value, index) in
                if String(describing: value) != "" {
                    let listArr = value?.components(separatedBy: "+")
                    self.strTypeId = listArr?[1]
                    self.textType.text = listArr?[0]
                }
            }
            return false
        } else {
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var searchText =  textField.text
        
        if textField == textMobileNumber {
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

//MARK:- API Calling
extension BecomeInfluencerViewController {
 // MARk:- This api get the  user type
    func getUserTypeAPICalling(){
    APIHandler.handler.userType({ (response) in
    for value in (response?["influencer"].arrayValue)! {
    let influencerType = value["influencer_type"].stringValue
    let influencerTypeId = value["influencer_type_id"].stringValue
    let influencerData = "\(influencerType)+\(influencerTypeId)"
    self.arrayType.append(influencerData)
    debugPrint(self.arrayType)
    }
    }) { (error) in
     
        }
    
}
// MARk:- This api working user BecomeInfluencer
    func becomeInfluencerAPICalling() {
        
        
        
        APIHandler.handler.becomeInfluencer(forUser: Globals.sharedClient.userID, name: textName.text, email:self.strUserEmail!, contact_no:self.textMobileNumber.text!, address: self.objUser.userAddress!,aboutme: textViewAboutMe.text,birthDate:self.userBirthDate!, user_type: kInfluencer, influencer_type_id: Int(strTypeId!), filetype: fileType, filename: labelUploadFile.text, base64: strBase64, dispfilename: displfilename!, dispfilesize: dispfilesize!, dispbase64: dispbase64, coverfilename: "influncerImg.jpg", coverfilesize: proffilesize!, coverbase64: profbase64!, success: { (response) in
        
            let dictUserDetails = response?.dictionary!["User"]
            let placesData = NSKeyedArchiver.archivedData(withRootObject: (dictUserDetails?.dictionaryObject)!)
            SET_OBJ_FOR_KEY(placesData as AnyObject , key: kUserLoginDetails)
            
            Toast.show(withMessage: INFLUENCER_VERIFICATION)
            NavigationHelper.helper.contentNavController!.popToRootViewController(animated: true)
            
            SET_OBJ_FOR_KEY(dictUserDetails!["name"].string! as AnyObject, key: kUserName)
            SET_OBJ_FOR_KEY(dictUserDetails!["user_type"].string! as AnyObject, key: kUserType)
            // SET_OBJ_FOR_KEY(dictUserDetails!["Profile"]["influencer_type"]["influencer_type"].string!, key: kInfluencerType)
            SET_OBJ_FOR_KEY(dictUserDetails!["address"].string! as AnyObject, key: kUserAddress)
            SET_OBJ_FOR_KEY(dictUserDetails!["contact_no"].intValue as AnyObject, key: kUserContactNumber)
            SET_OBJ_FOR_KEY(dictUserDetails!["about_me"].string! as AnyObject, key: kUserAboutUS)
            SET_OBJ_FOR_KEY(dictUserDetails!["images"]["display_profile"]["thumb"].string! as AnyObject, key: kDisplayProfile)
            SET_OBJ_FOR_KEY(dictUserDetails!["images"]["cover_profile"]["original"].string! as AnyObject, key: kCoverProfile)
            
        }) { (error) in
        
        }
    }
}


