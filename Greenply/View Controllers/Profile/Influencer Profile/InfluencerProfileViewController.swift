//
//  InfluencerProfileViewController.swift
//  Greenply
//
//  Created by Shatadru Datta on 15/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class HeaderButton: UIButton {
    var section: Int?
    var imageSideArraw: UIImageView?
}

class InfluencerProfileViewController: BaseTableViewController, HeaderButtonDeleagte, StateCityItemsDelegate {
    
    var arrTypicalJobCost = [AnyObject]()
    var isAddTags: Bool?
    var arrYear = [String]()
    var arrMonth = [String]()
    var textYear: UITextField!
    var textMonth: UITextField!
    var influencerProfileArray: [AnyObject]?
    var arrayIndex: [Int] = []
    var selectedRow: Bool!
    var influencerDetailsProfileArray: [AnyObject]?
    var arrProfileDetails = [String]()
    var arrExprience = [AnyObject]()
    var arrWorkExperience: [AnyObject]?
    var arrTraining = [AnyObject]()
    var arrNewTraining: [AnyObject]?
    var arrEducation = [AnyObject]()
    var arrNewEducation: [AnyObject]?
    var arrSkils = [AnyObject]()
    var arrCertification = [AnyObject]()
    var strBase64: String!
    var fileType: String!
    var dictselectImage:  [String: String]?
    var imageCertificationArr = [AnyObject]()
    var imageArr = [Data]()
    var certfirst: Bool = false
    var imageProfile: UIImage?
    var imageBackgroundProfile: UIImage?
    var list = [String]()
    var isSearch: Bool?
    var arrTagsResult = [AnyObject]()
    var arrAllTagsID = [String]()
    var dictValue: [String: AnyObject]!
    var arrBackgroundImg = [AnyObject]()
    var propertyBtn: UIButton!
    var floatingBtn: PDFloating?
    var editProf: Bool!
    var arrayFieldData = [String]()
    var arrayLeftImage = [String]()
    var arrStateCityItems = [AnyObject]()
    var arrServiceLocations = [AnyObject]()
    var localDict =  [String: AnyObject]()
    var objUser: User!
    var arrUserEduDataInfo = [AnyObject]()
    var pEduction = [AnyObject]()
    var pCertificate = [AnyObject]()
    var pExperience = [AnyObject]()
    var pTraning = [AnyObject]()
    var strBirthDate = ""
    var strMonth: String?
    var strYear: String?
    var strSkillID: String?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 106
        isAddTags = true
      
        self.arrStateCityItems.removeAll()
        editProf = false
        
        arrYear.append("Select")
        arrMonth.append("Select")
        
        for year in 0..<31 {
            arrYear.append(String(year))
        }
        
        for month in 1..<12 {
            arrMonth.append(String(month))
        }
        
        
    
        
        
        
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        NavigationHelper.helper.headerViewController?.delegateButton = self
        influencerProfileArray = Helper.sharedClient.readPlist(forName: "InfluencerProfile")
        influencerDetailsProfileArray = Helper.sharedClient.readPlist(forName: "InfluencerDetails")
        selectedRow = false
        
        tableView.backgroundView = nil
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserDetails()
        print("items\(self.arrStateCityItems)")
        setFloatingButton()
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_EDIT_PROFILE
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
        // NavigationHelper.helper.headerViewController?.addHeaderButton(KHeaderTickButton)
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        floatingBtn!.removeButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionEditProfile(_ sender: UIButton) {
        
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        // self .addCityID()
        // self.InfluencerAPI()
        
        
        let name = self.arrProfileDetails[1]
        let contact = self.arrProfileDetails[2]
        let address = self.arrProfileDetails[3]
        let aboutUs = self.arrProfileDetails[5]
        if name == "" {
            Toast.show(withMessage: ENTER_USERNAME)
        } else if contact == "" {
            Toast.show(withMessage: ENTER_MOBILE_NUMBER)
        } else if address == "" {
            Toast.show(withMessage: ADDRESS)
        } else if aboutUs == "" {
            Toast.show(withMessage: ABOUTUS)
        } else if self.arrExprience.count == 0 {
            Toast.show(withMessage: ENTER_EXPERIENCE)
        } else if self.arrTraining.count == 0 {
            Toast.show(withMessage: ENTER_TRAINING)
        } else if self.arrEducation.count == 0 {
            Toast.show(withMessage: ENTER_EDUCATION)
        } else if self.arrCertification.count == 0{
            Toast.show(withMessage: ENTER_CERTIFICATION)
        } else if self.arrAllTagsID.count == 0 {
            Toast.show(withMessage: ENTER_SKILLS)
        }
        else if self.arrServiceLocations.count < 0 {
            Toast.show(withMessage: SELECT_SERVICE_LOCATIONS)
        }
        else {
            self.addCityID()
            self.setTagesWithId()
            self.InfluencerAPI()
        }
        
        
        
    }
    
