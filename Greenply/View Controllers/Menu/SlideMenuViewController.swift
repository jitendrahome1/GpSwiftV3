//
//  SlideMenuViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/8/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
class SlideMenuViewController: SlideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.changeLeftViewWidth(IS_IPAD() ? 0.65*(CGRectGetWidth(self.view.frame)) : 0.8*(CGRectGetWidth(self.view.frame)))
        
          self.changeRightViewWidth(IS_IPAD() ? 0.65*((self.view.frame).width) : 0.8*((self.view.frame).width))
    }
}



