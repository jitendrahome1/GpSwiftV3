//
//  MoreDetailsCell.swift
//  Greenply
//
//  Created by Jitendra on 10/26/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
enum eDataType {
    case eEducation
    case eExperience
}
class MoreDetailsCell: BaseTableViewCell {

    var eItemsStaus:eDataType = .eExperience
  
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var labelFromDate: UILabel!
    @IBOutlet weak var lableTitle: UILabel!

    @IBOutlet weak var nsConstDesHight: NSLayoutConstraint!
    @IBOutlet weak var labelToDate: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override var datasource: AnyObject? {
        didSet {
            if eItemsStaus == .eExperience{
               // self.labelDescription.hidden = true
                 self.nsConstDesHight.constant = 0.0
                self.labelDescription.layoutIfNeeded()
                let objItems = datasource as! Experience
                self.lableTitle.text = "Organisation: \(objItems.organisation_name!)"
                if let _ = objItems.startDate{
                self.labelToDate.text = "From date: \(Date.dateFromTimeInterval(objItems.startDate!).getFormattedStringWithFormat()!)"
                }else{
                      self.labelToDate.text = "From date: N/A"
                }
                if let _ = objItems.endDate{
                    print("date\(objItems.endDate!)")
                    self.labelFromDate.text = "To date: \(Date.dateFromTimeInterval(objItems.endDate!).getFormattedStringWithFormat()!)"
                }else{
                    self.labelFromDate.text = "To date: N/A"
                }
                
            }
            else{
                //self.labelDescription.hidden = false
                self.nsConstDesHight.constant = 30
                self.labelDescription.layoutIfNeeded()
                let objItems = datasource as! Education
                self.lableTitle.text = "Degree: \(objItems.degreeName!)"
                self.labelDescription.text = "Stream: \(objItems.stream!)"
                if let _ = objItems.startDate{
                      self.labelToDate.text = "From date: \(Date.dateFromTimeInterval(objItems.startDate!).getFormattedStringWithFormat()!)"
                }else{
                 self.labelToDate.text = "From date: N/A"
                }
             
                
                if let _ = objItems.endDate{
                    print("date\(objItems.endDate!)")
                    self.labelFromDate.text = "To date: \(Date.dateFromTimeInterval(objItems.endDate!).getFormattedStringWithFormat()!)"
                }else{
                     self.labelFromDate.text = "To date: N/A"
                }
            }
        }
    }
}