    // MARK:- This Function show  the User Login Details....
    
    func getUserDetails(){
        self.arrExprience.removeAll()
        self.arrTraining.removeAll()
        self.arrEducation.removeAll()
        self.arrCertification.removeAll()
        if let data = OBJ_FOR_KEY(kUserLoginDetails) as? Data {
            let mySavedList = NSKeyedUnarchiver.unarchiveObject(with: data)
            
            self.objUser = User(withDictionary: mySavedList as! [String: AnyObject])
          
            
            self.arrAllTagsID = self.objUser.arrSkillID
            
            
            
            
            
            self.strYear    = self.objUser.expYear!
            self.strMonth = self.objUser.expMonths!
            if let birthDate = self.objUser.userBirthDate
            {
                strBirthDate = Date.convertTimeStampToBirthDate(birthDate)
                
            } else {
                strBirthDate  = ""
            }
            arrayFieldData = [self.objUser.name! , self.objUser.name!, self.objUser.userContactNumber!, self.objUser.StateName!, self.objUser.CityName!,strBirthDate]
            arrayLeftImage = ["InfluencerName", "InfluencerName", "InfluencerCall", "InfluencerState", "InfluencerLocation", "influencerBirth"]
            
            
            arrProfileDetails = [self.objUser.name! , self.objUser.name!, self.objUser.userContactNumber!, self.objUser.StateName!, self.objUser.CityName!,strBirthDate]
            
            // Working on eductions
            if self.objUser.arrEducationList.count > 0{
                self.pEduction.removeAll()
                for index in 0..<self.objUser.arrEducationList.count{
                    self.pEduction.append(self.objUser.arrEducationList[index])
                }
                self.makeLocalDictWith(forArrValue: self.pEduction, keyValue: KEY_EDUCATION)
                
                
            }else{
              self.makeEmptyLocalDictWith(forKeyValue: KEY_EDUCATION)
            }
            
            // Working on Experience
            if self.objUser.arrExperienceList.count > 0 {
                 self.pExperience.removeAll()
                for index in 0..<self.objUser.arrExperienceList.count{
                    self.pExperience.append(self.objUser.arrExperienceList[index])
                    
                }
                
                self.makeLocalDictWith(forArrValue: self.pExperience, keyValue: KEY_EXPRIENCE)
                
            }else{
                 self.makeEmptyLocalDictWith(forKeyValue: KEY_EDUCATION)
            }
            
            // Working on Traning
            if self.objUser.arrTraningList.count > 0 {
                 self.pTraning.removeAll()
                for index in 0..<self.objUser.arrTraningList.count{
                    self.pTraning.append(self.objUser.arrTraningList[index])
                }
                self.makeLocalDictWith(forArrValue: self.pTraning, keyValue: KEY_TRANING)
                
                
                
            }else{
                 self.makeEmptyLocalDictWith(forKeyValue: KEY_EDUCATION)
            }
            // Working on certications
            if self.objUser.arrCertificationsList.count > 0{
                self.pCertificate.removeAll()
                for index in 0..<self.objUser.arrCertificationsList.count{
                    self.pCertificate.append(self.objUser.arrCertificationsList[index])
                }
                self.makeLocalDictWith(forArrValue: self.pCertificate, keyValue: KEY_CERTIFICATE)
                
            }
        }
        self.getAllSkillsList()
        
    }
    
    
    func addExperirnce(_ arrExp: [AnyObject]){
        
        if arrExp.count > 0{
            var dict: [String: AnyObject] = self.influencerProfileArray![2] as! [String: AnyObject]
            var dictArray: [AnyObject] = dict["fieldArray"] as! [AnyObject]
            dictArray = arrExp
            dict["fieldArray"] = dictArray as AnyObject?
            self.influencerProfileArray![2] = dict as AnyObject
        }
        
    }
    func addTraning(_ arrTraning: [AnyObject]){
        
        if arrTraning.count > 0{
            var dict: [String: AnyObject] = self.influencerProfileArray![3] as! [String: AnyObject]
            var dictArray: [AnyObject] = dict["fieldArray"] as! [AnyObject]
            dictArray = arrTraning
            dict["fieldArray"] = dictArray as AnyObject?
            self.influencerProfileArray![3] = dict as AnyObject
        }
        
    }
    
    
    func addEductions(_ arrEductions: [AnyObject]){
        
        if arrEductions.count > 0{
            var dict: [String: AnyObject] = self.influencerProfileArray![4] as! [String: AnyObject]
            var dictArray: [AnyObject] = dict["fieldArray"] as! [AnyObject]
            dictArray = arrEductions
            dict["fieldArray"] = dictArray as AnyObject?
            self.influencerProfileArray![4] = dict as AnyObject
        }
        
    }
    
