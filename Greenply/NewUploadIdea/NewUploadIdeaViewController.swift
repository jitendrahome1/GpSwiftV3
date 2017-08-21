//
//  NewUploadIdeaViewController.swift
//  Greenply
//
//  Created by Jitendra on 23/04/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit
enum eUloadEditIdea {
    case eUploadIdea
    case eIdeaDetails
}
class NewUploadIdeaViewController: BaseViewController,SkillsTagsDeleagte, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var tblUploadIdea: UITableView!
    var arrSectionTitle = [String]()
    var arrStyleTypeData = [AnyObject]()
    var arrRoomTypeData = [AnyObject]()
    var arrSkillsData = [AnyObject]()
    var arrCertificateData = [AnyObject]()
    var IdeaID: Int?
    var arrFieldsData = [AnyObject]()
    var arrSeletedSkillsID = [AnyObject]()
    var hiddenSections: [Int] = []
    var imageNewCertificte: UIImage?
    var btnPrvIndexValue: Int = -1
    var eUloadIdeaStatus: eUloadEditIdea = .eUploadIdea
    var strRoomTypeID: String?
    var strStypeTypeID: String?
    var strIdeaName: String?
    var strIdeaDescription: String?
    var strImageIdeaBase64: String?
    var fileType: String?
    var viewHeader: SectionHeader?
    override func viewDidLoad() {
        super.viewDidLoad()
        
           self.tblUploadIdea.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        self.tblUploadIdea.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        self.initialSetup()
        if eUloadIdeaStatus == .eUploadIdea {
      
        self.getAttributesApiCalling()
        }
        else if eUloadIdeaStatus == .eIdeaDetails{
     
            self.ideaDetailsApiCallingWith(forIdeaId: IdeaID!)
        self.hiddenSections = [1,2,4]
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if eUloadIdeaStatus == .eUploadIdea {
          NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_UPLOAD_IDEAS
        }
        else if eUloadIdeaStatus == .eIdeaDetails{
           NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_EDIT_IDEAS
        }
    }


}

extension NewUploadIdeaViewController{
    func initialSetup(){
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true)
        NavigationHelper.helper.tabBarViewController?.hideTabBar()
         NavigationHelper.helper.enableSideMenuSwipe = false
          self.tblUploadIdea.register(UINib(nibName:"IdeaDiscrptionCellNew", bundle: nil), forCellReuseIdentifier:"IdeaDiscrptionCellNew")
        
   self.tblUploadIdea.register(UINib(nibName: "CheckBoxCustomCell", bundle: nil), forCellReuseIdentifier: "CheckBoxCustomCell")
         self.tblUploadIdea.register(UINib(nibName: "JATagsNew", bundle: nil), forCellReuseIdentifier: "JATagsNew")
         self.tblUploadIdea.register(UINib(nibName: "UploadImageCell", bundle: nil), forCellReuseIdentifier: "UploadImageCell")
         self.tblUploadIdea.register(UINib(nibName: "SubmitButtonCustom", bundle: nil), forCellReuseIdentifier: "SubmitButtonCustom")
    
     self.arrSectionTitle = ["Style Type","Style Type","Room Type","Tags","Upload Image"]
    
    }
}

// MARK: User Define Method

extension NewUploadIdeaViewController{
    // MARk:- ******* HEADER BUTTON ACTION ***************
    func actionHeader(_ sender: UIButton) {
       

        
        switch sender.tag {
            
            
        case 1:
            if hiddenSections.contains(sender.tag) {
                
                hiddenSections.remove(at: hiddenSections.index(of: sender.tag)!)
                self.tblUploadIdea.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
            
            }
            else {

               
                hiddenSections.append(sender.tag)
              
                self.tblUploadIdea.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
            }
            
            
        case 2:
            
            if hiddenSections.contains(sender.tag) {
                
                hiddenSections.remove(at: hiddenSections.index(of: sender.tag)!)
                self.tblUploadIdea.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
                
            }
            else {



                hiddenSections.append(sender.tag)
                self.tblUploadIdea.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
            }
          
        case 3:
            let skillsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: TagViewController.self)) as! TagViewController
            
            skillsVC.delegateSkills  = self
            NavigationHelper.helper.contentNavController!.pushViewController(skillsVC, animated: true)
            
