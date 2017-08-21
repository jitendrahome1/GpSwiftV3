//
//  MultiSelectionViewController.swift
//  Greenply
//
//  Created by Jitendra on 9/15/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class MultiSelectionViewController: BaseViewController {
	@IBOutlet weak var viewMainBG: UIView!

	@IBOutlet var selectionBarButtons: [UIButton]!
	@IBOutlet weak var viewContainerBG: UIView!
	var currenttemp = Int()
	@IBOutlet weak var collectionMultiple: UICollectionView!
	@IBOutlet weak var collectionHeader: UICollectionView!
	var arrDataList = [AnyObject]()
	var arrheaderList = [AnyObject]()
	var array = [AnyObject]()
	var visibleIndexPath: IndexPath!
	var pageIndex: NSInteger!
	var work_exp: String?
	var ratings: String?
	var typical_job_cost: String?
	var skills: String?
	var distance: String?
	var selectedIndex: Int = 0
	var isFirstTime: Bool = true
	override func viewDidLoad() {
		super.viewDidLoad()

		APIHandler.handler.userFilterAttribute({ (response) in
			debugPrint(response)

			for value in (response?["Attributes"].arrayValue)! {
				for data in value["attributeValues"].arrayObject! {
					let objFilterAttribute = UserFilterAttribute(withDictionary: data as! [String: AnyObject])
					self.array.append(objFilterAttribute)
				}
				self.arrDataList.append(self.array as AnyObject)
				self.array.removeAll()
			}

			if (response?["Attributes"].count)! > 0 {
				for value in response!["Attributes"].arrayObject! {
					let objHeaderFilterAttribute = HeaderFilterAttribute(withDictionary: value as! [String: AnyObject])
					self.arrheaderList.append(objHeaderFilterAttribute)
				}
			}
			self.collectionHeader.reloadData()
			self.collectionMultiple.reloadData()
		}) { (error) in
			debugPrint(error)
		}

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MultiSelectionViewController.tapDismissView))
		self.viewMainBG.addGestureRecognizer(tapGesture)
		// loadArray()
	}
	@IBAction func actionFilter(_ sender: UIButton) {
		self.userFilterAPI()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MArk:- Action
	@IBAction func didTapButtonAction(_ sender: UIButton) {
		self.unSelectButton(sender)
		self.resetIndexPath(selectionBarButtons.index(of: sender)!)
	}

	func unSelectButton(_ exceptionButton: UIButton)
	{
		for button in selectionBarButtons {
			if button != exceptionButton {
				button.isSelected = false
			}
			else {
				button.isSelected = true
			}
		}
	}

	func loadArray() {
		// arrDataList = [["Interior Decorators", "Architects", "Carpenters"],["0-2 yrs", "2-4 yrs", "5-7 yrs", "8-10 yrs"],["1 star", "2 star", "3 star", "4 star", "5 star"],["Kolkata", "Mumbai", "Delhi", "Chennai"]]
		// arrheaderList = ["Work Experience","Distance","Typical Job Cost","Ratings"]
	}

	// MARK: PopUp ViewController Function.
	internal class func showMultipleSelectionView(_ sourceViewController: UIViewController) {
		let viewController = otherStoryboard.instantiateViewController(withIdentifier: String(describing: MultiSelectionViewController.self)) as! MultiSelectionViewController
		viewController.presentAddOrClearPopUpWith(sourceViewController)
	}
	func presentAddOrClearPopUpWith(_ sourceController: UIViewController) {
		UIApplication.shared.keyWindow?.addSubview(self.view)
		sourceController.addChildViewController(self)
		presentAnimationToView()

	}

	// MARK: - Animation
	func presentAnimationToView() {
		self.viewContainerBG.transform = CGAffineTransform(translationX: 0, y: -SCREEN_HEIGHT)
		self.viewMainBG.alpha = 0
		UIView.animate(withDuration: 0.25, animations: {
			self.viewContainerBG.transform = CGAffineTransform(translationX: 0, y: 0)
			self.viewMainBG.alpha = 0.5
		}, completion: { (true) in
		}) 
	}
	func dismissAnimate() {
		UIView.animate(withDuration: 0.25, animations: {
			self.viewContainerBG.transform = CGAffineTransform(translationX: 0, y: -SCREEN_HEIGHT)
			self.viewMainBG.alpha = 0
		}, completion: { (true) in
			self.view.removeFromSuperview();
			self.removeFromParentViewController()
		}) 
	}
	func tapDismissView()
	{
		self.dismissAnimate()
	}

}
extension MultiSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == collectionMultiple {
			return arrDataList.count
		} else {
			return arrheaderList.count
		}
	}

	// make a cell for each cell index path
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		// get a reference to our storyboard cell
		if collectionView == collectionMultiple {

			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MultipleCollectionViewCell.self), for: indexPath) as! MultipleCollectionViewCell
			cell.backgroundColor = UIColor.clear

			cell.datasource = indexPath.item as AnyObject?
			cell.dataSource = arrDataList[indexPath.item] as? [AnyObject]

			cell.dataFilter = { item, index, valueCode in
				if item == 0 {
					self.work_exp = "UserSearch[work_experience][]=\(valueCode)"
				} else if item == 1 {
					self.distance = "UserSearch[distance][]=\(valueCode)"
				} else if item == 2 {
					self.typical_job_cost = "UserSearch[typical_job_cost][]=\(valueCode)"
				} else {
					self.ratings = "UserSearch[ratings][]=\(valueCode)"
				}
			}

			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MultipleCollectionHeaderCell.self), for: indexPath) as! MultipleCollectionHeaderCell

			if (indexPath.row == 0 && selectedIndex == 0) {
               
				cell.imageBorder.backgroundColor = UIColor.green

				cell.labelHeader.textColor = UIColor.green

			}

			cell.datasource = arrheaderList[indexPath.item]
			return cell
		}
	}

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

		if scrollView == collectionMultiple {

			currenttemp = Int(collectionMultiple.contentOffset.x / collectionMultiple.frame.width)
			print("Current Index\(currenttemp)")

			if currenttemp > 0 {
				self.moveHeaderIndexPath(currenttemp - 1)
			}

			let cellPrive = collectionHeader.cellForItem(at: IndexPath(row: self.selectedIndex, section: 0)) as?MultipleCollectionHeaderCell
			if let _ = cellPrive {
				cellPrive!.imageBorder.backgroundColor = UIColor.clear
				cellPrive!.labelHeader.textColor = UIColor.white
			}

			let cell = collectionHeader.cellForItem(at: IndexPath(row: currenttemp, section: 0)) as? MultipleCollectionHeaderCell
			if let _ = cell {
				cell!.imageBorder.backgroundColor = UIColor.green
				cell!.labelHeader.textColor = UIColor.green
			}
			selectedIndex = currenttemp
		}

	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		if collectionView == collectionMultiple {
			return CGSize(width: UIScreen.main.bounds.width - 16, height: collectionView.frame.height)
		} else {
			return CGSize(width: 100, height: 40.0)
		}
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == collectionHeader {

			let cellPrive = collectionView.cellForItem(at: IndexPath(row: self.selectedIndex, section: 0)) as?MultipleCollectionHeaderCell
			if let _ = cellPrive {
				cellPrive!.imageBorder.backgroundColor = UIColor.clear
				cellPrive!.labelHeader.textColor = UIColor.white
            }
			let cell: MultipleCollectionHeaderCell = collectionView.cellForItem(at: indexPath) as! MultipleCollectionHeaderCell

			cell.imageBorder.backgroundColor = UIColor.green
			cell.labelHeader.textColor = UIColor.green

			self.selectedIndex = indexPath.row

			self.resetIndexPath(indexPath.item)

		}
	}
}