    func addCertificate(_ arrCertificate: [AnyObject]){
        if arrCertificate.count > 0{
            var dict: [String: AnyObject] = self.influencerProfileArray![5] as! [String: AnyObject]
            var dictArray: [AnyObject] = dict["fieldArray"] as! [AnyObject]
            dictArray = arrCertificate
            dict["fieldArray"] = dictArray as AnyObject?
            self.influencerProfileArray![5] = dict as AnyObject
        }
        
    }
    
    // MARk:- set Tabgs
    
    func setTagesWithId()
    {
        
        strSkillID  = arrAllTagsID.joined(separator: ",")
        
    }
    // MARk:- This Function Make A local dict
    func makeLocalDictWith(forArrValue pArrData:[AnyObject], keyValue: String!){
        if keyValue == KEY_EXPRIENCE{
            
            for index in 0..<pArrData.count{
                let objExp = pArrData[index] as! UserExperience
                
                self.dictValue = ["id":objExp.pId! as AnyObject ,  "organisation_name": objExp.organisation_name! as AnyObject, "start_date":  objExp.startDate! as AnyObject, "end_date":objExp.endDate! as AnyObject,"ButtonTitle":"Edit" as AnyObject, "KeyVale":KEY_EXPRIENCE as AnyObject]
  
                
                self.arrExprience.append(self.dictValue as AnyObject)
                
            }
            
            
        }
        else if keyValue == KEY_TRANING{
            
            for index in 0..<pArrData.count{
                let objTring = pArrData[index] as! UserTraining
                
                self.dictValue = ["id":objTring.pId! as AnyObject ,"training_name": objTring.training_name! as AnyObject, "start_date":  objTring.startDate! as AnyObject, "end_date":objTring.endDate! as AnyObject,"ButtonTitle":"Edit" as AnyObject, "KeyVale":KEY_TRANING as AnyObject]
                self.arrTraining.append(self.dictValue as AnyObject)
            }
            // assign training value
        }
        else if keyValue == KEY_EDUCATION{
            for index in 0..<pArrData.count{
                let objEdu = pArrData[index] as! UserEducation
                self.dictValue = ["id":objEdu.pId! as AnyObject ,"degree": objEdu.degreeName! as AnyObject, "stream": objEdu.stream! as AnyObject, "start_date": objEdu.startDate! as AnyObject, "end_date": objEdu.endDate! as AnyObject,"ButtonTitle":"Edit" as AnyObject, "KeyVale":KEY_EDUCATION as AnyObject]
                
                self.arrEducation.append(self.dictValue as AnyObject)
            }
            
            
        }
        else if keyValue == KEY_CERTIFICATE{
            for index in 0..<pArrData.count{
                let objCerti = pArrData[index] as! UserCertificates
                
                
                self.dictValue = ["id":objCerti.pId! as AnyObject ,"title": objCerti.title! as AnyObject, "files": objCerti.certificateFile! as AnyObject]
                
                self.arrCertification.append(self.dictValue as AnyObject)
            }
            
            
        }
        
    }
    
    // MARK:- This Function make a empty local dict
    func makeEmptyLocalDictWith(forKeyValue keyValue:String!){
        if keyValue == KEY_EXPRIENCE{
            self.dictValue = ["id":0 as AnyObject ,  "organisation_name": "" as AnyObject, "start_date":  "" as AnyObject, "end_date":"" as AnyObject,"ButtonTitle":"Edit" as AnyObject, "KeyVale":KEY_EXPRIENCE as AnyObject]
            self.arrExprience.append(self.dictValue as AnyObject)

        }
        else if keyValue == KEY_TRANING{
            self.dictValue = ["id":0 as AnyObject ,"training_name": "" as AnyObject, "start_date":  "" as AnyObject, "end_date":"" as AnyObject,"ButtonTitle":"Edit" as AnyObject, "KeyVale":KEY_TRANING as AnyObject]
            self.arrTraining.append(self.dictValue as AnyObject)
        }
        else if keyValue == KEY_EDUCATION{
            self.dictValue = ["id":0 as AnyObject ,"degree": "" as AnyObject, "stream":"" as AnyObject, "start_date": "" as AnyObject, "end_date": "" as AnyObject,"ButtonTitle":"Edit" as AnyObject, "KeyVale":KEY_EDUCATION as AnyObject]
            
            self.arrEducation.append(self.dictValue as AnyObject)
        }
    }
    