        case 4:
            if hiddenSections.contains(sender.tag) {
                
                hiddenSections.remove(at: hiddenSections.index(of: sender.tag)!)
                self.tblUploadIdea.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
                
            }
            else {
                hiddenSections.append(sender.tag)
                self.tblUploadIdea.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
            }
        default: break
            
        }
        

        
       
      
   
    }
    // This Function Save / update record action
    func actionSaveButtonTap(_ sender: UIButton){
        if !(self.ValidateFields())
        {
            print(" some thing is missing")
            return;
        }
         print(" api work")
        if eUloadIdeaStatus == .eUploadIdea {
        self.uploadNewIdeaApiCalling()
        }
        else if eUloadIdeaStatus == .eIdeaDetails{
            self.updateIdeaApiCalling()
        
        }
  
    }
    // This Function Validate The fiels.
    //Mark:- Validate Fields...
    func ValidateFields() -> Bool
    {
        let result = true
        self.view.endEditing(true)
        if self.strIdeaName == nil || self.strIdeaName == "" {
            Toast.show(withMessage: ENTER_IDEA)
            return false
        }
        else if self.strIdeaDescription == nil || self.strIdeaDescription == "" {
            Toast.show(withMessage: ENTER_IDEA_DESCRIPTION)
            return false
        }
        else if self.strStypeTypeID == nil || self.strStypeTypeID == "" {
            Toast.show(withMessage: SELECT_STYLETYPE)
            return false
        }
        else if self.strRoomTypeID == nil || self.strRoomTypeID == "" {
            Toast.show(withMessage: SELECT_ROOMTYPE)
            return false
        }
        else if self.strImageIdeaBase64 == nil ||  self.strImageIdeaBase64 == "" {
            Toast.show(withMessage: SELECT_IDEA_IMAGE)
            return false
        }
        else if !(self.arrSkillsData.count > 0) {
            Toast.show(withMessage: TYPE_SOME_TAGS)
            return false
        }
        return result
        
        
        
        
        
    }

    
    // This Function check box selection action
    func actionCheckBoxStyleType(_ sender: UIButton){   // checking action for style type
        let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.tblUploadIdea)
        let cellIndexPath = self.tblUploadIdea.indexPathForRow(at: pointInTable)
        
        
        if cellIndexPath?.section == 1{  // working for style type
            for index in 0..<self.arrStyleTypeData.count{
                
                var objArrt = arrStyleTypeData[index] as! [String: AnyObject]
                
                if objArrt["buttonStatus"] as! Bool  == true{
                    objArrt["buttonStatus"]  =  false as AnyObject?
                    self.arrStyleTypeData.remove(at: index)
                    self.arrStyleTypeData.insert(objArrt as AnyObject, at:index)
                    
                }
                self.tblUploadIdea.reloadData()
            }
            
            var dictTEmpStyle = self.arrStyleTypeData[(cellIndexPath?.row)!] as! [String : AnyObject]
            dictTEmpStyle["buttonStatus"] = true as AnyObject?
             self.strStypeTypeID =   String(dictTEmpStyle["id"] as! Int)
            self.arrStyleTypeData.remove(at: (cellIndexPath?.row)!)
            self.arrStyleTypeData.insert(dictTEmpStyle as AnyObject, at: (cellIndexPath?.row)!)
        }
        
        
        else if cellIndexPath?.section == 2{  // working for room type
            for index in 0..<self.arrRoomTypeData.count{
                
                var objArrt = arrRoomTypeData[index] as! [String: AnyObject]
                
                if objArrt["buttonStatus"] as! Bool  == true{
                    objArrt["buttonStatus"]  =  false as AnyObject?
                    self.arrRoomTypeData.remove(at: index)
                    self.arrRoomTypeData.insert(objArrt as AnyObject, at:index)
                    
                }
                self.tblUploadIdea.reloadData()
            }
            
            var dictTEmpStyle = self.arrRoomTypeData[(cellIndexPath?.row)!] as! [String : AnyObject]
            dictTEmpStyle["buttonStatus"] = true as AnyObject?
            self.strRoomTypeID =   String(dictTEmpStyle["id"] as! Int)
            self.arrRoomTypeData.remove(at: (cellIndexPath?.row)!)
            self.arrRoomTypeData.insert(dictTEmpStyle as AnyObject, at: (cellIndexPath?.row)!)
        }
        
      
        
}
// THis Function Select the certificate Image
    func actionSelectCertificateImage(_ sender: UIButton){
        let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.tblUploadIdea)
        let cellIndexPath = self.tblUploadIdea.indexPathForRow(at: pointInTable)
        let cell =  self.tblUploadIdea.cellForRow(at: cellIndexPath!) as! UploadImageCell
        GPImagePickerController.pickImage(onController: self, didPick: { (image) in
           
            self.imageNewCertificte = image
            let dataProfileImage: Data = UIImagePNGRepresentation(self.imageNewCertificte!)!
            self.fileType = MIMEType.mimeType(for: dataProfileImage)
            cell.btnSelectImage.backgroundColor = UIColor.clear
            cell.btnSelectImage.setTitle("", for: .normal)
            self.strImageIdeaBase64 = dataProfileImage.base64EncodedString(options: .lineLength64Characters)
            cell.imgCertificate.image = self.imageNewCertificte
                var dictData = self.arrCertificateData[(cellIndexPath?.row)!] as! [String: AnyObject]
                dictData["certificateImageURl"] =  self.imageNewCertificte
                self.arrCertificateData.remove(at: (cellIndexPath?.row)!)
                self.arrCertificateData.insert(dictData as AnyObject, at: (cellIndexPath?.row)!)
            
            
          
        }) {
            
        }
    }

    // This Functon Set the idea name and idea description
    func setIdeaNameWithDescription(forIDeaname ideaName:String?, ideaDescription: String?){
        arrFieldsData.removeAll()
        var  dictLocal = [String: AnyObject]()
        

        dictLocal = ["ideaName": ideaName! as AnyObject, "ideaDescription": ideaDescription! as AnyObject]
      
        self.arrFieldsData.append(dictLocal as AnyObject)
        self.tblUploadIdea.reloadData()
    }
    // This Function PArse Skill List
    func prseSkillsListDefult(forArrSkillList pSkillsList:[AnyObject]?){
        self.arrSkillsData.removeAll()

        if pSkillsList!.count > 0 {
            
            for index in 0..<pSkillsList!.count {
                
                let dictSkills = pSkillsList![index]
                
               arrSeletedSkillsID.append(String(dictSkills["id"] as! Int) as AnyObject)
                
                let dictTemp = ["skill_name":dictSkills["tag_name"] as! String, "id":dictSkills["id"] as! Int] as [String : Any]
                
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
                
                arrSeletedSkillsID.append(String(dictSkills["id"] as! Int) as AnyObject)
                
                let dictTemp = ["skill_name":dictSkills["skill_name"] as! String, "id":dictSkills["id"] as! Int] as [String : Any]
                
                self.arrSkillsData.append(dictTemp as AnyObject)
            }
        }
    }
    // This Function parse Idea Image
    func parseIdeaImageWith(forImageURl pImageUrl: String?){
        
        self.arrCertificateData.removeAll()
            var dictLocal = [String: AnyObject]()
        
        
        if self.eUloadIdeaStatus == .eIdeaDetails{
            dictLocal = ["certificateImageURl": pImageUrl! as AnyObject]
            self.arrCertificateData.append(dictLocal as AnyObject)
            // downalod image
            JAImageDownloader.sharedDownloader.downloadImageWith(forImageURL: pImageUrl!) { (imageData) in
                let backgroundQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
                self.imageNewCertificte = nil
                backgroundQueue.async(execute: {
                    self.imageNewCertificte = UIImage(data: imageData as Data)
                    self.strImageIdeaBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                    self.fileType = MIMEType.mimeType(for: imageData)
                    
                })
            }
        
        
        
        
        }
        else{
            dictLocal = ["certificateImageURl": pImageUrl! as AnyObject]
            self.arrCertificateData.append(dictLocal as AnyObject)
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
    
    // This Functio MAke A local Dict for idea details data.
    func makeLocalDictWith(forArrValue pArrData:[AnyObject], keyValue: String!)
    {
        if keyValue == KEY_ROOM_TYPE{
            var dictTempRoomType = [String: AnyObject]()
            self.arrRoomTypeData.removeAll()
            for index in 0..<pArrData.count{
                let objArrt = pArrData[index] as! UserFilterAttribute
                //here key value attributes is added...
                
                if self.eUloadIdeaStatus == .eIdeaDetails{
                if self.strRoomTypeID! == String(objArrt.id!){
                dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": true as AnyObject,"keyValue":KEY_ROOM_TYPE as AnyObject]
                }else{
                dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject,"keyValue":KEY_ROOM_TYPE as AnyObject]
                }
                }
                else{
                     dictTempRoomType = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject,"keyValue":KEY_ROOM_TYPE as AnyObject]
                }
                self.arrRoomTypeData.append(dictTempRoomType as AnyObject)
                
            }

        }
            
        else if keyValue == KEY_STYLE_TYPE{
            self.arrStyleTypeData.removeAll()
            var dictTempStyleType = [String: AnyObject]()
            for index in 0..<pArrData.count{
                let objArrt = pArrData[index] as! UserFilterAttribute
                
                    if self.eUloadIdeaStatus == .eIdeaDetails{
                if strStypeTypeID! == String(objArrt.id!){
                dictTempStyleType  = ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": true as AnyObject,"keyValue":KEY_STYLE_TYPE as AnyObject]
                }else{
                dictTempStyleType =  ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject,"keyValue":KEY_STYLE_TYPE as AnyObject]
                }
                }
                else{
                dictTempStyleType =  ["id":objArrt.id! as AnyObject ,"typicalValue": objArrt.name! as AnyObject , "buttonStatus": false as AnyObject,"keyValue":KEY_STYLE_TYPE as AnyObject]
                }
                self.arrStyleTypeData.append(dictTempStyleType as AnyObject)
            
            }
            
            
        }
        
        self.tblUploadIdea.reloadData()
        
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
                cell1!.lblPlaceholder.isHidden = false
            }
      
        
        }
    }
    
}

