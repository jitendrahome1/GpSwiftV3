//
//  InfluencerCertificationDetailsController.swift
//  Greenply
//
//  Created by Jitendra on 4/3/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class InfluencerCertificationDetailsController: BaseViewController {

 
    @IBOutlet weak var collectionCertifiDetails: UICollectionView!
    var arrCertificateList =  [AnyObject]()
        var placesData : Data?
    var imageNewCertificte: UIImage?
    var localDict = [String : AnyObject]()
    var arrImagesData = [AnyObject]()
       var mySavedList: [String: AnyObject]?
    var strCertificateTitle: String?
    override func viewDidLoad() {
        super.viewDidLoad()
    NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_CERTIFICATE_LIST
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWithIdeas(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true, isHideSearchButton: true)
             NavigationHelper.helper.enableSideMenuSwipe = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // MARK:- Button Action
    func actionEditCertificate(_ sender: UIButton){
       
        let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.collectionCertifiDetails)
        let cellIndexPath = self.collectionCertifiDetails.indexPathForItem(at: pointInTable)
        let dictCerti = self.arrCertificateList[(cellIndexPath?.row)!] as! [String: AnyObject]
      //  CertificatePopUpController.showAddOrClearPopUp(self, pDictItems: dictCerti)
    
     
        CertificatePopUpController.showAddOrClearPopUp(self,pDictItems:dictCerti,didSubmit: { (forItems, popUp) in
           
            self.arrCertificateList.remove(at: (cellIndexPath?.row)!)
           
            
            self.strCertificateTitle = forItems!["title"] as? String

          
            self.arrCertificateList.insert(forItems! as AnyObject, at:(cellIndexPath?.row)!)
            self.collectionCertifiDetails.reloadData()
        }) {
            
        }
        

    
    }
   
    func actionDeleteCertificcate(_ sender: UIButton){
        let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.collectionCertifiDetails)
        let cellIndexPath = self.collectionCertifiDetails.indexPathForItem(at: pointInTable)
      
   
        self.deleteCertificate(forIndexPathTemp: cellIndexPath!)
        
    }
    func actionAddImage(_ sender: UIButton){
        
        GPImagePickerController.pickImage(onController: self, didPick: { (image) in
          self.imageNewCertificte = image

            self.localDict = ["id":0 as AnyObject ,"title": "" as AnyObject, "certificate": self.imageNewCertificte!]
            self.arrCertificateList.append(self.localDict as AnyObject)
            self.collectionCertifiDetails.reloadData()
        }) { 
            
        }
    }
    
    // This Function Add New Certificate
    func actionAddCertificcate(_ sender: UIButton){
     
        let pointInTable: CGPoint  = sender.convert(sender.bounds.origin, to: self.collectionCertifiDetails)
        let cellIndexPath = self.collectionCertifiDetails.indexPathForItem(at: pointInTable)
        let dictCerti = self.arrCertificateList[(cellIndexPath?.row)!] as! [String: AnyObject]
        
        self.strCertificateTitle = dictCerti["title"] as? String
        if !(self.ValidateFields())
        {
            print(" some thing is missing")
            return;
        }
        
        self.apiCallingWith(fDict: dictCerti, indexValue: cellIndexPath?.row)
        
        
       
    }
    
  // THis Function Update New Add Certificate OR make a new dict
    
    func makeLocalDictWith(fordictValue pDictResult:[String: AnyObject], indexValue: Int?){
     
      
        var dictTemp  = [String: AnyObject]()

          dictTemp = ["id":pDictResult["id"] as! Int as AnyObject ,"title": pDictResult["title"] as! String as AnyObject, "certificate": pDictResult["certificate"]!]
        self.arrCertificateList.remove(at: indexValue!)
     
        self.arrCertificateList.insert(dictTemp as AnyObject, at: indexValue!)
        self.updateUserClassRecordLocal(forArrData: self.arrCertificateList)
      
    }
    // This Function Call APi With Condistion
    
    func apiCallingWith(fDict dictCerti: [String: AnyObject]?, indexValue:Int?){
        self.arrImagesData.removeAll()
        var  imageData: Data?
        let pID = dictCerti!["id"] as! Int
        if dictCerti!["certificate"]!.isKind(of: UIImage.self){
            imageData = UIImagePNGRepresentation(dictCerti!["certificate"] as! UIImage)  // simple uiimage to nsdata
        }
        else
        {
            
            let imageURl = URL(string:dictCerti!["certificate"]!["medium"] as! String)  // image url to image data
            imageData   = try? Data(contentsOf: imageURl!)
        }
        self.arrImagesData.append(imageData! as AnyObject)
        
        if pID != 0{
        // update Api Calling
            self.editCertificateApiCallingWith(forCertificateID: pID, imageCerti: self.arrImagesData, titleName:  dictCerti!["title"] as? String, pIndexValue: indexValue)
        }
        else{
            // add Api Calling
        self.addCertificateAPICallingWith(withImage: self.arrImagesData, titleName:dictCerti!["title"] as? String,pIndexValue: indexValue)
         
        }
       
    }
    // MARK:- This Function Update User User Obkect And Local; Dict
    func updateUserClassRecordLocal(forArrData arrResultData:[AnyObject]!){
        if let data = OBJ_FOR_KEY(kUserLoginDetails) as? Data {
            mySavedList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: AnyObject]
            mySavedList!["certifications"] =  arrResultData! as AnyObject?
            placesData = NSKeyedArchiver.archivedData(withRootObject: (mySavedList)!)
            SET_OBJ_FOR_KEY(placesData! as AnyObject , key: kUserLoginDetails)
        }
    }
    
