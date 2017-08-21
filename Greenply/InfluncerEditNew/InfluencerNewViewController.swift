//
//  InfluencerNewViewController.swift
//  Greenply
//
//  Created by Jitendra on 4/4/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class InfluencerNewViewController: BaseTableViewController,SeacrhDelegateList,SkillsTagsDeleagte{
    
    var arrUserFieldDetails = [AnyObject]()
    var arrPlaceHolder = [String]()
    var arrImageTextField = [String]()
    var arrTextAreaFieldIndentifer = [String]()
    var arrImgText = [String]()
        var arrTotalExprienceData = [AnyObject]()
    var arrExprienceData = [AnyObject]()
    var arrTrainingData = [AnyObject]()
    var arrProfileData = [AnyObject]()
    var arrEducationData = [AnyObject]()
    var arrCertification = [AnyObject]()
    var arrSectionTitle = [String]()
    var arrTypicalJobCost = [AnyObject]()
    var arrSkillSData = [AnyObject]()
    var arrAreaServed = [AnyObject]()
   // var arrSelectedSkillsID = [String]()
    var arrSeletedTypicalJobCostID = [AnyObject]()
    var arrSeletedSkillsID = [String]()
    var list = [String]()
    var arrYear = [String]()
    var arrMonth = [String]()
    var  pArrTypicaJobTemp = [AnyObject]()
    var arrSkils = [AnyObject]()
    var arrTemp = [AnyObject]()
    var arrIndex = [IndexPath]()
    var arrEdu = [AnyObject]()
    var strTextFieldValue: String?
    var arrSeletedAreaServedItems = [AnyObject]()
    var arrState = [AnyObject]()
    var arrCity = [AnyObject]()
    var strSkillID : String = ""
    var arrSelectedCity = [AnyObject]()
    var pStateID: Int?
    var pCityID: Int?
    //Local variables
    var profileImgSize: Int!
    var backgroundImgSize: Int!
    var imgProfile: UIImage?
    var imgBackground: UIImage?
    var strName = String()
    var strStateName = String()
    var strCityName = String()
    var strContactNumber = String()
    var strTypiclJobCostID : Int?
    
    var strBirthDate = String()
    var strMonth: String?
    var strYear: String?
    var strImgProfileBase64: String?
    var strImageBackgroundBase64: String?
    var fileTypeProfileImag: String?
    var fileTypeBackImg: String?
    var isEdtableStatus: Bool?
    var floatingBtn: PDFloating?

    var  textFieldCell = TextFieldCellNew()
    
    var cellIndexVal = IndexPath()
    var textFieldIndexVal = IndexPath()
    var objUser: User!
    override func viewDidLoad()
    {
        
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        self.isEdtableStatus = false
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        self.tableView.estimatedRowHeight = 106.0
        self.initialSetup()
        self.getUSerDetailsApiCalling()
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //sweta code...
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
         self.getUserDetails()
        
        
        if isEdtableStatus == false{
            self.setFloatingButton()
        }
       
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_EDIT_PROFILE
        if isEdtableStatus == false{
          NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
        }else{
              NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true)
        }
        
      
        NavigationHelper.helper.tabBarViewController!.hideTabBar()

  
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
          floatingBtn!.removeButton()
           floatingBtn!.removeFromSuperview()

      
   }
    
    
    
}
// MARK:- WORKING User Defile
extension InfluencerNewViewController {
    // This Function Load initial
    func initialSetup(){
     
        for year in 0..<31 {
            arrYear.append(String(year))
        }
        
        for month in 1..<12 {
            arrMonth.append(String(month))
        }
        self.tableView.register(UINib(nibName: "TotalExperienceCustomCell", bundle: nil), forCellReuseIdentifier: "TotalExperienceCustomCell")
        self.tableView.register(UINib(nibName: "EductionCellCustom", bundle: nil), forCellReuseIdentifier: "EductionCellCustom")
        self.tableView.register(UINib(nibName: "CertificateTableCellCustom", bundle: nil), forCellReuseIdentifier: "CertificateTableCellCustom")
        self.tableView.register(UINib(nibName: "CheckBoxCustomCell", bundle: nil), forCellReuseIdentifier: "CheckBoxCustomCell")
  // self.tableView.registerNib(UINib(nibName: "TagsCustomCell", bundle: nil), forCellReuseIdentifier: "TagsCustomCell")
           self.tableView.register(UINib(nibName: "JATagsNew", bundle: nil), forCellReuseIdentifier: "JATagsNew")
        self.tableView.register(UINib(nibName: "AreaServedCustomCell", bundle: nil), forCellReuseIdentifier: "AreaServedCustomCell")
        self.tableView.register(UINib(nibName: "SubmitButtonCustom", bundle: nil), forCellReuseIdentifier: "SubmitButtonCustom")
        self.arrPlaceHolder = ["Name","Mobile Number","State","City","Date of Birth"]
        self.arrImgText = ["InfluencerName","InfluencerCall","InfluencerLocation","InfluencerCity","influencerBirth"]
        self.arrSectionTitle = ["Exprience","Traning","Total Experience","Experience","Traning","Eduction","Certificate","Skills","Typical Job Cost","Areas Served"]
        
    }
    // MARk: Crete A floting Button
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
    
    // Floting Button Action
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
      
