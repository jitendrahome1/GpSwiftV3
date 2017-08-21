//
//  UploadProjectNewViewController.swift
//  Greenply
//
//  Created by Jitendra on 5/3/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit
enum eUploadEditProject {
    case eEditProject
    case eAddProject
}
class UploadProjectNewViewController: BaseViewController,SkillsTagsDeleagte,UITextFieldDelegate, UITextViewDelegate  {

    @IBOutlet weak var tblUploadProject: UITableView!
    var projectID: Int?
    var arrSectionTitle = [String]()
    var arrProjectTypeData = [AnyObject]()
    var arrStyleTypeData = [AnyObject]()
    var arrWorkTypeData = [AnyObject]()
    var arrSeletedSkillsID = [AnyObject]()
    var arrRoomTypeData = [AnyObject]()
    var arrProjectBudgetTypeData = [AnyObject]()
    var arrSkillsData = [AnyObject]()
    var arrFieldsData = [AnyObject]()
    var arrCertificateData = [AnyObject]()
    var hiddenSections: [Int] = []
    var eProjectStatus: eUploadEditProject = .eEditProject
    var viewHeader: SectionHeader?
    // Varibles
    var strProjectName: String?
    var strProjectDesc: String?
    var strProjectTypeID: String?
    var strStyleTypeID: String?
    var strWorkTypeID: String?
    var strProBudgetTypeID: String?
    var arrSelectedImage = [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        self.tblUploadProject.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        
        if eProjectStatus == .eEditProject {
            hiddenSections = [1,2,3,4,6]
       
            self.getPrjectDetailsApiCalling(forPortfolioID: projectID!)
   
        }
        else if eProjectStatus == .eAddProject {
          
              self.getAllattributesApiCalling()
        
        }
    

       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}

// Intinal Setup and ui Setup
extension UploadProjectNewViewController{
    func initialSetup(){
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true)
        NavigationHelper.helper.tabBarViewController?.hideTabBar()
        NavigationHelper.helper.enableSideMenuSwipe = false
        if eProjectStatus == .eEditProject {
             NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_EDIT_PROJECT
        }
        else if eProjectStatus == .eAddProject {
          NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_ADD_PROJECT
        }
        
        self.tblUploadProject.register(UINib(nibName:"IdeaDiscrptionCellNew", bundle: nil), forCellReuseIdentifier:"IdeaDiscrptionCellNew")
        
        self.tblUploadProject.register(UINib(nibName: "CheckBoxCustomCell", bundle: nil), forCellReuseIdentifier: "CheckBoxCustomCell")
          self.tblUploadProject.register(UINib(nibName: "CertificateTableCellCustom", bundle: nil), forCellReuseIdentifier: "CertificateTableCellCustom")
        self.tblUploadProject.register(UINib(nibName: "JATagsNew", bundle: nil), forCellReuseIdentifier: "JATagsNew")
        self.tblUploadProject.register(UINib(nibName: "UploadImageCell", bundle: nil), forCellReuseIdentifier: "UploadImageCell")
        self.tblUploadProject.register(UINib(nibName: "SubmitButtonCustom", bundle: nil), forCellReuseIdentifier: "SubmitButtonCustom")
        
        self.arrSectionTitle = ["Project Type","Project Type","Style Type","Work Type","Project Budget","Tags","Upload Image"]
        
    }
}
// MARK: User Define Method

extension UploadProjectNewViewController{
    // MARk:- ******* HEADER BUTTON ACTION ***************
    func actionHeader(_ sender: UIButton) {
   
        switch sender.tag {
        case 1:
            if hiddenSections.contains(sender.tag) {
                
                hiddenSections.remove(at: hiddenSections.index(of: sender.tag)!)
                self.tblUploadProject.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
                
            }
            else {
                
                
                hiddenSections.append(sender.tag)
                
                self.tblUploadProject.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
            }
        case 2:
            if hiddenSections.contains(sender.tag) {
                
                hiddenSections.remove(at: hiddenSections.index(of: sender.tag)!)
                self.tblUploadProject.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
                
            }
            else {
                
                
                hiddenSections.append(sender.tag)
                
                self.tblUploadProject.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
            }
        case 3:
            if hiddenSections.contains(sender.tag) {
                
                hiddenSections.remove(at: hiddenSections.index(of: sender.tag)!)
                self.tblUploadProject.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
                
            }
            else {
                
                
                hiddenSections.append(sender.tag)
                
                self.tblUploadProject.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
            }
        case 4:
            if hiddenSections.contains(sender.tag) {
                
                hiddenSections.remove(at: hiddenSections.index(of: sender.tag)!)
                self.tblUploadProject.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
                
            }
            else {
                
                
                hiddenSections.append(sender.tag)
                
                self.tblUploadProject.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
            }
        case 5:
            let skillsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: TagViewController.self)) as! TagViewController
            