// MARK- TableView Delegte And DataSource
extension NewUploadIdeaViewController{
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
   
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,5:
            return 1
     
        case 1:
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
           
            
            
            
        case 2:
            if hiddenSections.contains(section) {
                if arrRoomTypeData.count > 0{
                    return arrRoomTypeData.count
                }
                else{
                    return 0
                }
            }else{
                 return 0
            }
          
        case 3:
            if arrSkillsData.count > 0{
                return 1
            }else{
                return 0
            }
        case 4:
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
        case 0,5:
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
        case 0,5:
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
           // self.updatePlaceHolderWith(fortextview:(cell as! IdeaDiscrptionCellNew).textAreaDesc,cell:IdeaDiscrptionCellNew)
            
            self.updatePlaceHolderWith(fortextview: (cell as! IdeaDiscrptionCellNew).textAreaDesc, cell1: cell as?IdeaDiscrptionCellNew)
        }
      
        case 1:
          cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckBoxCustomCell.self), for: indexPath) as! CheckBoxCustomCell
             (cell as! CheckBoxCustomCell).btnTypicalTitle.addTarget(self, action: #selector(self.actionCheckBoxStyleType(_:)), for: .touchUpInside)
             (cell as! CheckBoxCustomCell).datasource = self.arrStyleTypeData[indexPath.row]
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckBoxCustomCell.self), for: indexPath) as! CheckBoxCustomCell
              (cell as! CheckBoxCustomCell).btnTypicalTitle.addTarget(self, action: #selector(self.actionCheckBoxStyleType(_:)), for: .touchUpInside)
               // (cell as! CheckBoxCustomCell).btnTypicalTitle.addTarget(self, action: #selector(self.actionCheckBoxRoomType(_:)), forControlEvents: .TouchUpInside)
             (cell as! CheckBoxCustomCell).datasource = self.arrRoomTypeData[indexPath.row]
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: JATagsNew.self), for: indexPath) as! JATagsNew
            
            (cell as! JATagsNew).buttonTagsHandler = {(dictValue,indexValue) in
                
                self.arrSkillsData.remove(at: indexValue)
                self.updateSkills(forArrSkillList: self.arrSkillsData)
                  self.tblUploadIdea.reloadData()
                
                
            }
            
                
            
            (cell as! JATagsNew).dataSource = self.arrSkillsData
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UploadImageCell.self), for: indexPath) as! UploadImageCell
        (cell as! UploadImageCell).btnSelectImage.addTarget(self, action:#selector(actionSelectCertificateImage), for:.touchUpInside)
            (cell as! UploadImageCell).datasource = self.arrCertificateData[indexPath.row]

        case 5:
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
        case 1,2:
            
             return 60
        case 3:
            return IS_IPAD() ? 70 : 60  // tags cell
        case 4:
            return IS_IPAD() ? 200 : 180

        default:
              return IS_IPAD() ? 70 : 60
        }
    
    }
}
// MARK:- UITEXTField Delegets and text view delegate
extension NewUploadIdeaViewController{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
   
