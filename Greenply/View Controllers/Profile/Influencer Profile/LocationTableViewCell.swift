//
//  LocationTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 16/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class LocationTableViewCell: BaseTableViewCell {

    @IBOutlet weak var txtLocation: UITextField!
    
    override var datasource: AnyObject? {
        didSet {
            txtLocation.layer.cornerRadius = IS_IPAD() ? 8.0 : 5.0
            txtLocation.layer.borderWidth = IS_IPAD() ? 1.0 : 0.5
            txtLocation.layer.borderColor = UIColor.darkGray.cgColor
            txtLocation.layer.masksToBounds =  true
        }
    }
}






