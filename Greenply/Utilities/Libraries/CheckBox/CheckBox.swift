//
//  CheckBox.swift
//  checkbox

//
//  Created by Jitendra on 9/14/16.
//  Copyright © 2016 Jitendra. All rights reserved.

import UIKit

class CheckBox: UIButton {
    
    //images
    let checkedImage = UIImage(named: "CheckBoxSelected")
    let unCheckedImage = UIImage(named: "CheckBoxDelSected")
    
    //bool propety
    @IBInspectable var isChecked:Bool = false{
        didSet{
            self.updateImage()
        }
    }

    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        self.updateImage()
    }
    
    
    func updateImage() {
        if isChecked == true{
            self.setImage(checkedImage, for: UIControlState())
        
        }else{
            self.setImage(unCheckedImage, for: UIControlState())
        }


    }

    func buttonClicked(_ sender:UIButton) {
        if(sender == self){
            isChecked = !isChecked
        }
        
    }

}