                let portfolioListingVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: ProjectListingController.self)) as! ProjectListingController
                portfolioListingVC.ePortfolioTitleStatus = .eMyPortfolioTitle
                NavigationHelper.helper.contentNavController!.pushViewController(portfolioListingVC, animated: true)
                floatingBtn!.removeButton()
            
           
            
        case 3:
            let ideaListingVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: IdeaListingController.self)) as! IdeaListingController
            ideaListingVC.eIdeaListingTitleStaus = .eMyIdeaTitle
            ideaListingVC.eButtonEditStatus = .eButtonShow
            ideaListingVC.eIdeaListApiCallStatus = .eCallIdeaListApiWitUserID
            NavigationHelper.helper.contentNavController!.pushViewController(ideaListingVC, animated: true)
            
            floatingBtn!.removeButton()
        case 4:
            self.isEdtableStatus = true
            if isEdtableStatus == true{
                 NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true)
                        NavigationHelper.helper.enableSideMenuSwipe = false
                
               
            floatingBtn!.removeButton()
            }
            self.getAllStateList()
            self.getAllSkillsList()
            self.tableView.reloadData()
    
           
                default:
            "Nothing to do"
        }
        
    }
    
    // MARk:- This Function Hendal Typical job Code Check Box Button
    
    func actionCheckBox(_ sender : UIButton){
        var dictValue = [String: AnyObject]()
       arrTypicalJobCost.removeAll()
        arrSeletedTypicalJobCostID.removeAll()
        
        for index in 0..<pArrTypicaJobTemp.count{
            let objArrt = pArrTypicaJobTemp[index] as! UserFilterAttribute
            dictValue = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject] 
            arrTypicalJobCost.append(dictValue as AnyObject)
        }
        if dictValue.count > 0{
            let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.tableView)
            let cellIndexPath = self.tableView.indexPathForRow(at: pointInTable)
            var dictTEmp = self.arrTypicalJobCost[(cellIndexPath?.row)!] as! [String : AnyObject]
            dictTEmp["buttonStatus"] = true as AnyObject?
            self.strTypiclJobCostID =  dictTEmp["id"] as? Int
            arrSeletedTypicalJobCostID.append((dictTEmp["id"])!)
            
            self.arrTypicalJobCost.remove(at: (cellIndexPath?.row)!)
            self.arrTypicalJobCost.insert(dictTEmp as AnyObject, at: (cellIndexPath?.row)!)
        }
        
      
      //  self.strTypiclJobCostID = 0
        //self.makeLocalDictWith(forArrValue: self.pArrTypicaJobTemp, keyValue: KEY_TYPICAL_JOB)
        
       // self.tableView.reloadData()
        
    }
    // MARk:- ******* HEADER BUTTON ACTION ***************
    func actionHeader(_ sender: UIButton) {
        self.view.endEditing(true)
        let influencerDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: InfluencerProfileDetailsController.self)) as! InfluencerProfileDetailsController
        switch sender.tag {
        case 3:
            influencerDetailsVC.pArrData = self.arrExprienceData
            self.navigationController!.pushViewController(influencerDetailsVC, animated: true)
        case 4:
            influencerDetailsVC.pArrData = self.arrTrainingData
            self.navigationController!.pushViewController(influencerDetailsVC, animated: true)
        case 5:
            influencerDetailsVC.pArrData = self.arrEducationData
            self.navigationController!.pushViewController(influencerDetailsVC, animated: true)
        case 6:
            let certificateVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: InfluencerCertificationDetailsController.self)) as! InfluencerCertificationDetailsController
            certificateVC.arrCertificateList = self.arrCertification
            NavigationHelper.helper.contentNavController!.pushViewController(certificateVC, animated: true)
           
            // new Code for open skills
        case 7:
            
            let skillsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: TagViewController.self)) as! TagViewController
            
            skillsVC.delegateSkills  = self
               NavigationHelper.helper.contentNavController!.pushViewController(skillsVC, animated: true)
               
        case 9:
            let serviceAreaVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: ServiceAreaViewController.self)) as! ServiceAreaViewController
            // serviceAreaVC.delegate = self
            
            serviceAreaVC.didSelectState = { value in
                print("Data Stored\(value)")
                var mySavedList = [String: AnyObject]()
                //let dict =  value![0] as? [String:AnyObject]
                if let data = OBJ_FOR_KEY(kUserLoginDetails) as? Data {
                    mySavedList = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String: AnyObject]
                    
                    //self.arrAreaServed.append(value!)
                    mySavedList["serviceLocations"] = value as AnyObject?
                    
                    let placesData =  NSKeyedArchiver.archivedData(withRootObject: (mySavedList))
                    
                    SET_OBJ_FOR_KEY(placesData as AnyObject , key: kUserLoginDetails)
                    
                }
                
