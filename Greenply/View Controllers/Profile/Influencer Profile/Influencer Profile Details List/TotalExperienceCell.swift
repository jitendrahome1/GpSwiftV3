//
//  TotalExperienceCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 07/12/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class TotalExperienceCell: BaseTableViewCell {

    @IBOutlet weak var textYear: UITextField!
    @IBOutlet weak var textMonth: UITextField!
    @IBOutlet weak var buttonYear: UIButton!
    @IBOutlet weak var buttonMonth: UIButton!
    override var datasource: AnyObject?{
        didSet{
            textYear.layer.borderWidth = 1.0
            textYear.layer.borderColor = UIColor.lightGray.cgColor
            textYear.layer.cornerRadius = 5.0
            textYear.layer.masksToBounds = true
            
            textMonth.layer.borderWidth = 1.0
            textMonth.layer.borderColor = UIColor.lightGray.cgColor
            textMonth.layer.cornerRadius = 5.0
            textMonth.layer.masksToBounds = true
        }
    }
}


extension TotalExperienceCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}