    // MARK:- This function add city id
    func addCityID(){
        var mDict = [String : AnyObject]()
        for index in 0..<arrStateCityItems.count {
            let stValue = arrStateCityItems[index]["stateID"] as! Int
            
            
            for index in 0..<arrStateCityItems.count {
                let arrCityInfo = arrStateCityItems[index]["cityInfo"] as! [AnyObject]
                mDict.removeAll()
                
                if arrCityInfo.count > 0 {
                    
                    let predicate = NSPredicate(format:"state_id == %d",stValue)
                    let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate])
                    let filteredArray = arrCityInfo.filter{ compoundPredicate.evaluate(with: $0) }
                    print(filteredArray)
                    if filteredArray.count > 0{
                        mDict = ["state_id":stValue as AnyObject , "city_id": self.getCityIDWith(filteredArray) as AnyObject]
                        arrServiceLocations.append(mDict as AnyObject)
                        
                        print("Dcit Value Reslt \(arrServiceLocations)")
                    }
                }
                
                
            }
            
        }
    }
    
    
    
    // MARK:-  This Function Retuern all city ID with arr of city list.
    
    func getCityIDWith(_ arrCityInfo: [AnyObject])-> [AnyObject]{
        var arrListID = [AnyObject]()
        arrListID.removeAll()
        for index in 0..<arrCityInfo.count {
            arrListID.append(arrCityInfo[index]["id"] as! Int as AnyObject)
            
        }
        return arrListID
    }
    
}


