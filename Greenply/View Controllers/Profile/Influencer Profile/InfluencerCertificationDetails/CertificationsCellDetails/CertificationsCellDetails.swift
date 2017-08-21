//
//  CertificationsCellDetails.swift
//  Greenply
//
//  Created by Jitendra on 4/3/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class CertificationsCellDetails: BaseCollectionViewCell {


    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnAddCertificate: UIButton!
    
    @IBOutlet weak var btnAddImage: UIButton!
    
    
    
     var indexValue: IndexPath?
    var editCertificateHandler: ((_ certificateID: Int)->())?
    var deleteCertificateHandler: ((_ certificateID: Int, _ indexValue: IndexPath)->())?
 
  
    @IBOutlet weak var lblDesc: UILabel!
  
   
    @IBOutlet weak var imgCertificate: UIImageView!
    var objCerti: UserCertificates!

     override var datasource: AnyObject? {
        didSet {
            debugPrint(datasource)
            if datasource!.count > 0{
             
                 self.lblDesc.text = self.datasource!["title"] as? String
//                lblDesc.type = .continuous
//                lblDesc.speed = .duration(8.0)
//                lblDesc.animationCurve = .easeOut
//                lblDesc.fadeLength = IS_IPAD() ? 30 : 20
                let backgroundQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
                backgroundQueue.async(execute: {
                    self.imgCertificate.image = UIImage(named: "PlaceholderSquare")
                    
                    DispatchQueue.main.async(execute: {
                        if (self.datasource!["certificate"]!! as AnyObject).isKind(of: UIImage.self){
                           
                            
                            let imageURl = self.datasource!["certificate"] as! UIImage
                            
                          self.imgCertificate.image = imageURl
   
                        }
                   
                        else{
                            //let imageURl = self.datasource!["certificate"]!!["medium"] as? String
                          
                              let imageURl = ((self.datasource!["certificate"] as! [String: AnyObject])["medium"] as! String)
                            
                            
                            self.imgCertificate.setImage(withURL: URL(string: imageURl)!, placeHolderImageNamed: "PlaceholderSquare", andImageTransition: .crossDissolve(0.4))
                            }
                        
                    })
                    
                })
                
                
            }
            
           }
    }
        override func awakeFromNib() {
         
           
            
        
        self.layer.cornerRadius = IS_IPAD() ? 15.0 : 10.0
        self.layer.borderWidth = IS_IPAD() ? 2.0 : 1.0
        self.layer.borderColor = UIColor(red: 210.0 / 255.0, green: 210.0 / 255.0, blue: 210.0 / 255.0, alpha: 1.0).cgColor
        self.layer.masksToBounds = true
        }
}
extension CertificationsCellDetails{
    
//    @IBAction func actionEditCertificate(sender: UIButton) {
//        if editCertificateHandler != nil{
//         editCertificateHandler!(certificateID: objCerti.id!)
//        }
//    }
//    
//    @IBAction func actionDeleteCertificate(sender: UIButton) {
//        if deleteCertificateHandler != nil{
//            deleteCertificateHandler!(certificateID: objCerti.id!, indexValue:indexValue!)
//        }
//    
//    }
}