            self.strIdeaName = textField.text
            var locDict = arrFieldsData[0] as! [String: AnyObject]
            locDict["ideaName"] = self.strIdeaName as AnyObject?
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
      
            self.strIdeaDescription = textView.text
            var locDict = arrFieldsData[0] as! [String: AnyObject]
            locDict["ideaDescription"] = self.strIdeaDescription as AnyObject?
            arrFieldsData.remove(at: 0)
            arrFieldsData.insert(locDict as AnyObject, at: 0)
        }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
      
        let cell = self.tblUploadIdea.cellForRow(at: IndexPath(row: 0, section: 0)) as! IdeaDiscrptionCellNew
      
        if text.characters.count == 0{
            
            let newLength = textView.text.utf16.count + text.utf16.count - range.length
            if newLength > 0 // have text, so don't show the placeholder
            {
                
                  cell.lblPlaceholder.isHidden = true
                
                
            }else{
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
                cell.lblPlaceholder.isHidden = false
            }
            
        }
        
        
        return true
    }
    
    
    
    
}
// USER DeFINE Deletegae
extension NewUploadIdeaViewController{
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
    self.tblUploadIdea.reloadData()
    }

}
// MARK:- WORKING On API Calling
extension NewUploadIdeaViewController {
    // This Api Get the idea deatils...
    func ideaDetailsApiCallingWith(forIdeaId ideaID:Int?){
        
        APIHandler.handler.getIdeaDetails(ideaID!, success: { (response) in
       
        print("Respose Idea details\(response)")
   
        let dictDetails = response!["Idea"].dictionaryObject
        self.strRoomTypeID = String(((dictDetails!["attributeWithValue"] as AnyObject)["room_type"] as AnyObject)["value_id"] as! Int)
        
        self.strStypeTypeID = String(((dictDetails!["attributeWithValue"] as AnyObject)["style_type"] as AnyObject)["value_id"] as! Int)
            // parse for skills
            self.prseSkillsListDefult(forArrSkillList:dictDetails!["tags"] as? [AnyObject])
            // set idea name and discription.
            self.setIdeaNameWithDescription(forIDeaname: dictDetails!["idea_name"] as? String, ideaDescription: dictDetails!["description"] as? String)
            self.strIdeaName = dictDetails!["idea_name"] as? String
            self.strIdeaDescription  = dictDetails!["description"] as? String
            // parse for idea image
            self.parseIdeaImageWith(forImageURl: (dictDetails!["idea_image"] as AnyObject)["thumb"] as? String)
            self.getAttributesApiCalling()
   
        }) { (error) in
        
        }
    }
    
