//
//  FollowersCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 08/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class FollowersCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var imageCollectionView: UIImageView!
    @IBOutlet weak var viewCoverTotalImage: UIView!
    
    @IBOutlet weak var labelTotalRestImage: UILabel!
    override var datasource: AnyObject? {
        didSet {
            
            if let ImageProfile  = ((datasource!["idea_image"] as? [String: AnyObject])?["thumb"] as? String)
            {
                if ImageProfile != ""{
                self.imageCollectionView.setImage(withURL: URL(string: ImageProfile)!, placeHolderImageNamed: "PlaceholderRectangle", andImageTransition: .crossDissolve(0.4))
                }
                
                
                
            }
            
            
           
        }
    }
}