//                for i in 0..<value!.count
//                {
//                    let strStateID = value![i]["stateID"] as! Int
//                    let strStateName = value![i]["stateName"] as! String
//                    let pCityInfo = value![i]["cityInfo"] as! [AnyObject]
//                    debugPrint(strStateID)
//                    debugPrint(strStateName)
//                    debugPrint(pCityInfo)
//                    let dictLocal = ["stateID":strStateID, "stateName":strStateName, "cityInfo": pCityInfo]
//                    
//                    self.arrAreaServed.append(dictLocal)
//                    
//                }
//                
                
                self.tableView.reloadData()
                
                
                
            }
            
            NavigationHelper.helper.contentNavController!.pushViewController(serviceAreaVC, animated: true)
            //navigate search data....
            serviceAreaVC.arrDataList = arrAreaServed
            
        default: break
            
            
        }
        
    }
    
    // MARK:- User Define Deltegate Working
    
    // Skills list Delgete 
    
    func didFinishSelectedSkills(forSelectedAllTags pArrTags: [AnyObject]) {
      
        print("ALl Seleted TAgs \(pArrTags)")
        
        var mySavedList = [String: AnyObject]()
        
        if pArrTags.count > 0 {
            
            for index in 0..<pArrTags.count {
                
                let dictSkills = pArrTags[index] as! [String: AnyObject]
                
                if arrSkillSData.count > 0{
                    
                    
                  // check sklls already exist or not
                    
                    self.checkSkillsExistWith(arrSkillSData, keySearch: dictSkills["skill_name"] as! String, isExistTags: { (isSkillsAlredyExist) in
                    
                        
                        if isSkillsAlredyExist == false{
                            let dictTemp = ["skill_name":dictSkills["skill_name"] as! String, "id":dictSkills["id"] as! Int] as [String : Any]
                            self.arrSkillSData.append(dictTemp as AnyObject)
                        }
                    })
                    
                }else{
                    // if arrSkillSData count 0
                    let dictTemp = ["skill_name":dictSkills["skill_name"] as! String, "id":dictSkills["id"] as! Int] as [String : Any]
                    self.arrSkillSData.append(dictTemp as AnyObject)
                    
                }
                
                
            }
            
            if let data = OBJ_FOR_KEY(kUserLoginDetails) as? Data {
                mySavedList = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String: AnyObject]
            
                mySavedList["skills"] =  arrSkillSData as AnyObject?
                
                let placesData =  NSKeyedArchiver.archivedData(withRootObject: (mySavedList))
                
                SET_OBJ_FOR_KEY(placesData as AnyObject , key: kUserLoginDetails)
                
            }
            
           
            
        }
       
        self.tableView.reloadData()
        
    }
    
    
    
    // Add skills ID
    func checkSkillsExistWith(_ pArry: [AnyObject], keySearch: String, isExistTags:(_ isSkillsAlredyExist:Bool)->())
    {
        // var arrSelectedSkillsID = [String]()
        let name = NSPredicate(format: "skill_name contains[c] %@", keySearch)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
        let filteredArray = pArry.filter { compoundPredicate.evaluate(with: $0) }
        
        if filteredArray.count > 0{
          
        isExistTags(true)
            
        }else{
        isExistTags(false)
        }
    }
    
    
    
    // MARk:- ACTIOn Month And Year,
    func actionYear(_ sender: UIButton){
        let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView.indexPathForRow(at: pointInTable)
        let cell = self.tableView.cellForRow(at: cellIndexPath!) as! TotalExperienceCustomCell
        GPPickerViewController.showPickerController(self, isDatePicker: false, pickerArray: arrYear, position: .bottom, pickerTitle: "", preSelected: "") { (value, index) in
            self.strYear = value as? String
            var tempData =  self.arrTotalExprienceData[cellIndexPath!.row] as![String: AnyObject]
            tempData["yearExp"] = value as? String as AnyObject?
            self.arrTotalExprienceData.remove(at: (cellIndexPath?.row)!)
            self.arrTotalExprienceData.insert(tempData as AnyObject, at: (cellIndexPath?.row)!)
     
            cell.btnYear.setTitle(value! as? String, for: UIControlState())
        }
    }
    func actionMonth(_ sender: UIButton){
        
        
        let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView.indexPathForRow(at: pointInTable)
        let cell = self.tableView.cellForRow(at: cellIndexPath!) as! TotalExperienceCustomCell
        GPPickerViewController.showPickerController(self, isDatePicker: false, pickerArray: arrMonth, position: .bottom, pickerTitle: "", preSelected: "") { (value, index) in
            self.strMonth = value as? String
            var tempData =  self.arrTotalExprienceData[cellIndexPath!.row] as![String: AnyObject]
            tempData["monthExp"] = value as? String as AnyObject?
            self.arrTotalExprienceData.remove(at: (cellIndexPath?.row)!)
            self.arrTotalExprienceData.insert(tempData as AnyObject, at: (cellIndexPath?.row)!)
            cell.btnMonth.setTitle(value! as? String, for: UIControlState())
            
        }
    }
    // MARk: This Fuction Set the Profile Image And Bagground image
    // MARk: This Fuction Set the Profile Image And Bagground image
    func actionSetProfileImage(_ sender: UIButton){
        
        let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView.indexPathForRow(at: pointInTable)
        let cell = self.tableView.cellForRow(at: cellIndexPath!) as! ProfileCellNew
        GPImagePickerController.pickImage(onController: self, sourceRect:IS_IPAD() ? sender.frame : nil, didPick: { (image) in
            
            
            self.imgProfile = image
            let pickedImage: Data = UIImagePNGRepresentation(image)!
            self.strImgProfileBase64 = pickedImage.base64EncodedString(options: .lineLength64Characters)
            var tempData =  self.arrProfileData[cellIndexPath!.row] as![String: AnyObject]
            cell.imgProfile.image  =   self.imgProfile
             tempData["imageProfile"] =   self.imgProfile!
           self.arrProfileData.remove(at: (cellIndexPath?.row)!)
            self.arrProfileData.insert(tempData as AnyObject, at:(cellIndexPath?.row)!)
            
            })
        {
            
        }
    }
    func actionSetBGImage(_ sender: UIButton){
        let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView.indexPathForRow(at: pointInTable)
        let cell = self.tableView.cellForRow(at: cellIndexPath!) as! ProfileCellNew
        GPImagePickerController.pickImage(onController: self, sourceRect:IS_IPAD() ? sender.frame : nil, didPick: { (image) in
            
            self.imgBackground = image
            let pickedImage: Data = UIImagePNGRepresentation(image)!
            self.strImageBackgroundBase64 = pickedImage.base64EncodedString(options: .lineLength64Characters)
            cell.imgBG.image =   self.imgBackground
            var tempData =  self.arrProfileData[cellIndexPath!.row] as![String: AnyObject]
            cell.imgBG.image  =  self.imgBackground
            self.arrProfileData.remove(at: (cellIndexPath?.row)!)
            tempData["imageBG"] =  self.imgBackground!
             self.arrProfileData.insert(tempData as AnyObject, at:(cellIndexPath?.row)!)
            })
        {
            
        }
    }
    
    
    
    // This Function action of text field items
    func actionTextFieldItems(_ sender: UIButton!)
    {
        let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.tableView)
        let cellIndexPath = self.tableView.indexPathForRow(at: pointInTable)
        textFieldCell = self.tableView.cellForRow(at: cellIndexPath!) as! TextFieldCellNew
        
        
        
        if cellIndexPath?.row == 2 // This is state action
        {
            if self.arrState.count > 0 {
                let searchVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: SearchTableViewController.self)) as! SearchTableViewController
                searchVC.arrPData = self.arrState
                searchVC.eStateCityStatus = .eStateSeleted
                searchVC.delegate = self
                self.cellIndexVal = cellIndexPath!
                
                self.navigationController?.pushViewController(searchVC, animated: true)
            }else{
                Toast.show(withMessage: STATE_ERROR)
            }
            
        }
        else if cellIndexPath?.row == 3  // This a city action
        {
            if self.arrCity.count > 0 {
                let searchVC = loginStoryboard.instantiateViewController(withIdentifier: String(describing: SearchTableViewController.self)) as! SearchTableViewController
                searchVC.arrPData = self.arrCity
                searchVC.eStateCityStatus = .eCitySeleted
                searchVC.delegate = self
                self.cellIndexVal = cellIndexPath!
                self.navigationController?.pushViewController(searchVC, animated: true)
                
            }else{
                Toast.show(withMessage: CITY_ERROR)
            }
            
            
        }
            
        else if cellIndexPath?.row == 4  // this is date of birth action
        {
            
            self.view.endEditing(true)
            GPPickerViewController.showPickerController(self, isDatePicker: true, pickerArray: [], position: .bottom, pickerTitle: "", preSelected: "") { (value, index) in
                let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.tableView)
                let cellIndexPath = self.tableView.indexPathForRow(at: pointInTable)
                let cell = self.tableView.cellForRow(at: cellIndexPath!) as! TextFieldCellNew
                if let strDateValue = value {
                    cell.txtTitle.text =  strDateValue as? String
                    var dict = self.arrUserFieldDetails[(cellIndexPath?.row)!] as? [String:AnyObject]
                    dict!["titleValue"] = strDateValue
                    self.strBirthDate =  (strDateValue as? String)!
                    self.arrUserFieldDetails[cellIndexPath!.row] = dict! as AnyObject
                    
                    
                }
            }
        }
        
    }
    
    func inserRowTableViewWithIndex(_ indexValue:Int){
        arrTemp.removeAll()
        arrIndex.removeAll()
        
        arrTemp = arrEducationData
        
        for index in 0..<arrTemp.count {
            
            arrIndex.append(IndexPath(row: index, section:indexValue))
            
        }
        arrEdu = arrTemp
        
        self.tableView.insertRows(at: arrIndex, with: .automatic)
        
    }
    // This Function GEt A user Details
    func getUserDetails() {
        
        self.removeArrayList()
        var dictLocal:  [String: AnyObject]?

        var strImgProfile = ""
        var strImgBg = ""
        if let data = OBJ_FOR_KEY(kUserLoginDetails) as? Data {
            let mySavedList = NSKeyedUnarchiver.unarchiveObject(with: data)
            self.objUser = User(withDictionary: mySavedList as! [String: AnyObject])
                
            

           
            self.praseAreaServedWith(forArrAreaServed: self.objUser.arrAreaServed)
            
           self.prseSkillsListDefult(forArrSkillList: self.objUser.arrSkillsList)
        
            
            
            
            self.pStateID = self.objUser.StateID
            self.pCityID = self.objUser.CityID
           self.strTypiclJobCostID = objUser.typialJobCostID
            // ********* Typical Job Code Section ***************
            
    
            
            
            // ********* Profile Section ***************
            if let _ = self.objUser.profileImageOriginal{
                strImgProfile = self.objUser.profileImageOriginal!
                
           
                if self.imgProfile == nil{
                   self.downloadImage(forImageURl: strImgProfile, keyVale: KEY_PROFILE)
                }
            }
            else{
                strImgProfile = "DefultProfileImage"
            }
            
            if let _ = self.objUser.coverImageOriginal{
                strImgBg = self.objUser.coverImageOriginal!
                if self.imgBackground == nil{
                    self.downloadImage(forImageURl: strImgBg, keyVale: KEY_BACKGROUND_IMAGE)

                }
            }
            else{
                strImgBg = "DefultProfileImage"
            }
            
            
            dictLocal = ["imageProfile":strImgProfile as AnyObject, "imageBG": strImgBg as AnyObject]
            self.arrProfileData.append(dictLocal! as AnyObject)
            
            // ********* Total Year Experince Section ***************
            dictLocal = ["yearExp":self.objUser.expYear! as AnyObject, "monthExp": self.objUser.expMonths! as AnyObject]
            
            self.strYear  = self.objUser.expYear
            self.strMonth  = self.objUser.expMonths
            
            arrTotalExprienceData.append(dictLocal! as AnyObject)
            
            // ********* Text Field Section ***************
            if let birthDate = self.objUser.userBirthDate
            {
                strBirthDate = Date.convertTimeStampToBirthDate(birthDate)
               
                
                
            }else {
                strBirthDate  = ""
            }
            
            
            strName = self.objUser.name!
            strContactNumber = self.objUser.userContactNumber!
            strStateName = self.objUser.StateName!
            strCityName =  self.objUser.CityName!
          
            let arrTempData = [self.objUser.name!, self.objUser.userContactNumber!, self.objUser.StateName!, self.objUser.CityName!,strBirthDate]
            self.makeLocalDictWith(forArrValue: arrTempData as [AnyObject], keyValue: KEY_USER_DETAILS)
            
            
            // ********* Work exprience  Section ***************
            if self.objUser.arrExperienceList.count > 0 {
                var pExperience = [AnyObject]()
                for index in 0..<self.objUser.arrExperienceList.count{
                    pExperience.append(self.objUser.arrExperienceList[index])
                    
                }
                self.makeLocalDictWith(forArrValue:pExperience, keyValue: KEY_EXPRIENCE)
                
            }
            // ********* Traning   Section ***************
            if self.objUser.arrTraningList.count > 0 {
                var pTraning = [AnyObject]()
                for index in 0..<self.objUser.arrTraningList.count{
                    pTraning.append(self.objUser.arrTraningList[index])
                }
                self.makeLocalDictWith(forArrValue: pTraning, keyValue: KEY_TRANING)
            }
            // ********* Eduction  Section ***************
            if self.objUser.arrEducationList.count > 0{
                var pEduction = [AnyObject]()
                for index in 0..<self.objUser.arrEducationList.count{
                    pEduction.append(self.objUser.arrEducationList[index])
                }
                self.makeLocalDictWith(forArrValue: pEduction, keyValue: KEY_EDUCATION)
            }
            // ********* Certificate Section ***************
            if self.objUser.arrCertificationsList.count > 0{
                var pCertificate = [AnyObject]()
                
                for index in 0..<self.objUser.arrCertificationsList.count{
                    pCertificate.append(self.objUser.arrCertificationsList[index])
                }
                self.makeLocalDictWith(forArrValue: pCertificate, keyValue: KEY_CERTIFICATE)
                
            }
            
        }
    }
    // This Function Make A local Dict
    func makeLocalDictWith(forArrValue pArrData:[AnyObject], keyValue: String!){
        if keyValue == KEY_USER_DETAILS{
            
            for index in 0..<pArrData.count{
                let dictLocal = ["titleValue":pArrData[index] as! String, "imageValue": self.arrImgText[index], "placeHolderValue": self.arrPlaceHolder[index]]
                self.arrUserFieldDetails.append(dictLocal as AnyObject)
            }
        }
            
            // ********* Set exprience Section ***************
            
            //        else if keyValue == KEY_AREA_SERV
            //        {
            //
            //
            //        }
        else if keyValue == KEY_EXPRIENCE{
            for index in 0..<pArrData.count{
                let objExp = pArrData[index] as! UserExperience
                
                let dictValue = ["id":objExp.pId! ,"organisation_name": objExp.organisation_name!, "start_date": objExp.startDate!, "end_date":objExp.endDate!,"ButtonTitle":"Edit","KeyVale":KEY_EXPRIENCE] as [String : Any]
                self.arrExprienceData.append(dictValue as AnyObject)
            }
        }
            // ********* Set Traning Section ***************
        else if keyValue == KEY_TRANING{
            
            for index in 0..<pArrData.count{
                let objTring = pArrData[index] as! UserTraining
                
                let dictValue = ["id":objTring.pId! ,"training_name": objTring.training_name!, "start_date":  objTring.startDate!, "end_date":objTring.endDate!,"ButtonTitle":"Edit", "KeyVale":KEY_TRANING] as [String : Any]
                self.arrTrainingData.append(dictValue as AnyObject)
            }
            
        }
            // ********* Set Educaton Section ***************
        else if keyValue == KEY_EDUCATION{
            for index in 0..<pArrData.count{
                let objEdu = pArrData[index] as! UserEducation
                let dictValue = ["id":objEdu.pId! ,"degree": objEdu.degreeName!, "stream": objEdu.stream!, "start_date": objEdu.startDate!, "end_date":objEdu.endDate!,"ButtonTitle":"Edit", "KeyVale":KEY_EDUCATION] as [String : Any]
                self.arrEducationData.append(dictValue as AnyObject)
            }
        }
            
            // ********* Set Certificate Section ***************
        else if keyValue == KEY_CERTIFICATE{
            for index in 0..<pArrData.count{
                let objCerti = pArrData[index] as! UserCertificates
              //  let dictValue = ["id":objCerti.pId! ,"title": objCerti.title!, "files": objCerti.certificateFile!]
                
                  let dictValue = ["id":objCerti.pId! ,"title": objCerti.title!, "certificate": objCerti.dictCertItemsList,"keyValue":KEY_CERTIFICATE_INFLUENCER] as [String : Any]
                self.arrCertification.append(dictValue as AnyObject)
            }
        }
            
            // ********* Set Typical Job Cost Section ***************
        else if keyValue == KEY_TYPICAL_JOB{
            self.arrTypicalJobCost.removeAll()
            self.arrSeletedTypicalJobCostID.removeAll()
            var dictValue = [String: AnyObject]()
            for index in 0..<pArrData.count{
                let objArrt = pArrData[index] as! UserFilterAttribute
               
              
                if self.objUser.typialJobCostID == objArrt.id{
                     self.arrSeletedTypicalJobCostID.append(objArrt.id! as AnyObject)
                    dictValue = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": true as AnyObject]
                }else{
                   dictValue = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject]
                }
               
                self.arrTypicalJobCost.append(dictValue as AnyObject)
            }
            
            //sweta Code...
            
        }
        
    
    self.tableView.reloadData()
    
    }
    
    // Add skills ID 
    func addSkillsWith(_ pArry: [AnyObject], keySearch: String)
    {   var dictTemp = [String: AnyObject]()
       // var arrSelectedSkillsID = [String]()
        let name = NSPredicate(format: "skill_name contains[c] %@", keySearch)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
        let filteredArray = pArry.filter { compoundPredicate.evaluate(with: $0) }
        
        if filteredArray.count > 0{
            let dict = filteredArray.first
            
            if let dictFilter = dict {
                if let _ = dict!["id"] {
                    let index = dictFilter["id"] as! Int
                    
                   arrSeletedSkillsID.append(String(index))
                  dictTemp = ["skill_name":dictFilter["skill_name"]!! as AnyObject, "id":dictFilter["id"] as! Int as AnyObject]
                    self.arrSkillSData.append(dictTemp as AnyObject)
                    
                }
            }
        }else{
            dictTemp = ["skill_name":keySearch as AnyObject, "id":0 as AnyObject]
           arrSeletedSkillsID.append(keySearch)
            self.arrSkillSData.append(dictTemp as AnyObject)
        }
        

        
     
    }
    
    // Remove Tags
    func removeTagsID(_ pArry: [AnyObject], keySearch: String)
    {
        let name = NSPredicate(format: "skill_name contains[c] %@", keySearch)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
        let filteredArray = pArry.filter { compoundPredicate.evaluate(with: $0) }
        
        if filteredArray.count > 0{
            let dict = filteredArray.first
            
            if let dictFilter = dict {
                if let _ = dict!["id"] {
                    let index = dictFilter["id"] as! Int
                    
                    self.deleteSkillsApiCallingWith(forSkillsID: dict!["id"] as? Int,indexValue:index)
                    
                    
                }
            }
        }else{
         
        }
        
       
    }
    
    
    // This Functon Download Image
    func downloadImage(forImageURl imageURL: String, keyVale:String) {
        print("Download Started")
      
        
       
        // Create Url from string
        let url = URL(string: imageURL)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    if keyVale == KEY_PROFILE{
                       
                        self.imgProfile = UIImage(data: data)
                   
                    
                    }
                    else if keyVale == KEY_BACKGROUND_IMAGE{
                        self.imgBackground = UIImage(data: data)
 
                    }
                })
            }
        }) 
        
        // Run task
        task.resume()
    }
    
    
    
    // MARK:- This Function Convert the image to base 64.
