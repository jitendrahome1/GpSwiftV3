//
//  MultipleSelectionTableCell.swift
//  Greenply
//
//  Created by Jitendra on 9/15/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MultipleSelectionTableCell: BaseTableViewCell {

    @IBOutlet weak var labelTitleName: UILabel!
    @IBOutlet weak var buttonCheckBox: UIButton!
    var item: Int!
    var check: Bool!
    
    override var datasource: AnyObject? {
        didSet {
            
//            let objFilter = datasource as! UserFilterAttribute
//            
//            var dictVale = objFilter.dictAttibute 
//          
//            self.labelTitleName.text = dictVale["name"] as? String
//            
//           let btnStatus = dictVale["buttonStatus"]  as? Bool
//         
//            if btnStatus == true{
//                buttonCheckBox.selected  = true
//            }else{
//             buttonCheckBox.selected  = false
//            }

            
            if buttonCheckBox.isSelected == true{
                buttonCheckBox.isSelected  = false
            }else{
                buttonCheckBox.isSelected = true
            }
        }
    }

}
