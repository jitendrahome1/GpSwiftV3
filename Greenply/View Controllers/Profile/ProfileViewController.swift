//
//  ProfileViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/31/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//
enum eProfileEdit {
    case kprofileEdit
    case kprofileNotEdit
}
import UIKit
import KCFloatingActionButton
class ProfileViewController: BaseTableViewController, HeaderButtonDeleagte, UITextFieldDelegate, SeacrhDelegateList {
    
    @IBOutlet weak var aIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var buttonSelectCity: UIButton!
    @IBOutlet weak var buttonBirthDate: UIButton!
    @IBOutlet weak var imageProfileBG: UIImageView!
    @IBOutlet weak var imageUserProfile: UIImageView!
    @IBOutlet weak var textMobileNumber: JATextField!
    
    @IBOutlet weak var buttonState: UIButton!
    @IBOutlet weak var textState: JATextField!
    @IBOutlet weak var textViewAboutUs: PlaceHolderTextView!
    var eprofileEditStatus: eProfileEdit = .kprofileNotEdit
    @IBOutlet weak var buttonEditProfile: UIButton!
    var arrStateList = [AnyObject]()
    var arrCityList = [AnyObject]()
    @IBOutlet weak var textCity: JATextField!
    @IBOutlet weak var textDateOfBirth: JATextField!
    @IBOutlet weak var textName: JATextField!
    var pStateID: Int?
    var pCityID: Int?
    var profileImgSize: Int!
    var backgroundImgSize: Int!
    var profileImageBase64: String?
    var backImageBase64: String?
    var fileTypeProfileImag: String?
    var fileTypeBackImg: String?
    var pDate: Date!
    var objUser: User!
    var noRow: Int?
    @IBOutlet weak var buttonUploadImag: UIButton!
    @IBOutlet weak var labelUploadPic: UILabel!
    
