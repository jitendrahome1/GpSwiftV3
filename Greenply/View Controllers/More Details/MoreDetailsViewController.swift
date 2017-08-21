//
//  MoreDetailsViewController.swift
//  Greenply
//
//  Created by Jitendra on 10/26/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MoreDetailsViewController: BaseTableViewController {
    var arrDataItems = [AnyObject]()
    var strMoreType: String?
	override func viewDidLoad() {
		super.viewDidLoad()
        	self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
      
		self.backgroundImageView.image = UIImage(named: "BackgroundImage.png")
//         if self.strMoreType == "EDUCATION"{
//             NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = "Education List"
//         }
//         else{
//           NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = "Experience List"
//        }
          NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = "View All"
       
        NavigationHelper.helper.tabBarViewController!.hideTabBar()
        NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: true)
		// Do any additional setup after loading the view.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}


extension MoreDetailsViewController {

	// MARK: UITableViewDataSource methods
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.arrDataItems.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell: MoreDetailsCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoreDetailsCell.self)) as! MoreDetailsCell
        if self.strMoreType == "EDUCATION"{
        cell.eItemsStaus = .eEducation
        }
        else{
        cell.eItemsStaus = .eExperience
        }
        
		cell.datasource = self.arrDataItems[indexPath.row]
		return cell
	}

    // MARK: UITableViewDelegate methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
         if self.strMoreType == "EDUCATION"{
        return 139.0
         }else{
            return 110.0
        }
       
    }

}
