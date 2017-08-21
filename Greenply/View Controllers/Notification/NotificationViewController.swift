//
//  NotificationViewController.swift
//  Greenply
//
//  Created by Jitendra on 8/30/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class NotificationViewController: BaseTableViewController {

	@IBOutlet weak var tblNotification: UITableView!
	var arrNotificationList = [AnyObject]()
	var objIdea = IdeaListing()
	override func viewDidLoad() {
		super.viewDidLoad()
		self.initialUISetup()
		// Do any additional setup after loading the view.

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		NavigationHelper.helper.headerViewController!.setHeaderBarButtonsWith(isHideBackButton: false, isHideFilterButton: true, isHidenotification: true, isHideMenuButton: false)
		NavigationHelper.helper.tabBarViewController!.hideTabBar()
		NavigationHelper.helper.headerViewController!.labelHeaderTitle.text = TITLE_NOTIFICATION
	}

	override func viewDidAppear(_ animated: Bool) {

		super.viewDidAppear(animated)
		self.tableView.reloadData()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		self.tableView.layoutIfNeeded()

	}

	// MARK:- initial setup
	func initialUISetup()
	{

		self.backgroundImageView.image = UIImage(named: "BackgroundImage.png")
		self.tableView.estimatedRowHeight = 122
		self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
		self.tableView.rowHeight = UITableViewAutomaticDimension;
		APIHandler.handler.getNotifications({ (response) in

			self.arrNotificationList.removeAll()
			if (response?["notifications"].count)! > 0 {
				for value in (response?["notifications"].arrayObject!)! {
					let objNotification = Notification(withDictionary: value as! [String: AnyObject])
					self.arrNotificationList.append(objNotification)
				}
			} else {
				self.noResult(forArrData: self.arrNotificationList, lableText: NO_NOTIFY)
			}
			self.tableView.reloadData()

		}) { (error) in

		}

	}
}

extension NotificationViewController {

	// MARK: UITableViewDataSource methods
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.arrNotificationList.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell: NotificationCell = tableView.dequeueReusableCell(withIdentifier: String(describing: NotificationCell.self)) as! NotificationCell
		cell.datasource = self.arrNotificationList[indexPath.row]
		return cell
	}

	// MARK: UITableViewDelegate methods
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return UITableViewAutomaticDimension
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let objNotification = self.arrNotificationList[indexPath.row] as! Notification
		print("Event Name\(objNotification.eventType))")
		self.moveToViewController(forNotificationObject: objNotification)
	}

}
extension NotificationViewController {
	func moveToViewController(forNotificationObject notificationObject: Notification) {

		if notificationObject.eventType == "idea" // open a idea details viewController
		{
			let ideaDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: IdeasDetailsController.self)) as! IdeasDetailsController

			APIHandler.handler.getIdeaDetails(notificationObject.eventID!, success: { (response) in

				let obj = IdeaListing.init(forIdeaDetails: response!)

				print("Details\(obj.IdeaID)")
				ideaDetailsVC.ideaDetailsObj = obj
				NavigationHelper.helper.contentNavController!.pushViewController(ideaDetailsVC, animated: true)

				}, failure: { (error) in

			})

		} else if notificationObject.eventType == "portfolio" { // open a portfolio details view controller

			let portfolioDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: String(describing: ProjectDetailsController.self)) as! ProjectDetailsController

			APIHandler.handler.getPortFolioDetails(forPortFolioID: notificationObject.eventID!, success: { (response) in

				let objPortfolio = Portfolio.init(withDictionary: response!.dictionaryObject! as [String : AnyObject])
				portfolioDetailsVC.objPortfolioDetails = objPortfolio
				NavigationHelper.helper.contentNavController!.pushViewController(portfolioDetailsVC, animated: true)
				}, failure: { (error) in

			})

		}
	}
}
