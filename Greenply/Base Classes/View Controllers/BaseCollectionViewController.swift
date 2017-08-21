//
//  BaseCollectionViewController.swift
//  Greenply
//
//  Created by Rupam Mitra on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BaseCollectionViewController: UICollectionViewController {
    
    var backButtonEnabled: Bool = false
    var searchButtonEnabled: Bool = false
    var notificationButtonEnabled: Bool = false
    var filterButtonEnabled: Bool = false
    var menuButtonEnabled: Bool = false
    var crossButtonEnabled: Bool = false
    var barButtonArray = [UIBarButtonItem]()
    var filterButton = UIBarButtonItem()
    
	override func viewDidLoad() {
		super.viewDidLoad()
        self.setNavigationBackButton()
        self.setBarButtonItems()
		//self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
        NavigationHelper.helper.enableSideMenuSwipe = true
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()

	}
    func setNavigationBackButton() {
        
        if backButtonEnabled == true {
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "HeaderBack")!, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.actionBack))
        }
        else {
            self.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    func setBarButtonItems() {
        
        if menuButtonEnabled == true {
            let menuButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "MenuIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.actionMenu))
            barButtonArray.append(menuButton)
        }
        if notificationButtonEnabled == true {
            let notificationButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Notification"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.actionNotification))
            barButtonArray.append(notificationButton)
        }
        if filterButtonEnabled == true {
            let filterButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "FilterIcon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.actionFilter))
            barButtonArray.append(filterButton)
        }
        
        if searchButtonEnabled == true {
            let searchButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "HeaderSearch"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.actionSearch))
            barButtonArray.append(searchButton)
        }
        if crossButtonEnabled == true {
            let searchButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "HeaderSearch"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.crossButton))
            barButtonArray.append(searchButton)
        }
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = barButtonArray
    }
    // MARK:- Crete NavigationTitle
    func setNavigationTitle(_ title: String)
    {
        let labelFrame = CGRect(x: IS_IPAD() ? -250 : -20, y: 75, width: 190, height: 23)
        let labelTitle = UILabel(frame: labelFrame)
        labelTitle.text = title
        labelTitle.textColor = UIColor.white
        labelTitle.textAlignment = NSTextAlignment.left
        labelTitle.font = UIFont(name: "HelveticaNeue-Bold", size: IS_IPAD() ? 40 : 16)
        let rectForView = CGRect(x: 0, y: 0, width: 190, height: 176)
        let viewForTitle = UIView(frame: rectForView)
        viewForTitle.addSubview(labelTitle)
        self.navigationItem.titleView = viewForTitle
        
    }
    // MARK: - Nav Bar Button Action
    func actionBack() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        // self.navigationController?.popViewControllerAnimated(true)
    }
    func actionSearch() {
        debugPrint("Search")
    }
    func actionFilter() {
        debugPrint("Filter")
    }
    func actionMenu() {
        debugPrint("menu")
        NavigationHelper.helper.openSidePanel(true)
//        self.slideMenuController()?.openRight()
    }
    func actionNotification() {
        debugPrint("Notification")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    func crossButton() {
        debugPrint("corssActon")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

// No result
extension BaseCollectionViewController
{
    func noResult(forArrData arrItems: [AnyObject], lableText: String!){
        let noRecordLbl = UILabel(frame: CGRect.zero)
        if arrItems.count > 0 {
            self.collectionView!.isScrollEnabled = true
            noRecordLbl.translatesAutoresizingMaskIntoConstraints = true
            noRecordLbl.backgroundColor =  UIColor.red
            for lbl in self.collectionView!.subviews {
                
                if lbl.isKind(of: UILabel.self){
                    lbl.removeFromSuperview()
                }
                
                
            }
        }
        else{
            
            self.collectionView!.isScrollEnabled = false
            noRecordLbl.translatesAutoresizingMaskIntoConstraints = true
            // noRecordLbl.autoresizingMask = ([.flexibleHeight, .flexibleWidth, .flexibleBottomMargin, .flexibleRightMargin])
            //  noRecordLbl.font = FONT_REGULAR(IS_IPAD ? 25 : 18)
            noRecordLbl.textColor = UIColor.black
            noRecordLbl.backgroundColor =  UIColor.clear
            noRecordLbl.text = lableText!
            let rect = self.collectionView!.frame
            noRecordLbl.textAlignment = .center
            noRecordLbl.frame = rect
            self.collectionView!.addSubview(noRecordLbl)
            
        }
    }
}
