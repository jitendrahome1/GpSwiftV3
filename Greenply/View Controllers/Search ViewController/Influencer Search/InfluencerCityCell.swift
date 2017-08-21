//
//  InfluencerCityCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 05/12/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class InfluencerCityCell: BaseTableViewCell {

    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var checkImg: UIImageView!
    var checkCity: Bool!
    override var datasource: AnyObject?{
        didSet{
            
        }
    }

}
