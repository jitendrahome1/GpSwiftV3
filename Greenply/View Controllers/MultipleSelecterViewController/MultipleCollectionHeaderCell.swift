//
//  MultipleCollectionHeaderCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 02/11/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MultipleCollectionHeaderCell: BaseCollectionViewCell {

    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var imageBorder: UIImageView!
    override var datasource: AnyObject? {
        didSet {
            
            let objHeader = datasource as! HeaderFilterAttribute
            labelHeader.text = objHeader.attribute_name
            //labelHeader.textColor = .whiteColor()
        }
        
    }

}