func imageConvertBase64(){
if (self.strImgProfileBase64 != nil) && (self.strImageBackgroundBase64 != nil)  {
            DispatchQueue.main.async(execute: {
                Helper.sharedClient.removeLoader(inview: self.view);
                self.editInfluncerApiCalling()
                
            })
        }
        else{
            let dataProfileImage: Data = UIImagePNGRepresentation(self.imgProfile!)!
            self.strImgProfileBase64 = dataProfileImage.base64EncodedString(options: .lineLength64Characters)
            self.fileTypeProfileImag = MIMEType.mimeType(for: dataProfileImage)
            
            let imageSizeProfile: Int = dataProfileImage.count
            self.profileImgSize = imageSizeProfile / 1024
            
            let dataBackImage: Data = UIImagePNGRepresentation(self.imgBackground!)!
            self.strImageBackgroundBase64 = dataBackImage.base64EncodedString(options: .lineLength64Characters)
            self.fileTypeBackImg = MIMEType.mimeType(for: dataProfileImage)
            
            let imageSizeBack: Int = dataBackImage.count
            self.backgroundImgSize = imageSizeBack / 1024
            
            if (self.strImgProfileBase64 != nil) && (self.strImageBackgroundBase64 != nil)  {
                DispatchQueue.main.async(execute: {
                    Helper.sharedClient.removeLoader(inview: self.view);
                      self.editInfluncerApiCalling()
                    
                })
                
            }
            
            
        }
    }
    
    // This Function Set State name and City
    //MARK:Set state.
    func setSateCityWithValue(forItems pDict: [String: AnyObject]?, keyValue: String?)
    {
        if keyValue == KEY_STATE{
            textFieldCell = self.tableView.cellForRow(at: cellIndexVal) as! TextFieldCellNew
            textFieldCell.txtTitle.text = pDict!["name"] as? String
            self.strStateName = (pDict!["name"] as? String)!
            var dict = arrUserFieldDetails[(cellIndexVal.row)] as? [String:AnyObject]
            dict!["titleValue"] = pDict!["name"] as? String as AnyObject?
            self.pStateID = pDict!["id"] as? Int
            self.strStateName = (pDict!["name"] as? String)!
            
            arrUserFieldDetails.remove(at: (cellIndexVal.row))
            arrUserFieldDetails.insert(dict! as AnyObject, at:(cellIndexVal.row))
            self.getCityWith(forStateID: self.pStateID!)  // call city list with state ID
            
            let row = (cellIndexVal.row) + 1
            let section = cellIndexVal.section
            let tempIndexPath = IndexPath(row: row, section: section)
            // Just city cell blank
            let cell = self.tableView.cellForRow(at: tempIndexPath) as! TextFieldCellNew
            cell.txtTitle.text = ""
            dict = arrUserFieldDetails[(tempIndexPath.row)] as? [String:AnyObject]
            dict!["titleValue"] =  "" as AnyObject?
            self.strCityName = ""
            arrUserFieldDetails.remove(at: tempIndexPath.row)
            arrUserFieldDetails.insert(dict! as AnyObject, at:(tempIndexPath.row))
            
        }
            // Set City Value
        else if keyValue == KEY_CITY{
            let cell = self.tableView.cellForRow(at: cellIndexVal) as! TextFieldCellNew
            cell.txtTitle.text = pDict!["name"] as? String
            self.strCityName = (pDict!["name"] as? String)!
            var dict = arrUserFieldDetails[(cellIndexVal.row)] as? [String:AnyObject]
            dict!["titleValue"] =  pDict!["name"] as? String as AnyObject?
            self.strStateName = (pDict!["name"] as? String)!
            arrUserFieldDetails.remove(at: cellIndexVal.row)
            arrUserFieldDetails.insert(dict! as AnyObject, at:(cellIndexVal.row))
        }
    }
    // This Function Validate The fiels.
    //Mark:- Validate Fields...
    func ValidateFields() -> Bool
    {
        self.setTagesWithId()
        
        let result = true
        self.view.endEditing(true)
        if strName == "" {
            Toast.show(withMessage: ENTER_USERNAME)
            return false
        } else if strContactNumber == "" {
            Toast.show(withMessage: ENTER_MOBILE_NUMBER)
            return false
        } else if strStateName == "" {
            Toast.show(withMessage: ADDRESS)
            return false
        } else if strCityName == "" {
            Toast.show(withMessage: ABOUTUS)
            return false
        }
        else if strBirthDate == "" {
            Toast.show(withMessage: ENTER_BIRTH_DATE)
            return false
        }
        
        else if strYear == "" {
            Toast.show(withMessage: ENTER_TOTAL_EXPERIENCE_YEAR)
            return false
        }
        else if strMonth == "" {
            Toast.show(withMessage: ENTER_TOTAL_EXPERIENCE_MONTH)
            return false
        }
        else if self.arrExprienceData.count == 0 {
            Toast.show(withMessage: ENTER_EXPERIENCE)
        }
        else if self.arrTotalExprienceData.count == 0 {
            Toast.show(withMessage: ENTER_TRAINING)
        }
        else if self.arrEducationData.count == 0 {
            Toast.show(withMessage: ENTER_EDUCATION)
        }
        else if self.arrCertification.count < 0 {
            Toast.show(withMessage: ENTER_CERTIFICATION)
        }
        else if self.arrAreaServed.count < 0 {
            Toast.show(withMessage: SELECT_SERVICE_LOCATIONS)
        }

        return result
    }
    
    // This Funtion Just Remove Arr
    func removeArrayList(){
   
        self.arrExprienceData.removeAll()
        self.arrTrainingData.removeAll()
        self.arrEducationData.removeAll()
        self.arrCertification.removeAll()
        //self.arrAreaServed.removeAll()
  
       // self.arrSkillSData.removeAll()
        self.arrTotalExprienceData.removeAll()
        
    }
    
    // This Function Save / update record action
    func actionSaveButtonTap(_ sender: UIButton){
        if !(self.ValidateFields())
        {
            print(" some thing is missing")
            return;
        }
        
        // its validate then call api.
        
        self.view.endEditing(true)
        self.imageConvertBase64()
    }
    // MARk:- set Tabgs
    
    func setTagesWithId()
    {
        
    strSkillID  = arrSeletedSkillsID.joined(separator: ",")
        
    }
    
}
// MARK:- Delegete work hear.
extension InfluencerNewViewController {
    // MARK: UITableViewDataSource methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.isEdtableStatus == true {
            return 11
            
        }
        else{
            return 6
        }
        
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isEdtableStatus == true {
            switch section {
                
            case 0:
                return 1
            case 1:
                return arrImgText.count
            case 2:
                return arrTotalExprienceData.count
            case 3:
                return arrExprienceData.count
            case 4:
                return arrTrainingData.count
            case 5:
                return arrEducationData.count
            case 6:
                return 1// self.arrCertification.count
                
            case 7:
                return 1 // arrSkillSData.count
                
            case 8:
                return arrTypicalJobCost.count
            case 9:
                return arrAreaServed.count
            case 10:
                return 1
            default:
                return 0
            }
        }
            
            
        else{
            switch section {
                
            case 1:
                return arrImgText.count
            default:
                return 1
            }
        }
        
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.isEdtableStatus == true {
            
            switch section {
            case 0,1,10:
                return nil
            default:
                let viewHeader = SectionHeader.instantiateFromNib()
                viewHeader.lblSectionTitle.text = arrSectionTitle[section]
                viewHeader.btnSectionHeader.tag = section
                viewHeader.btnSectionHeader.addTarget(self, action:#selector(actionHeader), for:.touchUpInside)
                return viewHeader
                
            }
            
        }
        else{
            return nil
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isEdtableStatus == true {
            switch section {
            case 0,1:
                return 0.0
            default:
                return 55
            }
            
        }
        
        else{
            return 0.0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: BaseTableViewCell?
        
        if isEdtableStatus == true {
            
            switch indexPath.section {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileCellNew.self), for: indexPath) as! ProfileCellNew
                (cell as! ProfileCellNew).lblProfileImg.isHidden = false
                (cell as! ProfileCellNew).btnBGImg.isHidden = false
                (cell as! ProfileCellNew).btnProfleImg.isHidden = false
                (cell as! ProfileCellNew).btnProfleImg.addTarget(self, action:#selector(actionSetProfileImage), for:.touchUpInside)
                (cell as! ProfileCellNew).btnBGImg.addTarget(self, action:#selector(actionSetBGImage), for:.touchUpInside)
                
                (cell as! ProfileCellNew).datasource = self.arrProfileData[indexPath.row]
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextFieldCellNew.self), for: indexPath) as! TextFieldCellNew
                (cell as! TextFieldCellNew).txtTitle.tag = indexPath.row
                (cell as! TextFieldCellNew).txtTitle.delegate = self
                (cell as! TextFieldCellNew).btnTextItems.tag = indexPath.row
                
                (cell as! TextFieldCellNew).btnTextItems.addTarget(self, action:#selector(actionTextFieldItems), for:.touchUpInside)
                
                (cell as! TextFieldCellNew).datasource = self.arrUserFieldDetails[indexPath.row]
                
                
                
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TotalExperienceCustomCell.self), for: indexPath) as! TotalExperienceCustomCell
               
                (cell as! TotalExperienceCustomCell).datasource = self.arrTotalExprienceData[indexPath.row]
                (cell as! TotalExperienceCustomCell).btnYear.addTarget(self, action:#selector(actionYear), for:.touchUpInside)
                (cell as! TotalExperienceCustomCell).btnMonth.addTarget(self, action:#selector(actionMonth), for:.touchUpInside)
                
                
            case 3,4,5:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EductionCellCustom.self), for: indexPath) as! EductionCellCustom
                if indexPath.section == 3{
                    (cell as! EductionCellCustom).datasource = self.arrExprienceData[indexPath.row]
                }
                else if indexPath.section == 4{
                    (cell as! EductionCellCustom).datasource = self.arrTrainingData[indexPath.row]
                }
                else if indexPath.section == 5{
                    (cell as! EductionCellCustom).datasource = self.arrEducationData[indexPath.row]
                }
            case 6:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CertificateTableCellCustom.self), for: indexPath) as! CertificateTableCellCustom

                (cell as! CertificateTableCellCustom).dataSource = self.arrCertification
                
              
                
            case 7:
               // cell = tableView.dequeueReusableCellWithIdentifier(String(TagsCustomCell), forIndexPath: indexPath) as! TagsCustomCell
