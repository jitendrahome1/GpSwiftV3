//
//  ProfileCellNew.swift
//  Greenply
//
//  Created by Jitendra on 4/4/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class ProfileCellNew: BaseTableViewCell {

    @IBOutlet weak var imgBG: UIImageView!
   
    @IBOutlet weak var btnBGImg: UIButton!
    @IBOutlet weak var lblProfileImg: UILabel!
    @IBOutlet weak var btnProfleImg: UIButton!
    
    @IBOutlet weak var imgProfile: UIImageView!
    override var datasource: AnyObject? {
        didSet {
            if self.datasource != nil{
       
                if  (self.datasource!["imageProfile"]!! as AnyObject).isKind(of: UIImage.self){
                    self.imgProfile.image = self.datasource!["imageProfile"] as? UIImage

                }else if (self.datasource!["imageBG"]!! as AnyObject).isKind(of: UIImage.self){
                    self.imgBG.image = self.datasource!["imageBG"] as? UIImage
 
                }
                else{
                
                let backgroundQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
                backgroundQueue.async(execute: {
                         self.imgProfile.setImage(withURL: URL(string:self.datasource!["imageProfile"] as! String)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))
                    self.imgBG.setImage(withURL: URL(string: self.datasource!["imageBG"] as! String)!, placeHolderImageNamed: "DefultProfileImage", andImageTransition: .crossDissolve(0.4))
                    DispatchQueue.main.async(execute: {
                        self.imageCircle()
                    })
                    
                })
                
                }
            
            }
      
    
        }
      

    }
    
    override func awakeFromNib() {
       
    }
        func imageCircle() {
            self.imgProfile.layoutIfNeeded()
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height / 2
            self.imgProfile.layer.borderWidth = 0.8;
            self.imgProfile.layer.borderColor = UIColorRGB(57, g: 181, b: 74)!.cgColor
            self.imgProfile.layer.masksToBounds = true
        }
    
}

 
