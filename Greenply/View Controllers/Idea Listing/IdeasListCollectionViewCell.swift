//
//  ProjListCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 30/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class IdeasListCollectionViewCell: BaseCollectionViewCell {
   
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var imageProjList: UIImageView!
    @IBOutlet weak var imageBottomProjList: UIImageView!
    @IBOutlet weak var labelIdeasTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
    @IBOutlet weak var labelDrawing: UILabel!
    @IBOutlet weak var buttonLikes: UIButton!
    @IBOutlet weak var buttonViews: UIButton!
    @IBOutlet weak var buttonShare: UIButton!
    var ideaListObj: IdeaListing!
    var editButtonHandler:((_ ideaID: Int)->())?
    override var datasource: AnyObject? {
        didSet {
            
        ideaListObj = datasource as! IdeaListing
       labelIdeasTitle.text = ideaListObj.ideaName
        buttonLikes.setTitle("\(ideaListObj.likeCount! as Int)" , for: UIControlState())
        buttonViews.setTitle("\(ideaListObj.viewCount! as Int)", for: UIControlState())
        labelSubtitle.text = ideaListObj.styleValue
        labelDrawing.text = ideaListObj.roomValue
            
            let backgroundQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)
            backgroundQueue.async(execute: {
               self.imageProjList.image = UIImage(named: "PlaceholderSquare")
                
                DispatchQueue.main.async(execute: {
                    
                                       if self.ideaListObj.ideaImageThumb != ""{
                     self.imageProjList.setImage(withURL: URL(string: self.ideaListObj.ideaImageThumb!)!, placeHolderImageNamed: "PlaceholderSquare", andImageTransition: .crossDissolve(0.4))
                    }
                    else{
                        self.imageProjList.image = UIImage(named: "PlaceholderSquare")
                    }
                })
                
            })
            
            
   
           
            
        }
    }
    
    @IBAction func actionEdit(_ sender: UIButton) {
        if editButtonHandler != nil{
            editButtonHandler!(Int((ideaListObj.IdeaID!)))
        
        }
    
    }

}