//                (cell as! TagsCustomCell).datasource = self.arrSkillSData[indexPath.row]
//                (cell as! TagsCustomCell).aTagView.delegate = self
//                (cell as! TagsCustomCell).aTagView.backgroundColor = .whiteColor()
                
                
                
                
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: JATagsNew.self), for: indexPath) as! JATagsNew
                
                (cell as! JATagsNew).buttonTagsHandler = {(dictValue,indexValue) in
                    
                    if (dictValue["id"] as? Int) != 0 {
                        self.deleteSkillsApiCallingWith(forSkillsID: dictValue["id"] as? Int, indexValue: indexValue)
                        
                      
                    }
                    else{
                        self.arrSkillSData.remove(at: indexValue)
          
                        self.tableView.reloadData()
                    }
                    
                  
                    
                }
                (cell as! JATagsNew).dataSource = self.arrSkillSData
                
                
            case 8:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckBoxCustomCell.self), for: indexPath) as! CheckBoxCustomCell
                (cell as! CheckBoxCustomCell).btnTypicalTitle.addTarget(self, action: #selector(self.actionCheckBox(_:)), for: .touchUpInside)
                (cell as! CheckBoxCustomCell).datasource = self.arrTypicalJobCost[indexPath.row]
                
              
                
            case 9:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AreaServedCustomCell.self), for: indexPath) as! AreaServedCustomCell
                (cell as! AreaServedCustomCell).datasource = self.arrAreaServed[indexPath.row]
            case 10:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SubmitButtonCustom.self), for: indexPath) as! SubmitButtonCustom
                (cell as! SubmitButtonCustom).btnSave.tag = indexPath.row
                (cell as! SubmitButtonCustom).btnSave.addTarget(self, action:#selector(actionSaveButtonTap), for:.touchUpInside)
            default: break
                
            }
            cell!.isUserInteractionEnabled  = true
            return cell!
            
        }
            
            
        else{
            switch indexPath.section {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileCellNew.self), for: indexPath) as! ProfileCellNew
                
                (cell as! ProfileCellNew).lblProfileImg.isHidden = true
                (cell as! ProfileCellNew).btnBGImg.isHidden = true
                (cell as! ProfileCellNew).btnProfleImg.isHidden = true
                (cell as! ProfileCellNew).datasource = self.arrProfileData[indexPath.row]
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextFieldCellNew.self), for: indexPath) as! TextFieldCellNew
                (cell as! TextFieldCellNew).datasource = self.arrUserFieldDetails[indexPath.row]
                
                
            case 2,3,4:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextAreaDataCellNew.self), for: indexPath) as! TextAreaDataCellNew
                if indexPath.section == 2{
                    (cell as! TextAreaDataCellNew).datasource = self.arrExprienceData[indexPath.row]
                }else if indexPath.section == 3{
                    (cell as! TextAreaDataCellNew).datasource = self.arrTrainingData[indexPath.row]
                } else if indexPath.section == 4{
                    (cell as! TextAreaDataCellNew).datasource = self.arrEducationData[indexPath.row]
                }
                
            case 5:
                
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AboutUsCellNew.self), for: indexPath) as! AboutUsCellNew
                (cell as! AboutUsCellNew).lblAboutUs.text = self.objUser.userAboutUS
                
            default: break
                
            }
            cell!.isUserInteractionEnabled  = false
            
            
            return cell!
            
        }
        
        
        
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if isEdtableStatus == true{
            switch indexPath.section {
            case 0:
                return IS_IPAD() ? 300 : 230
            case 1:
                return IS_IPAD() ? 60 : 55
            case 2:
                return IS_IPAD() ? 140 : 100
            case 3,4:
                return IS_IPAD() ? 140 : 120
            case 5:
                return IS_IPAD() ? 170 : 160
            case 6:
                return IS_IPAD() ? 200 : 180
//            case 7:
//                 return 80
                
            case 7:
                return 50
                case 8:
                return IS_IPAD() ? 55 : 48
            case 9:
                return  UITableViewAutomaticDimension
            case 10:
                return IS_IPAD() ? 70 : 60
            default:
                return IS_IPAD() ? 220 : 200
                
            }
        }
            
        else{
            switch indexPath.section {
            case 0:
                return IS_IPAD() ? 300 : 230
            case 1:
                return IS_IPAD() ? 60 : 55
                
            case 2,3:
                return IS_IPAD() ? 170 : 135
            case 4:
                return IS_IPAD() ? 175 : 165
                
            case 5:
                return UITableViewAutomaticDimension
            default:
                return IS_IPAD() ? 220 : 200
                
            }
        }
        
    }

    
    // MARK:-   STATE AND CITY DELEGTE-
    // MARK:- State get delegate
    func didFinishSelectedState(forItems dictValue: [String: AnyObject]?)
    {
        self.setSateCityWithValue(forItems: dictValue, keyValue: KEY_STATE)
        
    }
    // MARK:- city get deleagte
    func didFinishSelectedCity(forItems dictValue: [String: AnyObject]?)
    {
        self.setSateCityWithValue(forItems: dictValue, keyValue: KEY_CITY)
        
    }
    
    
    
    
    // Get State List....
    func getAllStateList(){
        APIHandler.handler.getStates({ (response) in
            self.arrState.removeAll()
            self.arrState = response!["states"].arrayObject! as [AnyObject]
            
            print("\(response)")
            
        }) { (error) in
            
        }
    }
    // get City with state id
    func getCityWith(forStateID stateID:Int?){
        APIHandler.handler.getCityList(forStateID: self.pStateID!, success: { (response) in
            self.arrCity.removeAll()
            self.arrCity = response!["cities"].arrayObject! as [AnyObject]
            print("City Result\(response)")
        }) { (error) in
            
        }
    }
    
    
    
}

