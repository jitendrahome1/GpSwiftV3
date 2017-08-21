//
//  BaseViewController.swift
//  Greenply
//
//  Created by Rupam Mitra on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit
class BaseViewController: UIViewController {
    var backButtonEnabled: Bool = false

	override func viewDidLoad() {
		super.viewDidLoad()
	    self.setNavigationBackButton()
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "HeaderBack")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.actionBack))
        NavigationHelper.helper.enableSideMenuSwipe = true
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    func setNavigationBackButton() {
        
        if backButtonEnabled == true {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "HeaderBack")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.actionBack))
        }
        else {
            self.navigationItem.setHidesBackButton(true, animated: true)
            
        }
    }
    
    
    func setNavigationBarItem() {
    
    }
    
    // MARK:- Crete NavigationTitle
    func setNavigationTitle(_ title: String)
    {
        let labelFrame = CGRect(x: 0, y: IS_IPAD() ? 0 :  -3, width: 190, height: IS_IPAD() ? 30 : 23)
        let labelTitle = UILabel(frame: labelFrame)
        labelTitle.text = title
        labelTitle.textColor = UIColor.white
        labelTitle.textAlignment = NSTextAlignment.left
        labelTitle.font = PRIMARY_FONT(IS_IPAD() ? 22 : 16)
        //labelTitle.font = PRIMARY_FONT(IS_IPAD() ? 22 : 16)
        let rectForView = CGRect(x: 0, y: 40, width: SCREEN_WIDTH - 75, height: IS_IPAD() ? 30 : 23)
        
        let viewForTitle = UIView(frame: rectForView)
        
        viewForTitle.addSubview(labelTitle)
        
        self.navigationItem.titleView = viewForTitle
    }
    
    
    func actionBack() {
            self.navigationController?.popViewController(animated: true)
        }
}


extension BaseViewController
{
    func noResult(forArrData arrItems: [AnyObject], lableText: String!){
        let noRecordLbl = UILabel(frame: CGRect.zero)
        if arrItems.count > 0 {
           
            noRecordLbl.translatesAutoresizingMaskIntoConstraints = true
            noRecordLbl.backgroundColor =  UIColor.red
            for lbl in self.view.subviews {
                
                if lbl.isKind(of: UILabel.self){
                    lbl.removeFromSuperview()
                }
            }
        }
        else{
            
            noRecordLbl.translatesAutoresizingMaskIntoConstraints = true
            noRecordLbl.textColor = UIColor.black
            noRecordLbl.backgroundColor =  UIColor.clear
            noRecordLbl.text = lableText!
            let rect = self.view.frame
            noRecordLbl.textAlignment = .center
            noRecordLbl.frame = rect
            self.view.addSubview(noRecordLbl)
        }
    }
}