    // This Api get all Attribiutes,
  
    func getAttributesApiCalling(){
        APIHandler.handler.getAttributesForProjrcts({ (response) in
            
            var arrRoomType = [AnyObject]()
            var arrStyleType = [AnyObject]()
            arrRoomType =   self.parseAttributesValueWith(forArrAttributes:response?["Attributes"][0]["attributeValues"].arrayValue)
                arrStyleType =  self.parseAttributesValueWith(forArrAttributes: response?["Attributes"][1]["attributeValues"].arrayValue)
            
            if self.eUloadIdeaStatus == .eUploadIdea{
                self.parseIdeaImageWith(forImageURl: "") // for upload new idea image shuld be blank
                self.setIdeaNameWithDescription(forIDeaname: "", ideaDescription: "")
            }
            
       
            if  arrRoomType.count > 0{
                self.makeLocalDictWith(forArrValue:arrRoomType, keyValue: KEY_ROOM_TYPE)
            }
                if  arrStyleType.count > 0{
                self.makeLocalDictWith(forArrValue: arrStyleType, keyValue: KEY_STYLE_TYPE)
            }
            

            
        }) { (error) in
            
        }
    }
    
    // This api Upload new idea
    func uploadNewIdeaApiCalling(){
        let strSeletedAttrubt = self.strRoomTypeID! + "," + self.strStypeTypeID!

        APIHandler.handler.uploadIdea(strIdeaName!, description: strIdeaDescription!, fileType: fileType, fileName: String((Date.getTimeStamp() + ".jpg")), fileSize: "100", base64: strImageIdeaBase64!, IdeaTag: self.arrSeletedSkillsID, attributeValues: strSeletedAttrubt, success: { (response) in
            debugPrint(response)
            Toast.show(withMessage: UPLOAD_IDEA_SUCCESSFULLY)
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            debugPrint(error)
            
            if error!._code == NSURLErrorTimedOut {
                
                Toast.show(withMessage: REQUEST_TIME_OUT)
            }
            else{
                
                Toast.show(withMessage:SOME_PROBLEM)
                
            }
            
        }
    }
    
  // api to update the idea.
    func updateIdeaApiCalling(){
        let strSeletedAttrubt = self.strRoomTypeID! + "," + self.strStypeTypeID!

        APIHandler.handler.editUploadIdea(forIdeaId:IdeaID!, ideaName: strIdeaName!, description: strIdeaDescription!, fileType: fileType, fileName: String((Date.getTimeStamp() + ".jpg")), fileSize: "100", base64: self.strImageIdeaBase64!, IdeaTag: self.arrSeletedSkillsID, attributeValues: strSeletedAttrubt, success: { (response) in
            debugPrint(response)
            Toast.show(withMessage: UPDATE_IDEA_SUCCESSFULLY)
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            debugPrint(error)
        }
    }
    
    
}


