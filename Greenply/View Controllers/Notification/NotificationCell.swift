//
//  NotificationCell.swift
//  Greenply
//
//  Created by Jitendra on 8/30/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class NotificationCell: BaseTableViewCell {

    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var viewBG: UIView!
	@IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    override var datasource: AnyObject? {
        didSet {
            
            let objNotification = datasource as! Notification
            labelDescription.text = objNotification.desc
            labelDate.text = Date.dateFromTimeInterval(Double(objNotification.date!)).getFormattedStringWithFormat()
            labelTitle.text = objNotification.notification_title
            labelDescription.text?.labelJustified(labelDescription)
            
        }
    }
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
      //  labelDescription.layoutIfNeeded()
      
    }

    
}
