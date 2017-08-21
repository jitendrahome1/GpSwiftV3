//
//  TotalExperienceCustomCell.swift
//  Greenply
//
//  Created by Jitendra on 4/6/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class TotalExperienceCustomCell: BaseTableViewCell {

    @IBOutlet weak var viewBGMonth: UIView!
    @IBOutlet weak var viewBGYear: UIView!
    @IBOutlet weak var btnYear: UIButton!
    @IBOutlet weak var btnMonth: UIButton!
    
    override var datasource: AnyObject? {
        didSet {
            if self.datasource != nil{
                
            self.btnYear.setTitle(datasource!["yearExp"] as? String, for: UIControlState())
            self.btnMonth.setTitle(datasource!["monthExp"] as? String, for: UIControlState())
            
            }
        }
    }
    
    override func awakeFromNib() {
   
       
        
        self.btnYear.layer.borderWidth = 1
        self.btnMonth.layer.borderWidth = 1
        self.btnYear.layer.borderColor = UIColor.lightGray.cgColor
        self.btnMonth.layer.borderColor = UIColor.lightGray.cgColor
    }
}
