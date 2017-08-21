//
//  JobCostTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 16/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class JobCostTableViewCell: BaseTableViewCell {

    @IBOutlet weak var buttonCost: UIButton!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                let objJobCost = datasource as! UserFilterAttribute
                buttonCost.setTitle((objJobCost.name), for: UIControlState())
                buttonCost.addTarget(self, action: #selector(JobCostTableViewCell.buttonCheck(_:)), for: UIControlEvents.touchUpInside)
            }
            
        }
    }
}


extension JobCostTableViewCell {
    
    func buttonCheck(_ sender: UIButton!) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
}