extension InfluencerProfileViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if editProf == false {
            return 1
        } else {
            if let array = influencerProfileArray {
                return array.count
            } else {
                return 0
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if editProf == false {
            return 10
        }
        else {
            if section == 0 || section == 2 || section == 3 || section == 4 || section == 9 {
                return (((influencerProfileArray![section] as! [String: AnyObject])["fieldArray"]!) as! [AnyObject]).count
            }
            else {
                let array = arrayIndex.filter({ (object) -> Bool in return object == section ? true : false })
                if array.count > 0 {
                    return (((influencerProfileArray![section] as! [String: AnyObject])["fieldArray"]!) as! [AnyObject]).count
                } else {
                    return 0
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        var backgroundImageView = UIImageView()
        switch section {
        case 1, 5, 7, 8:
            backgroundImageView = UIImageView(frame: CGRect(x: 8, y: 3, width: tableView.frame.size.width - 16, height: IS_IPAD() ? 60.0 : 40.0))
        default:
            backgroundImageView = UIImageView(frame: CGRect(x: 8, y: 3, width: tableView.frame.size.width - 16, height: IS_IPAD() ? 60.0 : 50.0))
        }
        backgroundImageView.layer.cornerRadius = IS_IPAD() ? 12.0 : 8.0
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.backgroundColor = UIColor.white
        let imageBorder = UIImageView(frame: CGRect(x: 0, y: IS_IPAD() ? 60.0 : 40.0, width: tableView.frame.size.width, height: 3.0))
        imageBorder.backgroundColor = UIColorRGB(239.0, g: 239.0, b: 244.0)
        let buttonHeader = HeaderButton(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: IS_IPAD() ? 50.0 : 40.0))
        buttonHeader.isUserInteractionEnabled = true
        buttonHeader.section = section
        buttonHeader.addTarget(self, action: #selector(InfluencerProfileViewController.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        let imageIcon = UIImageView(frame: CGRect(x: tableView.frame.size.width - 50, y: IS_IPAD() ? 10 : 8.0, width: IS_IPAD() ? 40.0 : 25.0, height: IS_IPAD() ? 40.0 : 25.0))
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.frame.size.width - imageIcon.frame.size.width - 50, height: IS_IPAD() ? 60.0 : 40.0))
        
        switch section {
        case 0, 2, 3, 4:
            imageIcon.image = UIImage(named: "InfluencerDropdownIconRight")
        default:
            let array = arrayIndex.filter({ (object) -> Bool in return object == section ? true : false })
            if array.count > 0 {
                imageIcon.image = UIImage(named: "InfluencerDropdownIcon")
            } else {
                imageIcon.image = UIImage(named: "InfluencerDropdownIconRight")
            }
        }
        
        label.text = ((influencerProfileArray![section] as! [String: AnyObject])["sectionTitle"] as? String)!
        label.textColor = UIColorRGB(65.0, g: 134.0, b: 44.0)
        label.font = label.font.withSize(IS_IPAD() ? 22.0 : 15.0)
        label.backgroundColor = .clear
        view.backgroundColor = UIColorRGB(239.0, g: 239.0, b: 244.0)
        
        view.addSubview(backgroundImageView)
        view.addSubview(label)
        view.addSubview(buttonHeader)
        
        switch section {
        case 2, 3, 4:
            debugPrint("")
        default:
            view.addSubview(imageBorder)
        }
        
        switch section {
        case 0, 10:
            debugPrint("No Code")
        default:
            label.font = UIFont.boldSystemFont(ofSize: IS_IPAD() ? 22.0 : 15.0)
            view.addSubview(imageIcon)
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if editProf == true {
            switch section {
            case 0, (influencerProfileArray?.count)! - 1:
                return 0
            default:
                return IS_IPAD() ? 60.0 : 40.0
            }
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if editProf == false {
            var cell: BaseTableViewCell?
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileViewTableViewCell()), for: indexPath) as! ProfileViewTableViewCell
                (cell as! ProfileViewTableViewCell).imageProfile.setImage(withURL: URL(string: OBJ_FOR_KEY(kDisplayProfile) as! String)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))
                (cell as! ProfileViewTableViewCell).imageProfile.layoutIfNeeded()
                (cell as! ProfileViewTableViewCell).imageProfile.layer.cornerRadius =  (cell as! ProfileViewTableViewCell).imageProfile.frame.size.width/2
                (cell as! ProfileViewTableViewCell).imageProfile.layer.masksToBounds = true
                (cell as! ProfileViewTableViewCell).imageProfile.layer.borderWidth = 1.0;
                (cell as! ProfileViewTableViewCell).imageProfile.layer.borderColor = UIColorRGB(57, g: 181, b: 74)!.cgColor
                (cell as! ProfileViewTableViewCell).imageBackgroundProfile.setImage(withURL: URL(string: OBJ_FOR_KEY(kCoverProfile) as! String)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))
                
                (cell as! ProfileViewTableViewCell).buttonEditProf.isHidden =  true
                (cell as! ProfileViewTableViewCell).buttonEditCover.isHidden =  true
                (cell as! ProfileViewTableViewCell).labelUploadImage.isHidden =  true
                
                (cell as! ProfileViewTableViewCell).datasource = "" as AnyObject?
                
            case 1..<6:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FieldTableViewCell.self), for: indexPath) as! FieldTableViewCell
                (cell as? FieldTableViewCell)?.index = indexPath
                (cell as? FieldTableViewCell)?.editProf = false
                (cell as? FieldTableViewCell)?.strTextValue = self.arrayFieldData[indexPath.row]
                (cell as? FieldTableViewCell)?.txtField.iconImageView.image = UIImage(named: (self.arrayLeftImage[indexPath.row]))
                
            case 6:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExperienceDataShowCell.self), for: indexPath) as! ExperienceDataShowCell
                (cell as? ExperienceDataShowCell)?.lblHeader.text = "Experience"
                
                if self.pExperience.count > 0 {
                    let objExp = pExperience[0] as! UserExperience
                    (cell as? ExperienceDataShowCell)?.lblTitle.text = "Organization: \(objExp.organisation_name!)"
                    
                    
                    (cell as? ExperienceDataShowCell)?.lblFromDate.text = "From date: \(Date.convertTimeStampToDate(objExp.startDate!))"
                    (cell as? ExperienceDataShowCell)?.lblToDate.text = "To date: \(Date.convertTimeStampToDate(objExp.endDate!))"
                }
                else{
                    
                }
                
                
                //
                
                
            case 7:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExperienceDataShowCell.self), for: indexPath) as! ExperienceDataShowCell
                (cell as? ExperienceDataShowCell)?.lblHeader.text = "Training"
                
                if self.pTraning.count > 0{
                    let objTrg =  self.pTraning[0] as! UserTraining
                    (cell as? ExperienceDataShowCell)?.lblTitle.text = "Training: \(objTrg.training_name!)"
                    (cell as? ExperienceDataShowCell)?.lblFromDate.text = "From date: \(Date.convertTimeStampToDate(objTrg.startDate!))"
                    (cell as? ExperienceDataShowCell)?.lblToDate.text = "To date: \(Date.convertTimeStampToDate(objTrg.endDate!))"
                }
                else{
                    
                }
                //
                
            case 8:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EducationDataShowCell.self), for: indexPath) as! EducationDataShowCell
                
                
                (cell as? EducationDataShowCell)?.lblHeader.text = "Education"
                if self.pEduction.count > 0{
                    let objEdu =  self.pEduction[0] as! UserEducation
                    
                    (cell as? EducationDataShowCell)?.lblTitle.text = "Degree: \(objEdu.degreeName!)"
                    (cell as? ExperienceDataShowCell)?.lblDesc.text = "Stream: \(objEdu.stream!)"
                    (cell as? EducationDataShowCell)?.lblFromDate.text = "From date: \(Date.convertTimeStampToDate(objEdu.startDate!))"
                    (cell as? EducationDataShowCell)?.lblToDate.text = "To date: \(Date.convertTimeStampToDate(objEdu.endDate!))"
                }
                else{
                    
                }
                
                
                
                
            case 9:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfluencerAboutMeCell.self), for: indexPath) as! InfluencerAboutMeCell
                (cell as? InfluencerAboutMeCell)?.editProf = false
                
                (cell as? InfluencerAboutMeCell)?.lblType.text = self.objUser.userAboutUS!
                
            case 10:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LicenseTableViewCell.self), for: indexPath) as! LicenseTableViewCell
                (cell as? LicenseTableViewCell)?.editProf = false
                (cell as? LicenseTableViewCell)?.datasource = self.arrCertification[indexPath.row]
                // let arrayCert = OBJ_FOR_KEY(CERTIFICATES) as! [AnyObject]
                // (cell as? LicenseTableViewCell)?.datasource = arrayCert
                
            default:
                debugPrint("No Code")
            }
            cell?.datasource = "" as AnyObject?
            return cell!
            
            
        } else {
            var cell: BaseTableViewCell?
            switch indexPath.section {
            case 0:
                if indexPath.row == 0 {
                    cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileViewTableViewCell.self), for: indexPath) as! ProfileViewTableViewCell
                    
                    (cell as! ProfileViewTableViewCell).buttonEditProf.isHidden =  false
                    (cell as! ProfileViewTableViewCell).buttonEditCover.isHidden =  false
                    (cell as! ProfileViewTableViewCell).labelUploadImage.isHidden =  false
                    
                    (cell as! ProfileViewTableViewCell).didSelectImage = { profImg in
                        GPImagePickerController.pickImage(onController: self,  didPick: { (image) in
                            self.imageProfile = image
                            (cell as! ProfileViewTableViewCell).imageProfile.image = image
                        }) {
                            
                        }
                    }
                    
                    (cell as! ProfileViewTableViewCell).didSelectBackgroundImage = { profImg in
                        GPImagePickerController.pickImage(onController: self,  didPick: { (image) in
                            self.imageBackgroundProfile = image
                            (cell as! ProfileViewTableViewCell).imageBackgroundProfile.image = image
                            self.arrBackgroundImg.removeAll()
                            self.arrBackgroundImg.append(image)
                            
                        }) {
                            
                        }
                    }
                    return cell!
                } else {
                    cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FieldTableViewCell.self), for: indexPath) as! FieldTableViewCell
                    (cell as? FieldTableViewCell)?.editProf = true
                    (cell as? FieldTableViewCell)?.index = indexPath
                    (cell as? FieldTableViewCell)?.strTextValue = self.arrProfileDetails[indexPath.row]
                    
                    
                    (cell as? FieldTableViewCell)?.textValue = { text, indexpath in
                        self.arrProfileDetails.remove(at: indexpath.row)
                        self.arrProfileDetails.insert(text, at: indexpath.row)
                    }
                }
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TotalExperienceCell.self), for: indexPath) as! TotalExperienceCell
                (cell as? TotalExperienceCell)!.textYear.text = self.objUser.expYear!
                (cell as? TotalExperienceCell)!.textMonth.text = self.objUser.expMonths!
                (cell as? TotalExperienceCell)!.buttonYear.addTarget(self, action: #selector(self.year(_:)), for: UIControlEvents.touchUpInside)
                (cell as? TotalExperienceCell)!.buttonMonth.addTarget(self, action: #selector(self.month(_:)), for: UIControlEvents.touchUpInside)
                textYear = (cell as? TotalExperienceCell)!.textYear
                textMonth = (cell as? TotalExperienceCell)!.textMonth
                
                self.strMonth = textMonth.text
                self.strYear = textYear.text
            case 2, 3, 4:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExperienceTableViewCell.self), for: indexPath) as! ExperienceTableViewCell
                
            case 5:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LicenseTableViewCell.self), for: indexPath) as! LicenseTableViewCell
                
                (cell as? LicenseTableViewCell)?.datasource = self.arrCertification[indexPath.row]
           
                
                return cell!
            case 6:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SkillsTableViewCell.self), for: indexPath) as! SkillsTableViewCell
                self.setTags(forArrTagsName: self.objUser.arrSkillName, cell: cell!, isTagsStaus: isAddTags!)
                (cell as! SkillsTableViewCell).tagviewDesc.delegate = self
                (cell as! SkillsTableViewCell).tagviewDesc.backgroundColor = .white
            case 7:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: JobCostTableViewCell.self), for: indexPath) as! JobCostTableViewCell
                // (cell as! JobCostTableViewCell).datasource = arrTypicalJobCost[indexPath.row]
                
            case 8:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StateCityTableViewCell.self), for: indexPath) as! StateCityTableViewCell
                (cell as! StateCityTableViewCell).datasource = self.arrStateCityItems[indexPath.row]
                
            case 9:
                cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SaveButtonTableViewCell.self), for: indexPath) as! SaveButtonTableViewCell
                
            default:
                debugPrint("No Code")
            }
            
            