    var floatingBtn: PDFloating?
    override func viewDidLoad() {
        super.viewDidLoad()
        noRow = 7
        self.userDetailsApiCall()
    
 

        textViewAboutUs.placeholderText = "About Us"
        textViewAboutUs.createTextViewPlaceholder()
        textName.returnKeyType = .next
        textMobileNumber.returnKeyType = .default
        textName.delegate = self
        textMobileNumber.delegate = self
        
        buttonUploadImag.setAttributedTitle(NSAttributedString(string: "Upload Picture", attributes: [NSUnderlineStyleAttributeName: 1, NSFontAttributeName: PRIMARY_FONT(IS_IPAD() ? 20.0 : 16.0)!, NSForegroundColorAttributeName: UIColorRGB(57, g: 181, b: 74)!]), for: UIControlState())
        NavigationHelper.helper.headerViewController?.delegateButton = self
        self.textFieldEditable(false)
        self.backgroundImageView.image = UIImage(named: kTableViewBackgroundImage)
        if IS_OF_4_INCH() {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageCircle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_PROFILE
        if eprofileEditStatus == .kprofileEdit {
            NavigationHelper.helper.headerViewController?.addHeaderButton(KHeaderTickButton)
        }
        else {
            self.setFloatingButton()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        floatingBtn!.removeFromSuperview()
        floatingBtn!.removeButton()
    }
    
    
    // MARK- ******  ALL ACTION WORKING ****
    // MARK:- This Function selet the profile image
    @IBAction func actionUploadImg(_ sender: UIButton) {
        GPImagePickerController.pickImage(onController: self, sourceRect: IS_IPAD() ? self.buttonEditProfile.frame : nil, didPick: { (image) in
            self.profileImageBase64 = ""
            let imageData = image// info[UIImagePickerControllerOriginalImage] as? UIImage
            let pickedImage: Data = UIImagePNGRepresentation(imageData)!
          
            self.profileImageBase64 = pickedImage.base64EncodedString(options: .lineLength64Characters)
            self.imageUserProfile.image = imageData
        }) {
            
        }
    }
    func setBoaderColor(_ pTextView: UITextView)
    {
        pTextView.layer.borderWidth = 0.8;
        pTextView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    
    // MARK:- This Function Seleted the background image.
    @IBAction func actionEditProfile(_ sender: UIButton) {
        
        GPImagePickerController.pickImage(onController: self, sourceRect: IS_IPAD() ? self.buttonEditProfile.frame : nil, didPick: { (image) in
            self.backImageBase64 = ""
            let imageData = image// info[UIImagePickerControllerOriginalImage] as? UIImage
            let pickedImage: Data = UIImagePNGRepresentation(imageData)!
           
            self.backImageBase64 = pickedImage.base64EncodedString(options: .lineLength64Characters)
            self.imageProfileBG.image = imageData
        }) {
            
        }
    }
    // MARk:- This Function seleted the city.
    @IBAction func actionSelectCity(_ sender: UIButton) {
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
    // MARK:- this function Save the data or update the  profiel record.
    @IBAction func actionSave(_ sender: UIButton) {
        
        if !(self.ValidateFields())
        {
            print(" some thing is missing")
            return;
        }
        self.view.endEditing(true)
        self.imageConvertBase64()
    }
    // MARK:- This Function select the state
    @IBAction func actionState(_ sender: UIButton) {
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
    // MARK:- This Function Select the birth date
    @IBAction func actionBirthDate(_ sender: UIButton) {
        self.view.endEditing(true)
        GPPickerViewController.showPickerController(self, isDatePicker: true, pickerArray: [], position: .bottom, pickerTitle: "", preSelected: "") { (value, index) in
            
            if let strDateValue = value {
                self.textDateOfBirth.text = strDateValue as? String
            }
            
        }
    }
    
}


extension ProfileViewController {
    
    
    // MARK:- ****** USER DETAILS FUNCTION******
   
    // MARk:- This Function Call A User Details Api
    
    func  userDetailsApiCall(){
    APIHandler.handler.userDetails(forUser: Globals.sharedClient.userID!, success: { (response) in
       let dictUserDetails = response?.dictionary!["User"]
        let placesData = NSKeyedArchiver.archivedData(withRootObject: (dictUserDetails?.dictionaryObject)!)
        SET_OBJ_FOR_KEY(placesData as AnyObject , key: kUserLoginDetails)
        self.getUserDetails()
        print("User Details Response\(response)")
            self.getAllStateList()
    }) { (error) in
             Toast.show(withMessage: SOMETHING_WRONG)
        }
    }
    
    
    // MARK:- This functions get user details.
    func getUserDetails() {
        if let data = OBJ_FOR_KEY(kUserLoginDetails) as? Data {
            let mySavedList = NSKeyedUnarchiver.unarchiveObject(with: data)
            
           
           self.objUser = User(withDictionary: mySavedList as! [String: AnyObject])
            textName.text = self.objUser.name
            textMobileNumber.text = self.objUser.userContactNumber
            textState.text = self.objUser.StateName
            textCity.text = self.objUser.CityName
            self.pCityID = self.objUser.CityID
            self.pStateID = self.objUser.StateID
            if (self.objUser.userAboutUS) != "" {
                textViewAboutUs.placeholderLabel.isHidden = true
            } else {
                textViewAboutUs.placeholderLabel.isHidden = false
            }
            textViewAboutUs.text = self.objUser.userAboutUS
            
            if let birthDate = self.objUser.userBirthDate
            {
                let strBirthDate = birthDate
                textDateOfBirth.text = Date.convertTimeStampToBirthDate(strBirthDate)
            } else {
                textDateOfBirth.text = ""
            }
            self.setUserProfileImageBacgroundProfile()
            
        }
        
    }
    
    func setUserProfileImageBacgroundProfile(){
        let backgroundQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
        backgroundQueue.async(execute: {
            
            if let _ = self.objUser.profileImageOriginal{
              self.imageUserProfile.setImage(withURL: URL(string:self.objUser.profileImageOriginal!)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))
            }
            

            
         if let _ =  self.objUser.coverImageOriginal {
                  self.imageProfileBG.setImage(withURL: URL(string: self.objUser.coverImageOriginal!)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))
                }
               
            
            
            DispatchQueue.main.async(execute: {
                self.imageCircle()
            })
            
        })
        
   
    }
    
    // MARK:- *** Action Working****
    // This Function crete ImageView to  Circle
    func imageCircle() {
        self.imageUserProfile.layoutIfNeeded()
        self.imageUserProfile.layer.cornerRadius = self.imageUserProfile.frame.size.height / 2
        self.imageUserProfile.layer.borderWidth = 0.8;
        self.imageUserProfile.layer.borderColor = UIColorRGB(57, g: 181, b: 74)!.cgColor
        self.imageUserProfile.layer.masksToBounds = true
    }
    // mark-  ValidateFields
    func ValidateFields() -> Bool
    {
        self.view.endEditing(true)
        let result = true
        if self.textName.text == "" {
            Toast.show(withMessage: ENTER_USERNAME)
            return false
        }
        else if self.textMobileNumber.text == "" {
            Toast.show(withMessage: ENTER_MOBILE_NUMBER)
            return false
        }
        else if self.textState.text == "" {
            Toast.show(withMessage: ENTER_STATE)
            return false
        }
        else if self.textCity.text == "" {
            Toast.show(withMessage: ENTER_CITY)
            return false
        }
            
        else if self.textDateOfBirth.text == "" {
            Toast.show(withMessage: ENTER_BIRTH_DATE)
            return false
        }
        else if self.textViewAboutUs.text.trimString(forString: self.textViewAboutUs.text) == "" {
            Toast.show(withMessage: ENTER_ABOUT_US)
            return false
        }
        return result
    }
    
    // MARK:- This Function Convert the image to base 64.
    func imageConvertBase64(){
        if (self.profileImageBase64 != nil) && (self.backImageBase64 != nil)  {
            DispatchQueue.main.async(execute: {
                Helper.sharedClient.removeLoader(inview: self.view);
                self.editUserProfileApiCall()
                
            })
        }
        else{
            let dataProfileImage: Data = UIImagePNGRepresentation(self.imageUserProfile.image!)!
            self.profileImageBase64 = dataProfileImage.base64EncodedString(options: .lineLength64Characters)
            self.fileTypeProfileImag = MIMEType.mimeType(for: dataProfileImage)

            let imageSizeProfile: Int = dataProfileImage.count
            self.profileImgSize = imageSizeProfile / 1024
            
            let dataBackImage: Data = UIImagePNGRepresentation(self.imageProfileBG.image!)!
            self.backImageBase64 = dataBackImage.base64EncodedString(options: .lineLength64Characters)
            self.fileTypeBackImg = MIMEType.mimeType(for: dataProfileImage)
  
            let imageSizeBack: Int = dataBackImage.count
            self.backgroundImgSize = imageSizeBack / 1024
            
            if (self.profileImageBase64 != nil) && (self.backImageBase64 != nil)  {
                DispatchQueue.main.async(execute: {
                    Helper.sharedClient.removeLoader(inview: self.view);
                    self.editUserProfileApiCall()
                    
                })
                
            }
            
            
        }
    }
}



// MARK:- *** Floting Button Working ******8
extension ProfileViewController {
    func setFloatingButton() {
        
        floatingBtn = PDFloating(withPosition: .bottomRight, size: IS_IPAD() ? 45 : 40, numberOfPetals: 5, images: ["FloatingFollowing", "FloatingFollowers", "FloatingProject", "FloatingIdeas", "FloatingEditProfile"], labelStrings: ["My Followings", "My Followers", "My Projects", "My Ideas", "Edit Profile"])
        // floatingBtn!.setImage(UIImage(named: "CommentsFlootingEditIcon"), forState: .Normal)
        floatingBtn!.titleLabel?.font = UIFont(name: FONT_NAME, size: IS_IPAD() ? 40 : 30)
        floatingBtn!.setTitle("+", for: UIControlState())
        floatingBtn!.backgroundColor = UIColorRGB(57, g: 181, b: 74)
        floatingBtn!.layer.cornerRadius = floatingBtn!.layer.frame.height / 2
        floatingBtn!.buttonActionDidSelected = { (indexSelected) in
            self.didSelectMenuOptionAtIndex(indexSelected)
        }
        
        NavigationHelper.helper.mainContainerViewController?.view.addSubview(self.floatingBtn!)
    }
    
    func didSelectMenuOptionAtIndex(_ row: Int) {
        
        switch row {
        case 0:
            let followersListVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: FollowersViewController.self)) as! FollowersViewController
            followersListVC.showFlowerBtn = false
            followersListVC.titleText = TITLE_FOLLOWINGS
            NavigationHelper.helper.contentNavController!.pushViewController(followersListVC, animated: true)
            floatingBtn!.removeButton()
        case 1:
            let followersListVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: FollowersViewController.self)) as! FollowersViewController
            followersListVC.showFlowerBtn = true
            followersListVC.titleText = TITLE_FOLLOWERS
            NavigationHelper.helper.contentNavController!.pushViewController(followersListVC, animated: true)
            floatingBtn!.removeButton()
        case 2:
            
            if Globals.sharedClient.loginUserType == kInfluencer {
                let portfolioListingVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: ProjectListingController.self)) as! ProjectListingController
                portfolioListingVC.ePortfolioTitleStatus = .eMyPortfolioTitle
                NavigationHelper.helper.contentNavController!.pushViewController(portfolioListingVC, animated: true)
                floatingBtn!.removeButton()
            }
            else{
                Helper.sharedClient.showAlertView(inViewControler: self, alertMessge: SEEKER_ADD_PORTFOLIO_MESSAGE, indexValue: { (successIndex) in
                    if successIndex == 1{
                        let becomeInfluencerVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: BecomeInfluencerViewController.self)) as! BecomeInfluencerViewController
                        NavigationHelper.helper.contentNavController!.pushViewController(becomeInfluencerVC, animated: true)
                        
                    }
                })
            }
            
            
            
         
        case 3:
            let ideaListingVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: IdeaListingController.self)) as! IdeaListingController
            ideaListingVC.eIdeaListingTitleStaus = .eMyIdeaTitle
            ideaListingVC.eButtonEditStatus = .eButtonShow
            ideaListingVC.eIdeaListApiCallStatus = .eCallIdeaListApiWitUserID
            NavigationHelper.helper.contentNavController!.pushViewController(ideaListingVC, animated: true)
            
            floatingBtn!.removeButton()
        case 4:
            let userStatus = OBJ_FOR_KEY(kUserTypeStatus)
            if userStatus as! Int == 1 {
                let influncerProfileVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: InfluencerProfileViewController.self)) as! InfluencerProfileViewController
                NavigationHelper.helper.contentNavController!.pushViewController(influncerProfileVC, animated: true)
            }
                
            else {
                noRow = 8
                floatingBtn!.removeButton()
                self.eprofileEditStatus = .kprofileEdit
                self.textFieldEditable(true)
                self.tableView.reloadData()
            }
            
            // let editProfileVC = mainStoryboard.instantiateViewControllerWithIdentifier(String(InfluencerProfileViewController)) as! InfluencerProfileViewController
            // NavigationHelper.helper.contentNavController!.pushViewController(editProfileVC, animated: true)
            break
        default:
            "Nothing to do"
        }
    }
}

