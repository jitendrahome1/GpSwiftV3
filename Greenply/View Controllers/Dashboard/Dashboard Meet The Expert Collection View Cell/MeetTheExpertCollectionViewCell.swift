//
//  CustomMeetTheExpertCollectionViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MeetTheExpertCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet weak var imageMeetTheExpert: UIImageView!
    @IBOutlet weak var labelMeettheExpert: UILabel!

	override var datasource: AnyObject? {
		didSet {
            labelMeettheExpert.text = datasource!["name"] as? String
            imageMeetTheExpert.image = UIImage(named: (datasource!["image"] as? String)!)
		}
	}
}

