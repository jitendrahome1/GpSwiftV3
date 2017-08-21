//
//  EductionCellCustom.swift
//  Greenply
//
//  Created by Jitendra on 4/4/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class EductionCellCustom: BaseTableViewCell {

    @IBOutlet weak var constHightDes: NSLayoutConstraint!
   
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var lblDesc: UILabel!

    @IBOutlet weak var lblFromDate: UILabel!

    @IBOutlet weak var lblToDate: UILabel!

    override var datasource: AnyObject? {
        didSet {
       
            if datasource?.count > 0 && datasource!["KeyVale"] as! String == KEY_EXPRIENCE{
                constHightDes.constant = 0.0
                lblTitle.text =  "Organisation Name:- \(datasource!["organisation_name"] as! String)"
    
                lblDesc.text = datasource!["Description"] as? String
                
                lblFromDate.text =  "From Date:- \(Date.convertTimeStampToDate((datasource!["start_date"] as? Double)!))"
                lblToDate.text =   "To Date:-\(Date.convertTimeStampToDate((datasource!["end_date"] as? Double)!))"
                
                
            }
            else if datasource?.count > 0 && datasource!["KeyVale"] as! String == KEY_TRANING{
                constHightDes.constant = 0.0
                lblTitle.text =  "Training Name:- \(datasource!["training_name"] as! String)"
                lblDesc .text = datasource!["Description"] as? String
                lblFromDate.text =  "From Date:- \(Date.convertTimeStampToDate((datasource!["start_date"] as? Double)!))"
                lblToDate.text =   "To Date:-\(Date.convertTimeStampToDate((datasource!["end_date"] as? Double)!))"
                
            }
            else if datasource?.count > 0 && datasource!["KeyVale"] as! String == KEY_EDUCATION{
                constHightDes.constant = 34
        
                lblTitle.text =  "Degree:- \(datasource!["degree"] as! String)"
                lblDesc.text = "Stream:- \(datasource!["stream"] as! String)"
                lblFromDate.text =  "From Date:- \(Date.convertTimeStampToDate((datasource!["start_date"] as? Double)!))"
                lblToDate.text =   "To Date:-\(Date.convertTimeStampToDate((datasource!["end_date"] as? Double)!))"
            }
        
        }
    }
}