extension MultiSelectionViewController {
	func resetIndexPath(_ indexPath: Int) {
		debugPrint("Indexpath\(indexPath)")
		collectionMultiple.scrollToItem(at: IndexPath(item: indexPath, section: 0), at: .left, animated: true)
	}

	func moveHeaderIndexPath(_ indexPath: Int) {
		debugPrint("Indexpath\(indexPath)")

		collectionHeader.scrollToItem(at: IndexPath(item: indexPath, section: 0), at: .left, animated: true)
	}
}

extension MultiSelectionViewController {
	func userFilterAPI() {

//        if let _ = self.work_exp! {
//
//        }
		// let influencer_filter_data = "/users?UserSearch[user_type]=influencer&UserSearch[influencer_type]=architect&\(self.work_exp!)&\(self.ratings!)&\(self.typical_job_cost!)&\(self.skills!)"

		// let influencer = "/users?UserSearch[user_type]=influencer&UserSearch[influencer_type]=architect&UserSearch[work-experience][]=greater-10&UserSearch[work-experience][]=2-5&UserSearch[distance][]=1-5&UserSearch[distance][]=5-10&UserSearch[work-experience][]=6-10"
		let influencer = "/users?UserSearch[user_type]=influencer&UserSearch[work_experience][]=greater-10"

		APIHandler.handler.influencerFilter(forUser: "influencer", influencer_type: "architect", influencer_filter: influencer, success: { (response) in
			debugPrint(response)
		}) { (error) in
			debugPrint(error)
		}
	}
}

