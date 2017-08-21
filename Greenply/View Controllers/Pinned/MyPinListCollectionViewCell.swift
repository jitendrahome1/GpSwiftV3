//
//  MyPinListCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 21/11/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MyPinListCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var imageMyPinnedDetails: UIImageView!
    @IBOutlet weak var labelTag: UILabel!
    
    override var datasource: AnyObject? {
        didSet {
            let myPinListObj = datasource as! MyPinList
            if myPinListObj.pinThimbImage != "" {
            imageMyPinnedDetails.setImage(withURL: URL(string: myPinListObj.pinThimbImage!)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .crossDissolve(0.4))    
            }
            
            
            labelTag.text = myPinListObj.pinName!
        }
    }

}