            skillsVC.delegateSkills  = self
            NavigationHelper.helper.contentNavController!.pushViewController(skillsVC, animated: true)
        case 6:
            let certiVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: ProjectUploadCertificateController())) as! ProjectUploadCertificateController
            
            certiVC.noCellLimit  = self.arrCertificateData.count
            certiVC.arrCertificateList = self.arrCertificateData
            certiVC.didSaveHandel = {(arrSeletedCertificateList) in
                for index in 0..<arrSeletedCertificateList.count{
                    let dictValue = arrSeletedCertificateList[index]
                      self.arrCertificateData.append(dictValue)
                    let imageData =  UIImagePNGRepresentation(dictValue["certificate"] as! UIImage) as Data?
                 
                    self.arrSelectedImage.append(imageData! as AnyObject)
                    
                }
                if !(self.hiddenSections.contains(6))
                    {
                        self.hiddenSections.append(sender.tag)

                    }
                   
                
                self.tblUploadProject.reloadSections(IndexSet(integer: 6), with: .none)
                
            }
            NavigationHelper.helper.contentNavController!.pushViewController(certiVC, animated: true)
        default: break
            
        }
    
    }
    // This Function check box selection action
    func actionCheckBox(_ sender: UIButton){
        let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.tblUploadProject)
        let cellIndexPath = self.tblUploadProject.indexPathForRow(at: pointInTable)
        
        
        if cellIndexPath?.section == 1{  // working for project  type
            for index in 0..<self.arrProjectTypeData.count{
                
                var objArrt = arrProjectTypeData[index] as! [String: AnyObject]
                
                if objArrt["buttonStatus"] as! Bool  == true{
                    objArrt["buttonStatus"]  =  false as AnyObject?
                    self.arrProjectTypeData.remove(at: index)
                    self.arrProjectTypeData.insert(objArrt as AnyObject, at:index)
                    
                }
                self.tblUploadProject.reloadData()
            }
            
            var dictTEmpStyle = self.arrProjectTypeData[(cellIndexPath?.row)!] as! [String : AnyObject]
            dictTEmpStyle["buttonStatus"] = true as AnyObject?
            self.strProjectTypeID =   String(dictTEmpStyle["id"] as! Int)
            self.arrProjectTypeData.remove(at: (cellIndexPath?.row)!)
            self.arrProjectTypeData.insert(dictTEmpStyle as AnyObject, at: (cellIndexPath?.row)!)
        }
        
        else if cellIndexPath?.section == 2{  // working for style  type
            for index in 0..<self.arrStyleTypeData.count{
                
                var objArrt = arrStyleTypeData[index] as! [String: AnyObject]
                
                if objArrt["buttonStatus"] as! Bool  == true{
                    objArrt["buttonStatus"]  =  false as AnyObject?
                    self.arrStyleTypeData.remove(at: index)
                    self.arrStyleTypeData.insert(objArrt as AnyObject, at:index)
                    
                }
                self.tblUploadProject.reloadData()
            }
            
            var dictTEmpStyle = self.arrStyleTypeData[(cellIndexPath?.row)!] as! [String : AnyObject]
            dictTEmpStyle["buttonStatus"] = true as AnyObject?
            self.strStyleTypeID =   String(dictTEmpStyle["id"] as! Int)
            self.arrStyleTypeData.remove(at: (cellIndexPath?.row)!)
            self.arrStyleTypeData.insert(dictTEmpStyle as AnyObject, at: (cellIndexPath?.row)!)
        }
        
        else if cellIndexPath?.section == 3{  // working for Work  type
            for index in 0..<self.arrWorkTypeData.count{
                
                var objArrt = arrWorkTypeData[index] as! [String: AnyObject]
                
                if objArrt["buttonStatus"] as! Bool  == true{
                    objArrt["buttonStatus"]  =  false as AnyObject?
                    self.arrWorkTypeData.remove(at: index)
                    self.arrWorkTypeData.insert(objArrt as AnyObject, at:index)
                    
                }
                self.tblUploadProject.reloadData()
            }
            
            var dictTEmpStyle = self.arrWorkTypeData[(cellIndexPath?.row)!] as! [String : AnyObject]
            dictTEmpStyle["buttonStatus"] = true as AnyObject?
            self.strWorkTypeID =   String(dictTEmpStyle["id"] as! Int)
            self.arrWorkTypeData.remove(at: (cellIndexPath?.row)!)
            self.arrWorkTypeData.insert(dictTEmpStyle as AnyObject, at: (cellIndexPath?.row)!)
        }
        
        else if cellIndexPath?.section == 4{  // working for project budget  type
            for index in 0..<self.arrProjectBudgetTypeData.count{
                
                var objArrt = arrProjectBudgetTypeData[index] as! [String: AnyObject]
                
                if objArrt["buttonStatus"] as! Bool  == true{
                    objArrt["buttonStatus"]  =  false as AnyObject?
                    self.arrProjectBudgetTypeData.remove(at: index)
                    self.arrProjectBudgetTypeData.insert(objArrt as AnyObject, at:index)
                    
                }
                self.tblUploadProject.reloadData()
            }
            
            var dictTEmpStyle = self.arrProjectBudgetTypeData[(cellIndexPath?.row)!] as! [String : AnyObject]
            dictTEmpStyle["buttonStatus"] = true as AnyObject?
            self.strProBudgetTypeID =   String(dictTEmpStyle["id"] as! Int)
            self.arrProjectBudgetTypeData.remove(at: (cellIndexPath?.row)!)
            self.arrProjectBudgetTypeData.insert(dictTEmpStyle as AnyObject, at: (cellIndexPath?.row)!)
        }
        
    }
    // MARk:- This Function parse the attribute
    func parseAttributesValueWith(forArrAttributes pArrData:[JSON]?)->[AnyObject]{
        var arrTempArrt  = [AnyObject]()
        for object in pArrData! {
            let objAttbuteClass = UserFilterAttribute(withDictionary: object.dictionaryObject! as [String : AnyObject])
            arrTempArrt.append(objAttbuteClass)
        }
        return arrTempArrt
    }
    
    // MARK:- Set User details Data
    
    // This Functon Set the idea name and idea description
    func setIdeaNameWithDescription(forIDeaname ideaName:String?, ideaDescription: String?){
        arrFieldsData.removeAll()
        var  dictLocal = [String: AnyObject]()
        self.strProjectName = ideaName!
        self.strProjectDesc = ideaDescription!
        
        dictLocal = ["ideaName": ideaName! as AnyObject, "ideaDescription": ideaDescription! as AnyObject]
        
        self.arrFieldsData.append(dictLocal as AnyObject)
        self.tblUploadProject.reloadData()
    }
    
    // this functon set the attribute defult whan project details come
    func setDefultAttributeWith(forArrayData pArrData:[AnyObject]?){
      for index in 0..<pArrData!.count{
        let dictAttribute = pArrData![index] as! [String: AnyObject]
        if (dictAttribute["attribute_name"] as! String) == "Project Type" {
        self.strProjectTypeID = (dictAttribute["attribute_value_id"] as! String)
        }
        if (dictAttribute["attribute_name"] as! String) == "Style Type" {
            
            self.strStyleTypeID = (dictAttribute["attribute_value_id"] as! String)
            
        }
        if (dictAttribute["attribute_name"] as! String) == "Work Type" {
            
            self.strWorkTypeID = (dictAttribute["attribute_value_id"] as! String)
            
        }
        if (dictAttribute["attribute_name"] as! String) == "Project Budget" {
            
            self.strProBudgetTypeID = (dictAttribute["attribute_value_id"] as! String)
           
        }
       
       
        
        
        }
    }
    
    // This Functio MAke A local Dict for idea details data.
    func makeLocalDictWith(forArrValue pArrData:[AnyObject], keyValue: String!)
    {
        if keyValue == KEY_ROOM_TYPE{
        
            var dictTempRoomType = [String: AnyObject]()
            self.arrRoomTypeData.removeAll()
            for index in 0..<pArrData.count{
                let objArrt = pArrData[index] as! UserFilterAttribute
                dictTempRoomType = ["id":String(objArrt.id!) as AnyObject ,"name": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject,"keyValue":KEY_PROJECT_TYPE as AnyObject]
                self.arrRoomTypeData.append(dictTempRoomType as AnyObject)
            }
        }
        
        if keyValue == KEY_PROJECT_TYPE{
         var dictTempRoomType = [String: AnyObject]()
            self.arrProjectTypeData.removeAll()
            for index in 0..<pArrData.count{
                let objArrt = pArrData[index] as! UserFilterAttribute
                
                if eProjectStatus == .eEditProject {
                    if self.strProjectTypeID! == String(objArrt.id!){
                        dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": true as AnyObject,"keyValue":KEY_PROJECT_TYPE as AnyObject]
                    }else{
                        dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject,"keyValue":KEY_PROJECT_TYPE as AnyObject]
                    }
                }
                else{
                    dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject,"keyValue":KEY_PROJECT_TYPE as AnyObject]
                    }
                
                self.arrProjectTypeData.append(dictTempRoomType as AnyObject)
            }
           
            }
          
        
        if keyValue == KEY_STYLE_TYPE{
            var dictTempRoomType = [String: AnyObject]()
            self.arrStyleTypeData.removeAll()
            for index in 0..<pArrData.count{
                let objArrt = pArrData[index] as! UserFilterAttribute
                if eProjectStatus == .eEditProject {
                    if self.strStyleTypeID! == String(objArrt.id!){
                        dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": true as AnyObject,"keyValue":KEY_STYLE_TYPE as AnyObject]
                    }
                    else{
                        dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject,"keyValue":KEY_STYLE_TYPE as AnyObject]
                    }
                }else{
                     dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject,"keyValue":KEY_STYLE_TYPE as AnyObject]
                }
                
                
                self.arrStyleTypeData.append(dictTempRoomType as AnyObject)
            }
            
        }
            
        
        else if keyValue == KEY_WORK_TYPE{
            var dictTempRoomType = [String: AnyObject]()
            self.arrWorkTypeData.removeAll()
            for index in 0..<pArrData.count{
                let objArrt = pArrData[index] as! UserFilterAttribute
                if eProjectStatus == .eEditProject {
                    if self.strWorkTypeID! == String(objArrt.id!){
                        dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": true as AnyObject,"keyValue":KEY_WORK_TYPE as AnyObject]
                    }else{
                        dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject,"keyValue":KEY_WORK_TYPE as AnyObject]
                    }
                }else{
                   dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject,"keyValue":KEY_WORK_TYPE as AnyObject]
                }
             
              
                self.arrWorkTypeData.append(dictTempRoomType as AnyObject)
            }
            
        }
        
        else if keyValue == KEY_PROJECT_BUDGET_TYPE{
            var dictTempRoomType = [String: AnyObject]()
            self.arrProjectBudgetTypeData.removeAll()
            for index in 0..<pArrData.count{
                let objArrt = pArrData[index] as! UserFilterAttribute
                if eProjectStatus == .eEditProject {
                
                    if self.strProBudgetTypeID! == String(objArrt.id!){
                        dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": true as AnyObject,"keyValue":KEY_WORK_TYPE as AnyObject]
                    }else{
                        dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject,"keyValue":KEY_WORK_TYPE as AnyObject]
                    }
                }else{
                  dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject,"keyValue":KEY_WORK_TYPE as AnyObject]
                }
               
               
                self.arrProjectBudgetTypeData.append(dictTempRoomType as AnyObject)
            }
            
        }
        else if keyValue == KEY_CERTIFICATE{
            var dictCertificateType = [String: AnyObject]()
            self.arrCertificateData.removeAll()
            for index in 0..<pArrData.count{
                let dictCerImg = pArrData[index]
                if let _ = (dictCerImg["id"] as? String){
                    dictCertificateType =  ["id":(dictCerImg["id"] as? String)! as AnyObject ,"title": "" as AnyObject, "certificate": (dictCerImg["thumb_image"] as? String)! as AnyObject,"keyValue":KEY_CERTIFICATE_UPLOAD_PROJECT as AnyObject]
                    self.arrCertificateData.append(dictCertificateType as AnyObject)
                }
         
            }
            
        }
        self.tblUploadProject.reloadData()
    }
    
    
    func addToolBar(_ textField: UITextView){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        // toolBar.barTintColor = UIColor.redColor()
        toolBar.barTintColor = UIColorRGB(57, g: 181, b: 74)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CertificatePopUpController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CertificatePopUpController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        
        textField.inputAccessoryView = toolBar
    }
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
    
    // This Functio Hide and unhide textview placeholder
    
    func updatePlaceHolderWith(fortextview textView: UITextView, cell1:IdeaDiscrptionCellNew?){
        if let _ = cell1 {
            //let cell = self.tblUploadIdea.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! IdeaDiscrptionCellNew
            let newLength = textView.text.utf16.count
            if newLength > 0 // have text, so don't show the placeholder
            {
             
                cell1!.lblPlaceholder.isHidden = true
                
                
            }else{
                cell1!.lblPlaceholder.text = "Project Description"
                cell1!.lblPlaceholder.isHidden = false
            }
            
            
        }
    }
    
    // This Function PArse Skill List
    func prseSkillsListDefult(forArrSkillList pSkillsList:[AnyObject]?){
        self.arrSkillsData.removeAll()
        
        if pSkillsList!.count > 0 {
            
            for index in 0..<pSkillsList!.count {
                
                let dictSkills = pSkillsList![index]
                
                
                arrSeletedSkillsID.append(String(dictSkills["tag_id"] as! String) as AnyObject)
                
                let dictTemp = ["skill_name":dictSkills["tag_name"] as! String, "id":dictSkills["tag_id"] as! String]
                
                self.arrSkillsData.append(dictTemp as AnyObject)
            }
        }
    }
    
    // this function simpel update teh skill whwn we delete teh skills.
    
    func updateSkills(forArrSkillList pSkillsList:[AnyObject]?){
        self.arrSkillsData.removeAll()
        arrSeletedSkillsID.removeAll()
        if pSkillsList!.count > 0 {
            
            for index in 0..<pSkillsList!.count {
                
                let dictSkills = pSkillsList![index]
                
                arrSeletedSkillsID.append(dictSkills["id"] as! String as AnyObject)
                
                let dictTemp = ["skill_name":dictSkills["skill_name"] as! String, "id":dictSkills["id"] as! String]
                
                self.arrSkillsData.append(dictTemp as AnyObject)
            }
        }
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
    
    // This Function Save Action
    
    func actionSaveButtonTap(_ sender: UIButton){
        
        if !(self.ValidateFields())
        {
            print(" some thing is missing")
            return;
        }
        if eProjectStatus == .eAddProject {
        self.addNewProjectApiCalling()
        }
        else if eProjectStatus == .eEditProject {
        self.editUpdateProjectApiCalling()
        }
    }
    // mark-  ValidateFields
    func ValidateFields() -> Bool
    {	self.view.endEditing(true)
        let result = true
        if self.strProjectName == nil || self.strProjectName == "" {
            Toast.show(withMessage: ENTER_PROJECT)
            return false
        }
        else if self.strProjectDesc == nil || self.strProjectDesc == "" {
            Toast.show(withMessage: ENTER_PROJECT_DESCRIPTION)
            return false
        }
        
        else if self.strProjectTypeID == nil || self.strProjectTypeID == "" {
            Toast.show(withMessage: SELECT_PROJECT_TYPE)
            return false
        }
        else if self.strStyleTypeID == nil || self.strStyleTypeID == "" {
            Toast.show(withMessage: SELECT_STYLETYPE)
            return false
        }
        else if self.strWorkTypeID == nil || self.strWorkTypeID == "" {
            Toast.show(withMessage: SELECT_WORK_TYPE)
            return false
        }
        else if self.strProBudgetTypeID == nil || self.strProBudgetTypeID == "" {
            Toast.show(withMessage: SELECT_BUDGET_TYPE)
            return false
        }
        else if !(self.arrSeletedSkillsID.count > 0) {
            Toast.show(withMessage: TYPE_SOME_TAGS)
            return false
        }
        else if !(self.arrCertificateData.count > 0) {
            Toast.show(withMessage: SELECT_PROJECT_IMAGE)
            return false
        }
        
    	return result
    }
    // This Function Hendal the edit and delete certificate button respose
    
    func certificateImageHandelResposnseWith(forImageID imageID: Int?, seletedIndexValue: Int?, keyValyeType:String?){
        if keyValyeType == kEditImg{
           PopupViewController.showAddOrClearPopUp(self, Title: "Add Details", showRoomButtonType: true, arrData: self.arrRoomTypeData, imageID: imageID!)
            
            
        }else if keyValyeType ==  KDeleteImg{
           self.deleteCeritificateImageApiCallingWith(forImageID: imageID!, indexValue: seletedIndexValue!)
        }
        
    }
}

