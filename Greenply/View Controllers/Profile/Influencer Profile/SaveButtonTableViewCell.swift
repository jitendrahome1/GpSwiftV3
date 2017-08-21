//
//  SaveButtonTableViewCell.swift
//  Greenply
//
//  Created by Shatadru Datta on 16/09/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class SaveButtonTableViewCell: BaseTableViewCell {

    @IBOutlet weak var buttonSave: UIButton!
    var didTapSave: ((_ sender: UIButton) -> ())?
    override var datasource: AnyObject? {
        didSet {
            buttonSave.layer.cornerRadius = IS_IPAD() ? 8.0 : 5.0
            buttonSave.layer.masksToBounds =  true
        }
    }
    
    @IBAction func buttonSaveDidTap(_ sender: UIButton) {
        self.contentView.endEditing(true)
        if (didTapSave != nil) {
            didTapSave!(sender)
        }
    }


}
