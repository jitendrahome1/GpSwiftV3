//
//  TagsCustomCell.swift
//  Greenply
//
//  Created by Jitendra on 4/5/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class TagsCustomCell: BaseTableViewCell {

@IBOutlet weak var aTagView: KSTokenView!

    override var datasource: AnyObject? {
        didSet {
            if self.datasource != nil{
            
              aTagView.addToken(KSToken.init(title: datasource!["skill_name"] as! String))
            
            }
        }
    }
  
    
}
