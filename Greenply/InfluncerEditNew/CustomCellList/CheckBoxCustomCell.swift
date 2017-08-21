//
//  CheckBoxCustomCell.swift
//  Greenply
//
//  Created by Jitendra on 4/5/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class CheckBoxCustomCell: BaseTableViewCell {

    @IBOutlet weak var btnTypicalTitle: UIButton!
    override var datasource: AnyObject? {
        didSet {
            if self.datasource != nil{
        
                if datasource!["keyValue"] as? String == KEY_ROOM_TYPE{
                    self.btnTypicalTitle.setTitle(datasource!["typicalValue"] as? String , for:UIControlState())
                    if datasource!["buttonStatus"] as! Bool == false{
                        self.btnTypicalTitle.setImage(UIImage(named: "MeetAnExparCheckBoxSelect"), for:UIControlState())
                    }
                    else if datasource!["buttonStatus"] as! Bool == true{
                        self.btnTypicalTitle.setImage(UIImage(named: "MeetAnExparCheckBoxDeselect"), for:UIControlState())
                    }
                }
                else if datasource!["keyValue"] as? String == KEY_STYLE_TYPE{
                    self.btnTypicalTitle.setTitle(datasource!["typicalValue"] as? String , for:UIControlState())
                    
                    if datasource!["buttonStatus"] as! Bool == false{
                        self.btnTypicalTitle.setImage(UIImage(named: "MeetAnExparCheckBoxSelect"), for:UIControlState())
                    }
                    else if datasource!["buttonStatus"] as! Bool == true{
                        self.btnTypicalTitle.setImage(UIImage(named: "MeetAnExparCheckBoxDeselect"), for:UIControlState())
   
                }
                
                }
                else{
                    
                    self.btnTypicalTitle.setTitle(datasource!["typicalValue"] as? String , for:UIControlState())
                    if datasource!["buttonStatus"] as! Bool == false{
                        self.btnTypicalTitle.setImage(UIImage(named: "MeetAnExparCheckBoxSelect"), for:UIControlState())
                    }
                    else if datasource!["buttonStatus"] as! Bool == true{
                        self.btnTypicalTitle.setImage(UIImage(named: "MeetAnExparCheckBoxDeselect"), for:UIControlState())
                        
            
             }
                        
            }
              
                
            }
        }
    
        

}
}
