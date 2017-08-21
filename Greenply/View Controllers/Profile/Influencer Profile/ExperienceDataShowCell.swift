//
//  ExperienceDataShowCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 15/11/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ExperienceDataShowCell: BaseTableViewCell {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var lblToDate: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    
    override var datasource: AnyObject?{
        didSet {
            
        }
    }

}
