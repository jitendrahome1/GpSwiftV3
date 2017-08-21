//
//  FilterCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 24/11/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelText: UILabel!
    override var datasource: AnyObject? {
        didSet {
            let objHeader = datasource as! HeaderFilterAttribute
            labelText.text = objHeader.attribute_name
        }
    }
}
