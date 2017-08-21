//
//  CollectionCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 16/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class CollectionCell: BaseCollectionViewCell {

    @IBOutlet weak var imageLicense: UIImageView!
    var editProf: Bool!
    
    override var datasource: AnyObject? {
        didSet {
            debugPrint(datasource)
            if editProf == false {
                imageLicense.setImage(withURL: URL(string: datasource as! String)!, placeHolderImageNamed: "AddPictureIcon", andImageTransition: .crossDissolve(0.4))
            } else {
                if  String(describing: datasource!) == "AddPictureIcon" {
                    imageLicense.contentMode = .center
                    imageLicense.image = UIImage(named: "AddPictureIcon")
                } else {
                    imageLicense.contentMode = .scaleAspectFill
                    imageLicense.image = datasource as? UIImage//UIImage(data: (datasource as? NSData)!)
                }
            }
            
        }
    }
}