// MARK:- UITEXTField Delegets
extension InfluencerNewViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        let currentTextfieldTag = textField.tag
        var dictemp = arrUserFieldDetails[currentTextfieldTag] as? [String:AnyObject]
        dictemp!["titleValue"] = textField.text as AnyObject?
        arrUserFieldDetails.remove(at: currentTextfieldTag)
        arrUserFieldDetails.insert(dictemp! as AnyObject, at: currentTextfieldTag)
        // set value
        if currentTextfieldTag == 0 {   // user name set
            self.strName = textField.text!
            
        }
        else if currentTextfieldTag == 1 // mobile number set
        {
            self.strContactNumber = textField.text!
        }
        textField.resignFirstResponder()
        
        
    }
    
    
}

//MARK:- KSTokenView Delegate
extension InfluencerNewViewController: KSTokenViewDelegate {
    func tokenView(_ token: KSTokenView, performSearchWithString string: String, completion: ((_ results: Array<AnyObject>) -> Void)?) {
        var data: Array<String> = []
        for value: String in list {
            if value.lowercased().range(of: string.lowercased()) != nil {
                data.append(value)
            }
        }
        completion!(data as Array<AnyObject>)
    }
    
    func tokenView(_ token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        let idea = (object as! String).components(separatedBy: "+")
        return idea[0]
    }
    
