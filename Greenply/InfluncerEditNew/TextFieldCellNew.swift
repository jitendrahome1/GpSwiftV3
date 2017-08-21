//
//  FieldCellNew.swift
//  Greenply
//
//  Created by Jitendra on 4/4/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class TextFieldCellNew: BaseTableViewCell {

    @IBOutlet weak var txtTitle: JATextField!
    let pHolderName = "Name"
    let pHolderNumber = "Mobile Number"
    @IBOutlet weak var btnTextItems: UIButton!
    
    override var datasource: AnyObject? {
        didSet {
            if self.datasource != nil{
             
                
                self.txtTitle.text = datasource!["titleValue"] as? String
                self.txtTitle.image = UIImage(named: datasource!["imageValue"] as! String)
                
                self.txtTitle.placeholder = datasource!["placeHolderValue"] as? String
                if datasource!["placeHolderValue"] as! String == pHolderName || datasource!["placeHolderValue"] as! String  == pHolderNumber {
                self.btnTextItems.isHidden = true
                    if datasource!["placeHolderValue"] as! String  == pHolderNumber{
                        self.txtTitle.keyboardType = .numberPad
                    }
                
                }else{
                    self.btnTextItems.isHidden = false
                }
               
            }
            
        }
    
    }
   
}
