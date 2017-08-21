//
//  ContactAdminViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/31/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class ContactAdminViewController: BaseTableViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

extension ContactAdminViewController
{
	// MARK: UITableViewDelegate methods
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		switch indexPath.row {
		case 1:
			return (SCREEN_HEIGHT - (50 + 2)) / 2
		default:
			return super.tableView(tableView, heightForRowAt: indexPath)
		}
	}
}

