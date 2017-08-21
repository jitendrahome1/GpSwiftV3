//
//  ProjectDetailsViewCollectionCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 26/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ProjectDetailsViewCollectionCell: BaseCollectionViewCell {
    @IBOutlet weak var imageProjectDetails: UIImageView!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var txtViewDetails: UITextView!
    var actionLikeHandler: ((_ imageID: String, _ imageLikeStatus: Bool)->())?
    @IBOutlet weak var labelLikeCount: UILabel!
    var objProjDetails: ProfileImage!
    @IBOutlet weak var buttonLike: UIButton!
    override var datasource: AnyObject? {
        didSet {
           objProjDetails = datasource as! ProfileImage
            imageProjectDetails.setImage(withURL: URL(string: objProjDetails.projectImageMedium!)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .crossDissolve(0.4))
            labelHeader.text = objProjDetails.roomType
            if let _ = objProjDetails.roomDescription{
                txtViewDetails.text = objProjDetails.roomDescription
            }else{
            txtViewDetails.text = PROJECT_IMAGE_NOT_AVAILABLE
            }
         
            self.labelLikeCount.text = objProjDetails.likeCount
            if objProjDetails.porjectImageLikeStaus == true{
                buttonLike.setImage(UIImage(named: kFevImageSeleted), for: UIControlState())
            }
            else{
                buttonLike.setImage(UIImage(named: kFevImageDeSeleted), for: UIControlState())
                }
         
            
        }
    
    }
  
    
    @IBAction func actionLike(_ sender: UIButton) {
        if actionLikeHandler != nil{
            if let _ = objProjDetails.projectImageID{
            actionLikeHandler!(objProjDetails.projectImageID! , objProjDetails.porjectImageLikeStaus!)
            }
        }
    
    }
   
    
}