    func tokenView(_ tokenView: KSTokenView, didAddToken token: KSToken) {
        
        self.addSkillsWith(self.arrSkils, keySearch: String(describing: token))
        
        debugPrint(token)
    }
    
    func tokenView(_ token: KSTokenView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
    }
    
    func tokenView(_ tokenView: KSTokenView, didDeleteToken token: KSToken) {
         self.removeTagsID(self.arrSkils, keySearch: String(describing: token))
        debugPrint(token)
    }
    
    func tokenView(_ tokenView: KSTokenView, shouldChangeAppearanceForToken token: KSToken) -> KSToken? {
        
        return token
    }
    
    
    
    
}
// MARK:- ******** API WORKING ************
extension InfluencerNewViewController {
    func getUSerDetailsApiCalling(){
    // This Api GEt User Details
    APIHandler.handler.getUserDetails(forUserID: Globals.sharedClient.userID!, success: { (response) in
    
    print("Get User Details\(response)")
    
    let dictUserDetails = response?.dictionary!["User"]
        self.pArrTypicaJobTemp.removeAll()
       self.getTypicaljobCodeApiCall()


        
    //let objUserDetails = User(withDictionary: (response["User"].dictionaryObject)!)
    let placesData = NSKeyedArchiver.archivedData(withRootObject: (dictUserDetails?.dictionaryObject)!)
    
    SET_OBJ_FOR_KEY(placesData as AnyObject , key: kUserLoginDetails)
      
     self.getUserDetails()
        self.tableView.reloadData()
    }) { (error) in
    
    }
    
    }
    
    
    
    // Api Call Get Typical job cost
    func getTypicaljobCodeApiCall(){
        
        APIHandler.handler.getAttributesForEditInfluncer({ (response) in
            
            
            for value in (response?["Attributes"][7]["attributeValues"].arrayObject!)! {
                let objJobCost = UserFilterAttribute(withDictionary: value as! [String: AnyObject])
                self.pArrTypicaJobTemp.append(objJobCost)
                
            }
            self.makeLocalDictWith(forArrValue: self.pArrTypicaJobTemp, keyValue: KEY_TYPICAL_JOB)
        }) { (error) in
            
        }
    }
    
