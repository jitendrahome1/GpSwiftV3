//
//  ProjectUploadCertificateController.swift
//  Greenply
//
//  Created by Jitendra on 5/5/17.
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


class ProjectUploadCertificateController: BaseViewController {

    @IBOutlet weak var btnSave: UIButton!
    var didSaveHandel:((_ arrSeletedCerti:[AnyObject])->())!
    @IBOutlet weak var collViewProjectUpload: UICollectionView!
    
    var noCellLimit: Int?
    var totalCellCount: Int?
    var imageNewCertificte: UIImage?
    var arrCertificateList =  [AnyObject]()
    var arrSeletedCertificateList =  [AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        

        totalCellCount = 9
        NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_CERTIFICATE_LIST
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWithIdeas(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true, isHideSearchButton: true)
        NavigationHelper.helper.enableSideMenuSwipe = false
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        if arrCertificateList.count > 0 {
            self.didSaveHandel!(self.arrSeletedCertificateList)
            NavigationHelper.helper.contentNavController?.popViewController(animated: true)
           
        }else{
            Toast.show(withMessage: SELECT_PROJECT_IMAGE)
        }
    }

}
// MARk:- User Define Function
// This function add a new image
extension ProjectUploadCertificateController {
    func actionAddImage(_ sender: UIButton){
        
        GPImagePickerController.pickImage(onController: self, didPick: { (image) in
            self.imageNewCertificte = image
           
          let localDict =  ["id":0 ,"title": "", "certificate": self.imageNewCertificte!,"keyValue":KEY_CERTIFICATE_UPLOAD_PROJECT] as [String : Any]
            self.arrSeletedCertificateList.append(localDict as AnyObject)
             self.arrCertificateList.append(localDict as AnyObject)
            self.noCellLimit = self.noCellLimit! + 1
            self.collViewProjectUpload.reloadData()
        }) {
            
        }
    }
    
   

    
}

// MARL:- This is Collection View deletegate and datasocurece
extension ProjectUploadCertificateController{
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = IS_IPAD() ? 20.0 : 10.0
        self.collViewProjectUpload.collectionViewLayout = layout
    }
    // MARK: UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if noCellLimit < totalCellCount
        {
            return noCellLimit! + 1
        }
        else{
            return totalCellCount!
            
        }
        
    }
  
func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BaseCollectionViewCell?
    if indexPath.row == noCellLimit{
    cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CertificationsCellPlus", for: indexPath) as! ProjectuploadCertiCell
      (cell as! ProjectuploadCertiCell).btnAddImage.addTarget(self, action: #selector(self.actionAddImage(_:)), for: .touchUpInside)
    }
    else{
     cell =  collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProjectuploadCertiCell.self), for: indexPath) as! ProjectuploadCertiCell
          (cell as! ProjectuploadCertiCell).datasource = arrCertificateList[indexPath.row]
    }
    
        
        return cell!
        
    
}
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
    return CGSize(width: IS_IPAD() ? 170 : SCREEN_WIDTH / 2 - 15.0, height: IS_IPAD() ? 170 : SCREEN_WIDTH / 2 - 5.0)
      
    }
}
