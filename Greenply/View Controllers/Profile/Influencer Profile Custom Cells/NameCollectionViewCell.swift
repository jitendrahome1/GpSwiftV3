//
//  NameCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 15/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class NameCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var txtInputField: JATextField!
    
    override var datasource: AnyObject? {
        didSet {
            
        }
    }
}