    // This Function GEt All Skill LIst
    func getAllSkillsList() {
        APIHandler.handler.getSkillList({ (response) in
            
            let arrTagsResult = response?["Skill"].arrayObject!
            if arrTagsResult?.count > 0 {
                for value in (response?["Skill"].arrayObject!)! {
                    let objTags = SkillTags(withDictionary: value as! [String: AnyObject])
                    // self.arrSkils.append(objTags.skillName!)
                    
                    let dictTemp = ["skill_name":objTags.skillName!, "id":objTags.tagID!] as [String : Any]
                    self.arrSkils.append(dictTemp as AnyObject)
                    self.list.append(objTags.skillName!)
                }
                debugPrint("AddIdeaTags ==>\(self.arrSkils)")
                
            }
        }) { (error) in
        }
    }
    // This Function PArse Skill List User Defult
    
    
    // new  code
    func prseSkillsListDefult(forArrSkillList pSkillsList:[AnyObject]?){
        
        self.arrSkillSData.removeAll()
      self.arrSeletedSkillsID.removeAll()
        if pSkillsList!.count > 0 {
            
            for index in 0..<pSkillsList!.count {
                
                let objSkills = pSkillsList![index] as! SkillTags
                
                arrSeletedSkillsID.append(String(objSkills.tagID!))
        
                let dictTemp = ["skill_name":objSkills.skillName!, "id":objSkills.tagID!] as [String : Any]
                
                self.arrSkillSData.append(dictTemp as AnyObject)
            }
        }
      }
    
   // This Function parse area served
    
    func praseAreaServedWith(forArrAreaServed pData:[AnyObject]?){
        self.arrAreaServed.removeAll()
        if pData?.count > 0 {
            for index in 0..<pData!.count {
                
               
                if let _ = pData![index]["cityLocations"]{
                    let pCityInfo = pData![index]["cityLocations"] as! [AnyObject]
                    
                    let strStateID = (pData![index]["id"] as! Int)
                    let strStateName = (pData![index]["name"] as! String)
                    let dictLocal = ["id":strStateID, "name":strStateName, "cityLocations": pCityInfo] as [String : Any]
                    self.arrAreaServed.append(dictLocal as AnyObject)
                }
                
                else{
                    let arrDataTemp = pData![index] as! [AnyObject]
                    for indexValue in 0..<arrDataTemp.count {
                        let pCityInfo = arrDataTemp[indexValue]["cityLocations"] as! [AnyObject]
                        
                        let strStateID = (arrDataTemp[indexValue]["id"] as! Int)
                        let strStateName = (arrDataTemp[indexValue]["name"] as! String)
                        let dictLocal = ["id":strStateID, "name":strStateName, "cityLocations": pCityInfo] as [String : Any]
                        self.arrAreaServed.append(dictLocal as AnyObject)

                    }
                    
                }
                
           
            }
        }
        
     self.setAreaServedDataWith(forAreaservedData: self.arrAreaServed)
        
    }
    
    
  // THIS Function set the area served state ID and City ID
    func setAreaServedDataWith(forAreaservedData pData:[AnyObject]){
    var arrCityIdList = [AnyObject]()
    var dictLocalArea = [String: AnyObject]()
    arrSeletedAreaServedItems.removeAll()
      print("Served Dat\(pData)")
     
        if pData.count > 0 {
            for index in 0..<pData.count {
        
               let stateIDSeleted = pData[index]["id"] as! Int
                
                if let _ = pData[index]["cityLocations"]{
                    arrCityIdList.removeAll()
                    let pCityInfo = pData[index]["cityLocations"] as! [AnyObject]
                    for indexVal in 0..<pCityInfo.count {
                   
                    let dictCityInfo = pCityInfo[indexVal] as! [String: AnyObject]
                    let cityIDSeleted = dictCityInfo["id"] as! Int
                    arrCityIdList.append(cityIDSeleted as AnyObject)
                    
                    }
                   
                   dictLocalArea = ["state_id":stateIDSeleted as AnyObject,"city_id":arrCityIdList as AnyObject]
                   arrSeletedAreaServedItems.append(dictLocalArea as AnyObject)
                    
                }
                
            
            }
        
        }
        
        
        
    }
    
//    func prseSkillsListDefult(forArrSkillList pSkillsList:[AnyObject]?){
//        
//        
//        if pSkillsList!.count > 0 {
//            
//            for index in 0..<pSkillsList!.count {
//                
//                let objSkills = pSkillsList![index] as! SkillTags
//                let dictTemp = ["skill_name":objSkills.skillName!, "id":objSkills.tagID!]
//                self.arrSkillSData.append(dictTemp)
//            }
//        }
//        else{
//            let dictTemp = ["skill_name":"", "id":""]
//            self.arrSkillSData.append(dictTemp)
//        }
//        
//    }
    
    
  // This Function edit influencer api calling
    func editInfluncerApiCalling(){

        APIHandler.handler.editInfluencerProfile(forUser: Globals.sharedClient.userID!, forUserName: self.strName, contactNumber: self.strContactNumber, email: objUser.userEmail!, birthDate: self.strBirthDate, address: self.objUser.userAddress!, aboutUs: self.objUser.userAboutUS!, stateID:self.pStateID, cityID: pCityID, zipCode: self.objUser.zipCode!, skillID:strSkillID, ProfileImgbase64: strImgProfileBase64, coverImgbase64: strImageBackgroundBase64, serviceLocations: arrSeletedAreaServedItems, expYear: Int(strYear!), expMonth: Int(strMonth!),arrTypicaljobCost:arrSeletedTypicalJobCostID, success: { (response) in
        let dictUserDetails = response?.dictionary!["User"]
        let objUserDetails = User(withDictionary: (response!["User"].dictionaryObject)! as [String : AnyObject])

                let placesData = NSKeyedArchiver.archivedData(withRootObject: (dictUserDetails?.dictionaryObject)!)
                SET_OBJ_FOR_KEY(placesData as AnyObject , key: kUserLoginDetails)
                Toast.show(withMessage: PROFILE_UPDTAE)
        print("Update PRofile\(response)")
        self.isEdtableStatus = false
      NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
       self.setFloatingButton()
    
        self.getAllStateList()
      NavigationHelper.helper.enableSideMenuSwipe = true
        self.tableView.reloadData()
    
    
   })
   { (error) in
    
        }
        
        
    }
    
    // This Function Delete the Skills with ID
    func deleteSkillsApiCallingWith(forSkillsID skillsID: Int?, indexValue: Int?){
        APIHandler.handler.deleteSkillWith(forSkillsID: skillsID!, success: { (response) in
            
       
            self.arrSkillSData.remove(at: indexValue!)
            
            Toast.show(withMessage: Delete_Skills)
            self.tableView.reloadData()
           // self.tableView.reloadData()
            
            print("Delete Skills  respose\(response)")
        }) { (error) in
            
        }
    }
    
    
}
