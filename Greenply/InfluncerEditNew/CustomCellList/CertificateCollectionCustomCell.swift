//
//  CertificateCollectionCustomCell.swift
//  Greenply
//
//  Created by Jitendra on 4/5/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class CertificateCollectionCustomCell: BaseCollectionViewCell {


    @IBOutlet weak var viewEditBtnBG: UIView!
    
    @IBOutlet weak var btnDeleteImg: UIButton!
    var indexValueTemp: Int?
    @IBOutlet weak var btnEditImg: UIButton!
    @IBOutlet weak var nsHightConstLbl: NSLayoutConstraint!
    @IBOutlet weak var imgCertificate: UIImageView!

    var didTapButtonHanderImage: ((_ imageID: Int?, _ getIndexValue:Int?, _ keyValue: String?) -> ())?
    @IBOutlet weak var lblCertiTitle: UILabel!
    
    
    

    override var datasource: AnyObject? {
        didSet {
            if self.datasource != nil{
                
                if datasource!["keyValue"] as! String == KEY_CERTIFICATE_INFLUENCER{
                  imgCertificate.setImage(withURL: URL(string: (datasource!["certificate"] as AnyObject)["medium"] as! String)!, placeHolderImageNamed: "PlaceholderSquare", andImageTransition: .crossDissolve(0.4))
                    self.viewEditBtnBG.isHidden = true
                    lblCertiTitle.text = datasource!["title"] as? String

                }
                else if datasource!["keyValue"] as! String == KEY_CERTIFICATE_UPLOAD_PROJECT{
                    
                    if (self.datasource!["certificate"]!! as AnyObject).isKind(of: UIImage.self){
                        let imageURl = self.datasource!["certificate"] as! UIImage
                         self.viewEditBtnBG.isHidden = true
                        nsHightConstLbl.constant = 0.0
                        self.imgCertificate.image = imageURl
                    }
                    else{
                      imgCertificate.setImage(withURL: URL(string: datasource!["certificate"]! as! String)!, placeHolderImageNamed: "PlaceholderSquare", andImageTransition: .crossDissolve(0.4))
                    nsHightConstLbl.constant = 0.0
                        self.viewEditBtnBG.isHidden = false
                    }
                }
                
                            
            }
        }
    }
    
    
    override func awakeFromNib() {
//        lblCertiTitle.type = .continuous
//        lblCertiTitle.speed = .duration(8.0)
//        lblCertiTitle.animationCurve = .easeOut
//        lblCertiTitle.fadeLength = IS_IPAD() ? 30 : 20
                
        self.layer.cornerRadius = IS_IPAD() ? 15.0 : 10.0
        self.layer.borderWidth =  1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds =  true

    }
    
    
    @IBAction func actionEditCertificate(_ sender: UIButton) {
        if didTapButtonHanderImage != nil{
            didTapButtonHanderImage!(Int(self.datasource!["id"] as! String) , indexValueTemp!, kEditImg)
        }
        
    
    }
    
    
    @IBAction func actionDeleteCertifiate(_ sender: UIButton) {
        if didTapButtonHanderImage != nil{
    didTapButtonHanderImage!(Int(self.datasource!["id"] as! String) , indexValueTemp!, KDeleteImg)
    
    }
    
}
}