//            cell?.datasource = ((influencerProfileArray![indexPath.section] as! [String: AnyObject])["fieldArray"]!)[indexPath.row]
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if editProf == false {
            switch indexPath.row {
            case 0:
                return IS_IPAD() ? 300 : 230
            case 1..<6:
                return IS_IPAD() ? 68.0 : 48.0
            case 6..<8:
                return 196 //IS_IPAD() ? 150.0 : 150.0
            case 8:
                return 224// IS_IPAD() ? 186.0 : 186.0
            case 9:
                return 110 // IS_IPAD() ? 160.0 : 150.0
            case 10:
                return IS_IPAD() ? 160.0 : 150.0
            default:
                return 0
            }
        } else {
            let height: String?
            if IS_IPAD() {
                height = (((influencerProfileArray![indexPath.section] as! [String: AnyObject])["heightOfRowiPad"]!) as! String)
            } else {
                height = (((influencerProfileArray![indexPath.section] as! [String: AnyObject])["heightOfRowiPhone"]!) as! String)
            }
            var floatHeight: CGFloat?
            if let number = NumberFormatter().number(from: height!) {
                floatHeight = CGFloat(number)
            }
            switch indexPath.section {
            case 0:
                if indexPath.row == 0 {
                    return IS_IPAD() ? 300 : 230
                }
                else {
                    return floatHeight!
                }
            case 8:
                return IS_IPAD() ? 300 : 75
            default:
                return floatHeight!
            }
        }
    }
    
    func buttonClicked(_ sender: HeaderButton!) {
        let array = arrayIndex.filter({ (object) -> Bool in return object == sender.section ? true : false })
        if array.count > 0 {
            if sender.section == 8  {
                
            } else {
                arrayIndex.removeObject(array.last!)
            }
            
        } else {
            arrayIndex.append(sender.section!)
        }
        if sender.section == 2 || sender.section == 3 || sender.section == 4 {
            
            let influencerDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: InfluencerProfileDetailsController.self)) as! InfluencerProfileDetailsController
            
            if sender.section == 2 {
                
                influencerDetailsVC.pArrData = self.arrExprience //  assign exprience value
            } else if sender.section == 3 {
                influencerDetailsVC.pArrData = self.arrTraining
                
            }
            else if sender.section == 4 {
                
                influencerDetailsVC.pArrData = self.arrEducation // assign education value
            }
            
            
            self.navigationController!.pushViewController(influencerDetailsVC, animated: true)
            
        }
    else if sender.section == 5 {
let certificateVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: InfluencerCertificationDetailsController.self)) as! InfluencerCertificationDetailsController
    certificateVC.arrCertificateList = self.arrCertification
    NavigationHelper.helper.contentNavController!.pushViewController(certificateVC, animated: true)
                    }
            
        else if sender.section == 8 {
            let serviceAreaVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: ServiceAreaViewController.self)) as! ServiceAreaViewController
            serviceAreaVC.delegate = self
            if self.arrStateCityItems.count > 0 {
                serviceAreaVC.arrDataList = self.arrStateCityItems
            }
            serviceAreaVC.didSelectState = { value in
                print("ArrayState \(value!)")
                self.arrStateCityItems = value!
                
                var dict: [String: AnyObject] = self.influencerProfileArray![8] as! [String: AnyObject]
                var dictArray: [AnyObject] = dict["fieldArray"] as! [AnyObject]
                dictArray = self.arrStateCityItems
                dict["fieldArray"] = dictArray as AnyObject?
                self.influencerProfileArray![8] = dict as AnyObject
                self.tableView.reloadData()
            }
            NavigationHelper.helper.contentNavController!.pushViewController(serviceAreaVC, animated: true)
        }
        else
        {
            tableView.reloadData()
        }
    }
}


