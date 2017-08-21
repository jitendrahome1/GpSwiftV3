//
//  ProfileViewTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 16/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ProfileViewTableViewCell: BaseTableViewCell {

    @IBOutlet weak var imageBackgroundProfile: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var buttonEditProf: UIButton!
    @IBOutlet weak var buttonEditCover: UIButton!
    @IBOutlet weak var labelUploadImage: UILabel!
    var profImage: Bool!
    var didSelectImage:((_ profImg: Bool) -> ())?
    var didSelectBackgroundImage:((_ profImg: Bool) -> ())?
    override var datasource: AnyObject? {
        didSet {
            if self.datasource != nil {
//                 self.imageProfile.layoutIfNeeded()
//                    imageProfile.layer.cornerRadius = imageProfile.frame.size.width/2
//                    imageProfile.layer.masksToBounds = true
//                    imageProfile.layer.borderWidth = 1.0;
//                    imageProfile.layer.borderColor = UIColorRGB(57, g: 181, b: 74)!.CGColor
//                    imageProfile.image = datasource as? UIImage
                }
            }
        }
    
    var dataSource: [AnyObject]? {
        didSet {
            if self.dataSource != nil {
              //  imageBackgroundProfile.image = dataSource![0] as? UIImage
                // makeBlurImage(imageBackgroundProfile)
            }
        }
    }
    
    @IBAction func imageAction(_ sender: UIButton) {
        if didSelectImage != nil {
            didSelectImage!(true)
        }
    }
    
    @IBAction func imageBackgroundAction(_ sender: UIButton) {
        if didSelectBackgroundImage != nil {
            didSelectBackgroundImage!(false)
        }
    }
}

extension ProfileViewTableViewCell {
    
    func makeBlurImage(_ imageView:UIImageView?)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageView!.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        imageView?.addSubview(blurEffectView)
    }
}