// MARK:- ValidateFields
    func ValidateFields() -> Bool
    {
    	let result = true
        
        if self.strCertificateTitle!.isBlank {
            Toast.show(withMessage: ENTER_CERTIFICATE_TITLE)
            return false
        }

        
    	return result
    }
    
}

// MARK:- WORKING DELETE AND API CALLING
// MARK:- Collection View Delagte
extension InfluencerCertificationDetailsController: UICollectionViewDataSource, UICollectionViewDelegate {
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = IS_IPAD() ? 20.0 : 10.0
        self.collectionCertifiDetails.collectionViewLayout = layout
    }
    // MARK: UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
   if arrCertificateList.count > 0{
    
    if arrCertificateList.count < 4
    {
        return arrCertificateList.count + 1
    }
    else{
        return arrCertificateList.count
 
    }
    
   }
   else{
    return 1
        }
  
    
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: BaseCollectionViewCell?
            
        

       
        if indexPath.row == arrCertificateList.count{
       
            cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CertificationsCellPlus", for: indexPath) as! CertificationsCellDetails
            
            (cell as! CertificationsCellDetails).btnAddImage.addTarget(self, action: #selector(self.actionAddImage(_:)), for: .touchUpInside)
 
        }
        else{
             cell =  collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CertificationsCellDetails.self), for: indexPath) as! CertificationsCellDetails
            
          
            
            (cell as! CertificationsCellDetails).btnEdit.addTarget(self, action: #selector(self.actionEditCertificate(_:)), for: .touchUpInside)
            (cell as! CertificationsCellDetails).btnDelete.addTarget(self, action: #selector(self.actionDeleteCertificcate(_:)), for: .touchUpInside)
            
        (cell as! CertificationsCellDetails).btnAddCertificate.addTarget(self, action: #selector(self.actionAddCertificcate(_:)), for: .touchUpInside)
            
                (cell as! CertificationsCellDetails).datasource = arrCertificateList[indexPath.row]
        }

        
   
        
        // get action 

        return cell!
    
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
       
  
        return CGSize(width: IS_IPAD() ? 170 : SCREEN_WIDTH / 2 - 15.0, height: IS_IPAD() ? 170 : SCREEN_WIDTH / 2 - 5.0)
       // return CGSizeMake((SCREEN_WIDTH / 2 - (IS_IPAD() ? 20.0 : 15.0)), (SCREEN_WIDTH / 2 - (IS_IPAD() ? 10.0 : 5.0)))
    }
    
}
// API Working
extension InfluencerCertificationDetailsController {
   
    // ADD Certificate Api
    func addCertificateAPICallingWith(withImage imageCerti:[AnyObject]?, titleName: String?, pIndexValue:Int?){
        
        APIHandler.handler.addCertificateWith(forTitle: titleName!, imageData: imageCerti!, success: { (response) in
            print("Add Certificate:\(response)")
            
            
            self.makeLocalDictWith(fordictValue: response!["certificate"].dictionaryObject! as [String : AnyObject], indexValue: pIndexValue!)
            Toast.show(withMessage:ADD_CERTIFICATE_MESSGE)
            
        }) { (error) in
            
        }
        
    }
    
    // Update Certificate Api
    func editCertificateApiCallingWith(forCertificateID id:Int?,imageCerti:[AnyObject]?, titleName: String?, pIndexValue:Int? ){
        // hear we call edit certificate with id
       APIHandler.handler.updateCertificateWith(forCertificateID: id!, title: titleName!, imageData: imageCerti!, success: { (response) in
        print("Response\(response)")
        self.makeLocalDictWith(fordictValue: response!["certificate"].dictionaryObject! as [String : AnyObject], indexValue: pIndexValue!)
          Toast.show(withMessage:UPDATE_CERTIFICATE_MESSGE)
       }) { (error) in
        
        }
        
        
    }
    // Delete The certificate
    func deleteCertificateApiCallingWith(forCertificateID id:Int?, pIndexValue:Int?){
        
        APIHandler.handler.deleteCertificateWith(forCertificateID: id!, success: { (response) in
             print("Response\(response)")
            self.arrCertificateList.remove(at: pIndexValue!)
            self.updateUserClassRecordLocal(forArrData: self.arrCertificateList)
            self.collectionCertifiDetails.reloadData()
               Toast.show(withMessage:DELETE_CERTIFICATE_MESSGE)
            }) { (error) in
                
        }
        }
    

 
    func deleteCertificate(forIndexPathTemp indexPathTemp:IndexPath) {
        // hear we call edit certificate with id
        
          let objCerti = self.arrCertificateList[(indexPathTemp.row)] as! [String: AnyObject]
         let certifitedId = objCerti["id"] as! Int
        if certifitedId != 0 {
            self.deleteCertificateApiCallingWith(forCertificateID: certifitedId, pIndexValue: indexPathTemp.row)
        }
        else{
            self.arrCertificateList.remove(at: indexPathTemp.row)
        }
     
        self.collectionCertifiDetails.reloadData()

    }


}
