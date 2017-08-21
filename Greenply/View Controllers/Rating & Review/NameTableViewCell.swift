//
//  NameTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 01/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class NameTableViewCell: BaseTableViewCell {

	@IBOutlet weak var imageProfile: UIImageView!
	@IBOutlet weak var labelName: UILabel!
	@IBOutlet weak var labelAddress: UILabel!
	@IBOutlet weak var labelInfluencerType: UILabel!

	override var datasource: AnyObject? {
		didSet {

		}
	}
}