// MARK- TableView Delegte And DataSource
extension UploadProjectNewViewController{
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        
        return 8
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,7:
            return 1
      
        case 1:
            if hiddenSections.contains(section) {
                if arrProjectTypeData.count > 0{
                    return arrProjectTypeData.count
                }
                else{
                    return 0
                }
            }else{
                return 0
            }
            
        case 2:
            if hiddenSections.contains(section) {
                if arrStyleTypeData.count > 0{
                    return arrStyleTypeData.count
                }
                else{
                    return 0
                }
            }else{
                return 0
            }
            
            
            
            
        case 3:
            if hiddenSections.contains(section) {
                if arrWorkTypeData.count > 0{
                    return arrWorkTypeData.count
                }
                else{
                    return 0
                }
            }else{
                return 0
            }
            
        case 4:
            if hiddenSections.contains(section) {
                if arrProjectBudgetTypeData.count > 0{
                    return arrProjectBudgetTypeData.count
                }
                else{
                    return 0
                }
            }else{
                return 0
            }
            
        case 5:
            if arrSkillsData.count > 0{
                return 1
            }else{
                return 0
            }
        case 6:
            if hiddenSections.contains(section) {
                if arrCertificateData.count > 0{
                    return 1
                }else{
                    return 0
                }
            }
            else{
                return 0
            }
            
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0,7:
            return nil
        default:
            