/* kHeader Button Action
 
 //MARK:- Hedaer Buttton Delagte
 extension InfluencerProfileViewController {
	func didTapMenuButton(strButtonType: String) {
 if strButtonType == KHeaderTickButton {
 // some action
 } else {
 
 }
	}
 }
 
 */


//MARK:- Api Call SkillList
extension InfluencerProfileViewController {
    func getAllSkillsList() {
        APIHandler.handler.getSkillList({ (response) in
            
            self.arrTagsResult = response!["Skill"].arrayObject! as [AnyObject]
            if self.arrTagsResult.count > 0 {
                for value in (response?["Skill"].arrayObject!)! {
                    let objTags = SkillTags(withDictionary: value as! [String: AnyObject])
                    self.arrSkils.append(objTags)
                    self.list.append(objTags.skillName!)
                }
                debugPrint("AddIdeaTags ==>\(self.arrSkils)")
                self.getAttributes()
            }
        }) { (error) in
        }
    }
}


//MARK:- GetSkillsTags
extension InfluencerProfileViewController {
    func getTagsID(_ pArry: [AnyObject], keySearch: String)
    { let name = NSPredicate(format: "skill_name contains[c] %@", keySearch)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
        let filteredArray = pArry.filter { compoundPredicate.evaluate(with: $0) }
        let dict = filteredArray.first
        
        if let dictFilter = dict {
            if let _ = dict!["id"] {
                self.arrAllTagsID.append(String(dictFilter["id"] as! Int))
                
            }
        }
    }
    
    
    // Remove Tags
    func removeTagsID(_ pArry: [AnyObject], keySearch: String)
    { let name = NSPredicate(format: "skill_name contains[c] %@", keySearch)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [name])
        let filteredArray = pArry.filter { compoundPredicate.evaluate(with: $0) }
        let dict = filteredArray.first
        
