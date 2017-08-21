//
//  UploadImageCell.swift
//  Greenply
//
//  Created by Jitendra on 4/26/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class UploadImageCell: BaseTableViewCell {
    
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var imgCertificate: UIImageView!
    
    override var datasource: AnyObject? {
        didSet {
            if self.datasource != nil{
                
                if (self.datasource!["certificateImageURl"]!! as AnyObject).isKind(of: UIImage.self){
                    self.btnSelectImage.setTitle("", for: .normal)
                    self.imgCertificate.image = self.datasource!["certificateImageURl"] as? UIImage
                    self.btnSelectImage.backgroundColor = UIColor.clear
                }
                else if ((self.datasource!["certificateImageURl"]! as AnyObject) as! String == ""){
                    self.btnSelectImage.backgroundColor = UIColor.lightGray
                    self.btnSelectImage.setTitle("+", for: .normal)
                }
                    
                    
                else{
                    self.btnSelectImage.setTitle("", for: .normal)
                    self.btnSelectImage.backgroundColor = UIColor.clear
                    
                    self.imgCertificate.setImage(withURL: URL(string: (self.datasource!["certificateImageURl"] as? String)!)!, placeHolderImageNamed: "PlaceholderSquare", andImageTransition: .crossDissolve(0.4))
                    
                }
                
            }
        }
    }
    
    override func awakeFromNib() {
        self.imgCertificate.layer.cornerRadius = 8.0
        self.imgCertificate.layer.borderWidth = 1.0
        self.imgCertificate.layer.borderColor = UIColor.lightGray.cgColor
        
    }
}