            viewHeader = SectionHeader.instantiateFromNib()
            
            viewHeader!.lblSectionTitle.text = arrSectionTitle[section]
            viewHeader!.btnSectionHeader.tag = section
            viewHeader!.btnSectionHeader.addTarget(self, action:#selector(actionHeader), for:.touchUpInside)
            return viewHeader
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0,7:
            return 0.0
        default:
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell: BaseTableViewCell?
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IdeaDiscrptionCellNew.self), for: indexPath) as! IdeaDiscrptionCellNew
            (cell as! IdeaDiscrptionCellNew).textIdeaName.delegate = self
            (cell as! IdeaDiscrptionCellNew).textAreaDesc.delegate = self
            if arrFieldsData.count > 0{
                (cell as! IdeaDiscrptionCellNew).datasource = self.arrFieldsData[indexPath.row]
            
                
            }
               self.updatePlaceHolderWith(fortextview: (cell as! IdeaDiscrptionCellNew).textAreaDesc, cell1: cell as?IdeaDiscrptionCellNew)
            
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckBoxCustomCell.self), for: indexPath) as! CheckBoxCustomCell
            (cell as! CheckBoxCustomCell).btnTypicalTitle.addTarget(self, action: #selector(self.actionCheckBox(_:)), for: .touchUpInside)
            (cell as! CheckBoxCustomCell).datasource = self.arrProjectTypeData[indexPath.row]
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckBoxCustomCell.self), for: indexPath) as! CheckBoxCustomCell
            (cell as! CheckBoxCustomCell).btnTypicalTitle.addTarget(self, action: #selector(self.actionCheckBox(_:)), for: .touchUpInside)

            (cell as! CheckBoxCustomCell).datasource = self.arrStyleTypeData[indexPath.row]
            
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckBoxCustomCell.self), for: indexPath) as! CheckBoxCustomCell
            (cell as! CheckBoxCustomCell).btnTypicalTitle.addTarget(self, action: #selector(self.actionCheckBox(_:)), for: .touchUpInside)
            
            (cell as! CheckBoxCustomCell).datasource = self.arrWorkTypeData[indexPath.row]
            
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckBoxCustomCell.self), for: indexPath) as! CheckBoxCustomCell
            (cell as! CheckBoxCustomCell).btnTypicalTitle.addTarget(self, action: #selector(self.actionCheckBox(_:)), for: .touchUpInside)
            
            (cell as! CheckBoxCustomCell).datasource = self.arrProjectBudgetTypeData[indexPath.row]
            
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: JATagsNew.self), for: indexPath) as! JATagsNew
            
            (cell as! JATagsNew).buttonTagsHandler = {(dictValue,indexValue) in
                
 
             
                self.arrSkillsData.remove(at: indexValue)
                self.updateSkills(forArrSkillList: self.arrSkillsData)
                self.tblUploadProject.reloadData()
                
            }
            
            
            (cell as! JATagsNew).dataSource = self.arrSkillsData
        case 6:
           
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CertificateTableCellCustom.self), for: indexPath) as! CertificateTableCellCustom
            
            (cell as! CertificateTableCellCustom).didButtonHanderResponse = {(imageID, IndexValue, keyValueData)in
  
               self.certificateImageHandelResposnseWith(forImageID: imageID!, seletedIndexValue: IndexValue!, keyValyeType: keyValueData!)
            }
            (cell as! CertificateTableCellCustom).dataSource = self.arrCertificateData
            
        case 7:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SubmitButtonCustom.self), for: indexPath) as! SubmitButtonCustom
            (cell as! SubmitButtonCustom).btnSave.addTarget(self, action:#selector(actionSaveButtonTap), for:.touchUpInside)
        default: break
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        switch indexPath.section {
        case 0:
            return 165
        case 1,2,3,4:
            
            return 60
        case 5:
            return IS_IPAD() ? 70 : 60  // tags cell
        case 6:
            return IS_IPAD() ? 200 : 180
            
        default:
            return IS_IPAD() ? 70 : 60
        }
        
    }


}
// MARK:- UITEXTField Delegets and text view delegate
extension UploadProjectNewViewController{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        self.strProjectName = textField.text
        var locDict = arrFieldsData[0] as! [String: AnyObject]
        locDict["ideaName"] = self.strProjectName as AnyObject?
        arrFieldsData.remove(at: 0)
        arrFieldsData.insert(locDict as AnyObject, at: 0)
        
        
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // text View deleagte
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.addToolBar(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        
        self.strProjectDesc = textView.text
        var locDict = arrFieldsData[0] as! [String: AnyObject]
        locDict["ideaDescription"] = self.strProjectDesc as AnyObject?
        arrFieldsData.remove(at: 0)
        arrFieldsData.insert(locDict as AnyObject, at: 0)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        let cell = self.tblUploadProject.cellForRow(at: IndexPath(row: 0, section: 0)) as! IdeaDiscrptionCellNew
        
        if text.characters.count == 0{
            
            let newLength = textView.text.utf16.count + text.utf16.count - range.length
            if newLength > 0 // have text, so don't show the placeholder
            {
                
                cell.lblPlaceholder.isHidden = true
                
                
            }else{
                  cell.lblPlaceholder.text = "Project Description"
                cell.lblPlaceholder.isHidden = false
            }
            return true
            
        }
        else{
            let newLength = textView.text.utf16.count + text.utf16.count - range.length
            if newLength > 0 // have text, so don't show the placeholder
            {
                
                cell.lblPlaceholder.isHidden = true
                
                
            }else{
                cell.lblPlaceholder.text = "Project Description"
                cell.lblPlaceholder.isHidden = false
            }
            
        }
        
        
        return true
    }
}
// USER DeFINE Deletegae
extension UploadProjectNewViewController{
    // skills Delegate
    func didFinishSelectedSkills(forSelectedAllTags pArrTags: [AnyObject]) {
        
        print("ALl Seleted TAgs \(pArrTags)")
        
        
        if pArrTags.count > 0 {
            
            for index in 0..<pArrTags.count {
                
                let dictSkills = pArrTags[index] as! [String: AnyObject]
                
                if arrSkillsData.count > 0{
                    
                    
                    // check sklls already exist or not
                    
                    self.checkSkillsExistWith(arrSkillsData, keySearch: dictSkills["skill_name"] as! String, isExistTags: { (isSkillsAlredyExist) in
                        
                        
                        if isSkillsAlredyExist == false{
                            let dictTemp = ["skill_name":dictSkills["skill_name"] as! String, "id":dictSkills["id"] as! Int] as [String : Any]
                            self.arrSeletedSkillsID.append(dictSkills["skill_name"] as! String as AnyObject)
                            self.arrSkillsData.append(dictTemp as AnyObject)
                        }
                    })
                    
                }
                else{
                    // if arrSkillSData count 0
                    let dictTemp = ["skill_name":dictSkills["skill_name"] as! String, "id":dictSkills["id"] as! Int] as [String : Any]
                    self.arrSeletedSkillsID.append(dictSkills["skill_name"] as! String as AnyObject)
                    self.arrSkillsData.append(dictTemp as AnyObject)
                    
                }
                
                
            }
            
        }
        self.tblUploadProject.reloadData()
    }
}
// MARk:- Api Working hear..
extension UploadProjectNewViewController{
  