        if let dictFilter = dict {
            if let _ = dict!["id"] {
                let index = dictFilter["id"] as! Int
                self.arrAllTagsID.removeObject(index)
            }
        }
    }
}

//MARK:- KSTokenView Delegate
extension InfluencerProfileViewController: KSTokenViewDelegate {
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
        if isSearch == true {
            self.getTagsID(self.arrTagsResult, keySearch: String(describing: token))
            
        }
        isSearch = false
        
        debugPrint(token)
    }
    
    func tokenView(_ token: KSTokenView, didSelectRowAtIndexPath indexPath: IndexPath) {
        self.isSearch = true
    }
    
    func tokenView(_ tokenView: KSTokenView, didDeleteToken token: KSToken) {
        self.removeTagsID(self.arrTagsResult, keySearch: String(describing: token))
        debugPrint(token)
    }
    
    func tokenView(_ tokenView: KSTokenView, shouldChangeAppearanceForToken token: KSToken) -> KSToken? {
        self.arrAllTagsID.append(String(describing: token))
        return token
    }
}


//MARK:- Influencer API Call
extension InfluencerProfileViewController {
    func InfluencerAPI() {
//        APIHandler.handler.editInfluencerProfile(forUser: Globals.sharedClient.userID, forUserName: self.arrProfileDetails![1], contactNumber: self.arrProfileDetails![2], email: self.objUser.userEmail, birthDate:String(self.strBirthDate), address: self.arrProfileDetails![3], aboutUs: self.arrProfileDetails![5],cityID:self.objUser.CityID, userEducation: arrEducation , userTraining: arrTraining , UserExperience: arrExprience , UserCertification: arrCertification , serviceArea: "Developemnt", skillID: strSkillID, base64: self.strBase64 ,serviceLocations:arrServiceLocations,expYear:strYear,expMonth:strMonth,success: { (response) in
//            
//            debugPrint(response)
//            let dictUserDetails = response.dictionary!["User"]
//            let placesData = NSKeyedArchiver.archivedDataWithRootObject((dictUserDetails?.dictionaryObject)!)
//            SET_OBJ_FOR_KEY(placesData , key: kUserLoginDetails)
//            Toast.show(withMessage: PROFILE_UPDTAE)
//         
//        }) { (error) in
//            
//        }
    }
}


//MARK:- Floating Button
extension InfluencerProfileViewController {
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
            NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true)
            let userStatus = OBJ_FOR_KEY(kUserTypeStatus)?.int32Value
            if userStatus == 1 {
                editProf = true
                self.addEductions(self.pEduction)
                self.addTraning(self.pTraning)
                self.addExperirnce(self.pExperience)
                self.addCertificate(self.pCertificate)
                
                
                floatingBtn!.removeButton()
                self.tableView.reloadData()
            }
            else {
                floatingBtn!.removeButton()
                self.tableView.reloadData()
            }
            break
        default:
            "Nothing to do"
        }
    }
}

extension InfluencerProfileViewController {
    func year(_ sender: UIButton) {
        GPPickerViewController.showPickerController(self, isDatePicker: false, pickerArray: arrYear, position: .bottom, pickerTitle: "", preSelected: "") { (value, index) in
            self.textYear.text = value as? String
        }
    }
    
    func month(_ sender: UIButton) {
        GPPickerViewController.showPickerController(self, isDatePicker: false, pickerArray: arrMonth, position: .bottom, pickerTitle: "", preSelected: "") { (value, index) in
            self.textMonth.text = value as? String
        }
    }
}


extension InfluencerProfileViewController {
    func getAttributes() {
        APIHandler.handler.getAttributesForProjrcts({ (response) in
            for value in (response?["Attributes"][7]["attributeValues"].arrayObject!)! {
                let objJobCost = UserFilterAttribute(withDictionary: value as! [String: AnyObject])
                self.arrTypicalJobCost.append(objJobCost)
            }
            
            var dict: [String: AnyObject] = self.influencerProfileArray![7] as! [String: AnyObject]
            var dictArray: [AnyObject] = dict["fieldArray"] as! [AnyObject]
            dictArray = self.arrTypicalJobCost
            dict["fieldArray"] = dictArray as AnyObject?
            self.influencerProfileArray![7] = dict as AnyObject
        }) { (error) in
        }
    }
    
    // MARK: StateCityItemsDelegate Delagte
    
    func didGetAllStateCityItems(forItems arrValue: [AnyObject]?) {
        print("\(arrValue)")
    }
    
    
    
    func setTags(forArrTagsName pTagsName: [AnyObject], cell: UITableViewCell, isTagsStaus: Bool) {
        var nameStr: String = ""
        if isTagsStaus == true {
            for index in 0..<pTagsName.count {
                nameStr = (pTagsName[index] as? String)!
                (cell as! SkillsTableViewCell).tagviewDesc.addToken(KSToken.init(title: nameStr))
            }
            isAddTags = false
        }
    }
    
}


