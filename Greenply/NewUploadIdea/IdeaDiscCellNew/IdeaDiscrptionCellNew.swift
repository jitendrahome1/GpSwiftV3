//
//  IdeaDiscrptionCellNew.swift
//  Greenply
//
//  Created by Jitendra on 23/04/17.
//  Copyright © 2017 Indus Net. All rights reserved.
//

import UIKit

class IdeaDiscrptionCellNew: BaseTableViewCell {

    @IBOutlet weak var viewBGTextField: UIView!
   
    @IBOutlet weak var lblPlaceholder: UILabel!

    @IBOutlet weak var textIdeaName: UITextField!


    @IBOutlet weak var viewBGTextArea: UIView!

    @IBOutlet weak var textAreaDesc: UITextView!


    override var datasource: AnyObject? {
        didSet {
            if self.datasource != nil{
           
        
        self.textIdeaName.text = datasource!["ideaName"] as? String
         self.textAreaDesc.text = datasource!["ideaDescription"] as! String
            }
        }
    }
    
    
    override func awakeFromNib() {
        
        self.viewBGTextArea.layer.cornerRadius = 8.0
        self.viewBGTextArea.layer.borderWidth = 1.0
        self.viewBGTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.viewBGTextField.layer.cornerRadius = 8.0
        self.viewBGTextField.layer.borderWidth = 1.0
        self.viewBGTextArea.layer.borderColor = UIColor.lightGray.cgColor
    }

}