  // This Function get the project details,,
    
    func getPrjectDetailsApiCalling(forPortfolioID portfolioID: Int?){
        APIHandler.handler.getPortFolioDetails(forPortFolioID: portfolioID, success: { (response) in
         
            let dictDetails = response?.dictionaryObject
            
          
            
            self.setDefultAttributeWith(forArrayData: dictDetails!["attribute_name"] as? [AnyObject])
            // parse for skills
            self.prseSkillsListDefult(forArrSkillList:dictDetails!["tags"] as? [AnyObject])
           
            
            self.getAllattributesApiCalling()
            
            
            // set idea name and discription.
            self.setIdeaNameWithDescription(forIDeaname: dictDetails!["name"] as? String, ideaDescription: dictDetails!["description"] as? String)
            // set certificate image
            let arrImages = dictDetails!["portfolioImages"] as! [AnyObject]
            self.makeLocalDictWith(forArrValue: arrImages, keyValue: KEY_CERTIFICATE)
            
            self.tblUploadProject.reloadData()
        }) { (error) in
        }
    }
    // This Function Get all Attributes
    func getAllattributesApiCalling(){
        APIHandler.handler.getAttributesForProjrcts({ (response) in
           
            let arrRoomType =  self.parseAttributesValueWith(forArrAttributes:response?["Attributes"][0]["attributeValues"].arrayValue)
            if self.eProjectStatus == .eAddProject {
                self.setIdeaNameWithDescription(forIDeaname:"", ideaDescription:"")
            }
            
            
            
            if arrRoomType .count > 0{
             self.makeLocalDictWith(forArrValue: arrRoomType, keyValue: KEY_ROOM_TYPE)
            }
            let arrStyleType =  self.parseAttributesValueWith(forArrAttributes: response?["Attributes"][1]["attributeValues"].arrayValue)
            
            if arrStyleType .count > 0{
                self.makeLocalDictWith(forArrValue: arrStyleType, keyValue: KEY_STYLE_TYPE)
            }
            let arrProjType = self.parseAttributesValueWith(forArrAttributes:response?["Attributes"][2]["attributeValues"].arrayValue)
            if arrProjType .count > 0{
                self.makeLocalDictWith(forArrValue: arrProjType, keyValue: KEY_PROJECT_TYPE)
            }
            
            
            let arrWookType =  self.parseAttributesValueWith(forArrAttributes: response?["Attributes"][3]["attributeValues"].arrayValue)
            if arrWookType .count > 0{
                self.makeLocalDictWith(forArrValue: arrWookType, keyValue: KEY_WORK_TYPE)
            }
            let arrProjBudgetType =  self.parseAttributesValueWith(forArrAttributes: response?["Attributes"][4]["attributeValues"].arrayValue)
            
            if arrProjBudgetType .count > 0{
                self.makeLocalDictWith(forArrValue: arrProjBudgetType, keyValue: KEY_PROJECT_BUDGET_TYPE)
            }
        }) { (error) in
            
        }
    }
   
