//
//  FilterTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 24/11/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class FilterTableViewCell: BaseTableViewCell {

    @IBOutlet weak var labeldata: UILabel!
    @IBOutlet weak var imageCheck: UIImageView!
    override var datasource: AnyObject! {
        didSet {
            if datasource != nil {
//                let objFilterData = datasource as! UserFilterAttribute
//                labeldata.text = objFilterData.name
//                if objFilterData.status == false {
//                    imageCheck.image = UIImage(named: "FilterCheckboxDeselect")
//                } else {
//                    imageCheck.image = UIImage(named: "FilterCheckboxSelect")
//                }
                
                  labeldata.text = datasource!["name"]! as? String
                if (datasource!["status"]! as! Bool) == false {
                    imageCheck.image = UIImage(named: "FilterCheckboxDeselect")
                } else {
                    imageCheck.image = UIImage(named: "FilterCheckboxSelect")
                }
            }
        }
    }
}
