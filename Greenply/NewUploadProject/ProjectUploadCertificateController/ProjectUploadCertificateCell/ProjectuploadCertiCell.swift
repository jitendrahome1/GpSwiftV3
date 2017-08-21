//
//  ProjectuploadCertiCell.swift
//  Greenply
//
//  Created by Jitendra on 5/5/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class ProjectuploadCertiCell: BaseCollectionViewCell {

    @IBOutlet weak var imgCertificate: UIImageView!
    @IBOutlet weak var btnAddImage: UIButton!
    override var datasource: AnyObject? {
        didSet {
            debugPrint(datasource)
            if datasource!.count > 0{
                if (self.datasource!["certificate"]!! as AnyObject).isKind(of: UIImage.self){
                    let imageURl = self.datasource!["certificate"] as! UIImage
                    
                    self.imgCertificate.image = imageURl
                    
                }else{
                    let backgroundQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
                    backgroundQueue.async(execute: {
                        let imageURl = self.datasource!["certificate"] as? String
                        
                        self.imgCertificate.setImage(withURL: URL(string: imageURl!)!, placeHolderImageNamed: "PlaceholderSquare", andImageTransition: .crossDissolve(0.4))
                    })
                }

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
