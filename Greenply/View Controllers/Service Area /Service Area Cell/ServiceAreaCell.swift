//
//  ServiceAreaCell.swift
//  Greenply
//
//  Created by Jitendra on 12/1/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import AMTagListView
class ServiceAreaCell: UITableViewCell {
    
    @IBOutlet weak var buttonDeleteCell: UIButton!
    var didTapCellAction: ((_ sender: UIButton) -> ())?
      var didTapDeleteCell: ((_ sender: UIButton) -> ())?
    @IBOutlet weak var labelTitleName: UILabel!
    
    @IBOutlet weak var tagListView: AMTagListView!
    
    @IBOutlet weak var buttonDidTap: UIButton!
    
    @IBAction func ActionDidTap(_ sender: UIButton) {
        
        if (didTapCellAction != nil) {
            didTapCellAction!(sender)
            
        }
        
    }
    
    @IBAction func actionDeleteCell(_ sender: UIButton) {
     if (didTapDeleteCell != nil) {
        didTapDeleteCell!(sender)

        
        }
    }
    
}