// MARK:-  **** API CALLING AND DELEGATE WORK
// MARK: UITextFieldDelegate methods

extension ProfileViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
    return noRow!
    }
    

    // MARK: UITableViewDelegate methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.row {
        case 0:
            return IS_IPAD() ? 300 : 230
        case 1..<6:
            return IS_IPAD() ? 60 : 55
        case 6:
            return IS_IPAD() ? 170 : 130
            
        default:
            // return IS_IPAD() ? 60 : 55
            return IS_IPAD() ? 90 : 70
        }
    }
    
    
    // TEXT FIELD DELAGT6E
    func textFieldEditable(_ isEditable: Bool) {
        if isEditable == true {
            self.getUserDetails()
            
            textName.isUserInteractionEnabled = isEditable
            self.buttonUploadImag.isHidden = false
            textMobileNumber.isUserInteractionEnabled = isEditable
            self.buttonEditProfile.isHidden = false
            buttonBirthDate.isUserInteractionEnabled = isEditable
            // textViewAboutUs.userInteractionEnabled = isEditable
            textViewAboutUs.isEditable = isEditable
            buttonSelectCity.isUserInteractionEnabled = isEditable
            buttonState.isUserInteractionEnabled = isEditable
            NavigationHelper.helper.headerViewController?.addHeaderButton(KHeaderTickButton)
        }
        else {
            self.buttonEditProfile.isHidden = true
            self.buttonUploadImag.isHidden = true
//            self.getUserDetails()
            textName.isUserInteractionEnabled = isEditable
            textCity.isUserInteractionEnabled = isEditable
            textState.isUserInteractionEnabled = isEditable
            textDateOfBirth.isUserInteractionEnabled = isEditable
            textMobileNumber.isUserInteractionEnabled = isEditable
            
            textViewAboutUs.isEditable = isEditable
            buttonBirthDate.isUserInteractionEnabled = isEditable
            buttonSelectCity.isUserInteractionEnabled = isEditable
            buttonState.isUserInteractionEnabled = isEditable
            NavigationHelper.helper.headerViewController?.addHeaderButton(KMenuButton)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.textName {
            self.textMobileNumber.becomeFirstResponder()
        }
        else if textField == self.textMobileNumber
        {
            textMobileNumber.resignFirstResponder()
            
        }
        
        return true
    }
    // User Define Deleagte
    // MARK:- Header Button Delagte
    func didTapMenuButton(_ strButtonType: String) {
        if strButtonType == KHeaderTickButton {
            if !(self.ValidateFields())
            {
                print(" some thing is missing")
                return;
            }
            self.view.endEditing(true)
            self.imageConvertBase64()
        } else {
            
        }
    }
    
    // MARK:- State get delegate
    func didFinishSelectedState(forItems dictValue: [String: AnyObject]?)
    {
        self.textState.text = ""
        self.textCity.text = ""
        self.pCityID = nil
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
    // Profile edit Api
    func editUserProfileApiCall() {
        
        APIHandler.handler.editSeekerProfileWith(forUserID: Globals.sharedClient.userID!, userName: self.textName.text!, userContactnumber: self.textMobileNumber.text!, userAddress: self.textCity.text!, aboutMe: self.textViewAboutUs.text!, userBirthDate: self.textDateOfBirth.text!, zipCode: String(self.objUser.zipCode!),cityID: self.pCityID!, stateID: self.pStateID!, prfileImageBase64: self.profileImageBase64, backImage64: self.backImageBase64, success: { (response) in
            
            print("UpuserDetails \(response?.dictionaryObject!)")
   
            let dictUserDetails = response?.dictionary!["User"]
            let placesData = NSKeyedArchiver.archivedData(withRootObject: (dictUserDetails?.dictionaryObject)!)
            
            SET_OBJ_FOR_KEY(placesData as AnyObject , key: kUserLoginDetails)
            
            Toast.show(withMessage: PROFILE_UPDTAE)
            
            
            self.getUserDetails()
            
            self.setFloatingButton()
            self.eprofileEditStatus = .kprofileNotEdit
            self.textFieldEditable(false)
            self.noRow = 7
            self.tableView.reloadData()
            
            // NavigationHelper.helper.contentNavController?.popViewControllerAnimated(true)
            
        }) { (error) in
            Toast.show(withMessage: PROFILE_NOT_UPDTAE)
            
        }
    }
    // Get State List....
    func getAllStateList() {
        APIHandler.handler.getStates({ (response) in
            self.arrStateList.removeAll()
            self.arrStateList = response!["states"].arrayObject! as [AnyObject]
            
            self.getCityWith(forStateID: self.objUser.StateID)
            print("\(response)")
            
        }) { (error) in
            
        }
    }
    // get City with state id
    func getCityWith(forStateID stateID: Int?) {
        APIHandler.handler.getCityList(forStateID: stateID!, success: { (response) in
            self.arrCityList.removeAll()
            self.arrCityList = response!["cities"].arrayObject! as [AnyObject]
            print("City Result\(response)")
        }) { (error) in
            
        }
    }
    
   
}

