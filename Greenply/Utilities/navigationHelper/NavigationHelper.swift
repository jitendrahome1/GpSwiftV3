//
//  MenuViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/9/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class NavigationHelper: NSObject {

	static let helper = NavigationHelper()
	var currentViewController: UIViewController? {
		return contentNavController?.viewControllers.last!
	}
	var navController: UINavigationController!
	var headerViewController: HeaderViewController?
	var tabBarViewController: TabBarViewController?
	var contentNavController: ContentNavigationViewController?
	var mainContainerViewController: MainContainerViewController?
	var menuView = UIView()
	var menuWidth: CGFloat?
	var blurLayer: UIView?
	var isOpen = false

    var enableSideMenuSwipe = true{
        didSet{
        print("Bool Value:- \(enableSideMenuSwipe)")
        }
    }// Make it false in view will appear to disable swipr to open menu feature

	var didOpen: ((_ open: Bool) -> ())?
    var reloadData: (() -> ())?

	fileprivate override init() {
	}

	internal func navigateToViewController(_ isSpeciality: Bool, index: Int) {
		navController.popViewController(animated: true)
	}
}

extension NavigationHelper {

	func setUpSideMenu(_ view: UIView, blurView: UIView, menuWidth: CGFloat) {
        menuView = view
        blurLayer = blurView
        self.menuWidth = menuWidth
        view.translatesAutoresizingMaskIntoConstraints = true
        view.frame = CGRect(x: navController.view.bounds.width, y: 64, width: self.menuView.bounds.width, height: navController.view.bounds.height - 64)
        navController.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(NavigationHelper.panDidMoved(_:))))
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NavigationHelper.didTap(_:))))
	}

    func reloadMenu() {
        if (reloadData != nil) {
            reloadData!()
        }
    }
    
	func openSidePanel(_ open: Bool) {
        NavigationHelper.helper.mainContainerViewController?.view.bringSubview(toFront: blurLayer!)
        NavigationHelper.helper.mainContainerViewController?.view.bringSubview(toFront: menuView)
		if open {
            
			UIView.animate(withDuration: 0.3, animations: {
				self.blurLayer?.alpha = 0.5
				self.menuView.frame = CGRect(x: self.navController.view.bounds.width - self.menuWidth!, y: 64, width: self.menuView.bounds.width, height: self.menuView.bounds.height)
				}, completion: { (completed) in
				if self.didOpen != nil && !self.isOpen {
					self.didOpen!(true)
				}
				self.isOpen = true
			})
		} else {

			UIView.animate(withDuration: 0.3, animations: {
				self.blurLayer?.alpha = 0
				self.menuView.frame = CGRect(x: self.navController.view.bounds.width, y: 64, width: self.menuView.bounds.width, height: self.menuView.bounds.height)
				}, completion: { (completed) in
				if self.didOpen != nil && self.isOpen {
					self.didOpen!(false)
				}
				self.isOpen = false
			})
		}
	}

	func panDidMoved(_ gesture: UIPanGestureRecognizer) {

		if enableSideMenuSwipe {
			let translationInView = gesture.translation(in: navController.view)

			switch gesture.state {
			case .began:
                NavigationHelper.helper.mainContainerViewController?.view.bringSubview(toFront: blurLayer!)
                NavigationHelper.helper.mainContainerViewController?.view.bringSubview(toFront: menuView)
			case .changed:

				let movingx = menuView.center.x + translationInView.x;

				if ((navController.view.frame.width - movingx) > -self.menuWidth! / 2 && (navController.view.frame.width - movingx) < self.menuWidth! / 2) {

					menuView.center = CGPoint(x: movingx, y: menuView.center.y);
					gesture.setTranslation(CGPoint(x: 0, y: 0), in: navController.view)
					let changingAlpha = 0.5 / menuWidth! * (navController.view.frame.width - movingx) + 0.5 / 2; // y=mx+c
					blurLayer?.alpha = changingAlpha
				}
			case .ended:
				if (menuView.center.x > navController.view.frame.width) {
					openSidePanel(false)
				} else if (menuView.center.x < navController.view.frame.width) {
					openSidePanel(true)
				}
			default: break
			}
		}
	}

	func didTap(_ gesture: UITapGestureRecognizer) {
		openSidePanel(false)
	}
}
