//
//  InfluencerTypeCell.swift
//  Greenply
//
//  Created by Jitendra on 3/29/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class InfluencerAboutMeCell: BaseTableViewCell {
    var editProf: Bool?
    @IBOutlet weak var lblType: UILabel!
   
    @IBOutlet weak var lblHeaderTitle: UILabel!
    var dataSource: [AnyObject]? {
        didSet {
            debugPrint(self.dataSource)
           
        }
    }
}
