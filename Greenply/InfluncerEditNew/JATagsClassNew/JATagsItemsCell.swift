//
//  JATagsItemsCell.swift
//  Greenply
//
//  Created by Jitendra on 4/14/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class JATagsItemsCell: BaseCollectionViewCell {

    
    @IBOutlet weak var viewBGTags: UIView!
    
    @IBOutlet weak var imgBGTags: UIImageView!
    
    
    @IBOutlet weak var lblTags: UILabel!
 
    @IBOutlet weak var btnTags: UIButton!
    
    override var datasource: AnyObject? {
        didSet {
            if self.datasource != nil{
                   //self.hidden  = false
                if (datasource!["skill_name"] as? String) != ""{
                    self.lblTags.text = datasource!["skill_name"] as? String
                }else{
                    
                 
                   // self.hidden  = true
                }
            
               
                
              //  self.btnTags.setTitle(datasource!["skill_name"] as? String, forState: .Normal)
                
                
                
            }
        }
    }
    
    override func awakeFromNib() {
      
        self.viewBGTags.layer.borderWidth = 1.0
        self.viewBGTags.layer.borderColor = UIColor.green.cgColor
            self.viewBGTags.layer.cornerRadius = 8.0
    }

}
