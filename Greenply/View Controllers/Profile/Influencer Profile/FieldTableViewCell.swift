//
//  FieldTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 16/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class FieldTableViewCell: BaseTableViewCell {

    @IBOutlet weak var txtField: JATextField!
    var textValue: ((_ text: String,  _ index: IndexPath)->())?
    var index: IndexPath?
    var strTextValue: String?
    var editProf: Bool!
    
    override var datasource: AnyObject? {
        didSet {
            debugPrint(datasource)
            if editProf == true {
                txtField.placeholder = datasource!["placeholder"] as? String
                txtField.iconImageView.image = UIImage(named: (datasource!["image"] as? String)!)
                
            }
            
            txtField.text = strTextValue
        }
    }
}


extension FieldTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField){
        textValue!(txtField!.text!, index!)
    }
}



