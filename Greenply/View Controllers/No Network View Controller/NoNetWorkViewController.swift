//
//  NoNetWorkViewController.swift
//  Greenply
//
//  Created by Jitendra on 11/29/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class NoNetWorkViewController: BaseViewController {


    @IBOutlet weak var viewBG: UIView!
	@IBOutlet weak var buttonRetry: UIButton!
    var didTapRetry: ((_ sender: UIButton) -> ())?
	override func viewDidLoad() {
		super.viewDidLoad()
        
        
	}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        	NavigationHelper.helper.tabBarViewController!.hideTabBar()
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: true, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true)
              NavigationHelper.helper.headerViewController?.labelHeaderTitle.text = "No Network"
    }
	@IBAction func actionRetry(_ sender: UIButton) {
        
      	if (didTapRetry != nil) {
        didTapRetry!(sender)
        }
	}


}
