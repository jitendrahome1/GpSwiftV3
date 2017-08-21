//
//  LicenseCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 15/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class LicenseCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var buttonTap: UIButton!
    @IBOutlet weak var licenseCollectionView: UICollectionView!
    
    override var datasource: AnyObject? {
        didSet {
            
        }
    }
}