   // This is Delete the ceritificate Image
    // Delete the Project Image
    func deleteCeritificateImageApiCallingWith(forImageID imageID: Int?, indexValue: Int?) {
        APIHandler.handler.deleteProjectImage(imageID!, success: { (response) in
            Toast.show(withMessage: DELETE_IMAGE_SUCCESSFULLY)
            self.arrCertificateData.remove(at: indexValue!)
            self.tblUploadProject.reloadData()
        }) { (error) in
            
        }
    }
    
// This Api Add the New Project.
    
    func addNewProjectApiCalling(){
        APIHandler.handler.uploadProject(Globals.sharedClient.userID!, projectName: strProjectName!, description: strProjectDesc!, projectTypeID: strProjectTypeID!, stypeTypeID: strStyleTypeID!, workTypeID: strWorkTypeID!, budgetTypeID: strProBudgetTypeID, arrTags: self.arrSeletedSkillsID, imageData: self.arrSelectedImage, success: { (response) in
            Toast.show(withMessage: ADD_PROJECT_SUCCESSFULLY)
            self.navigationController?.popViewController(animated: true)

        }) { (error) in
            Toast.show(withMessage: SOME_PROBLEM)
        }
    }
    
    // This Api update the project
    func editUpdateProjectApiCalling(){
        APIHandler.handler.editUploadProject(Globals.sharedClient.userID!, projectName: strProjectName!, description: strProjectDesc!, projectTypeID: strProjectTypeID!, stypeTypeID: strStyleTypeID!, workTypeID: strWorkTypeID!, budgetTypeID: strProBudgetTypeID!, arrTags: arrSeletedSkillsID, imageData: arrSelectedImage, projectID: projectID!, success: { (response) in
            Toast.show(withMessage: UPDATE_PROJECT_SUCCESSFULLY)
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            
        }
    }
}
