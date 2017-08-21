//
//  MenuViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/9/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController {

    @IBOutlet weak var nsBtottomConstTabBar: NSLayoutConstraint!
    @IBOutlet weak var tabBarControllerView: UIView!
    @IBOutlet var NSConstantTapBarHeight: NSLayoutConstraint!
	@IBOutlet weak var mainContainer: UIView!
	@IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var menuViewWidthConstrain: NSLayoutConstraint!
	override func viewDidLoad() {
		super.viewDidLoad()
		NavigationHelper.helper.mainContainerViewController = self
        
        menuContainer.translatesAutoresizingMaskIntoConstraints = true
        menuContainer.frame = CGRect(x: self.view.bounds.width * 0.3, y: 64, width: self.view.bounds.width * 0.7, height: self.view.bounds.height - 64)
        NavigationHelper.helper.setUpSideMenu(menuContainer, blurView: blurView, menuWidth: self.view.bounds.width * 0.7)

        
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

//		if (sender as AnyObject).identifier == "ContentHeaderBarEmbedSegue"
//		{
//			NavigationHelper.helper.headerViewController = ((sender as AnyObject).destination as? HeaderViewController)!
//
//		}
//
//		else if (segue.identifier == "MainNavigationController")
//		{
//
//		}
//		else if (segue.identifier == "ContentTabrBarEmbedSegue")
//		{
//
//		}

	}
	// MARK:- Show And Hide Tab Bar.
	func showHideTabBar(_ isTabBarHide: Bool)
	{
        if isTabBarHide == true
        {
            NavigationHelper.helper.mainContainerViewController!.tabBarView.isHidden = true
            var hight = CGFloat()
            hight = NavigationHelper.helper.mainContainerViewController!.mainContainer.frame.height + NavigationHelper.helper.mainContainerViewController!.tabBarView.frame.height
            NavigationHelper.helper.mainContainerViewController!.mainContainer.frame.size.height = hight
            
        }
        else
        {
            NavigationHelper.helper.mainContainerViewController!.tabBarView.isHidden = false
        }

	}
    

}

  


