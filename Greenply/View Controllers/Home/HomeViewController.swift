//
//  HomeViewController.swift
//  Greenply
//
//  Created by Rupam Mitra on 26/08/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

import UIKit

class HomeViewController: BaseCollectionViewController {

	var homeArray: [AnyObject?]? = nil
	override func viewDidLoad() {
		self.menuButtonEnabled = true
        self.notificationButtonEnabled = true
        self.filterButtonEnabled = true
        super.viewDidLoad()

        self.setNavigationTitle("Dashboard")
		homeArray = Helper.sharedClient.readPlist(forName: "Home")
		setupCollectionView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//self.navigationController?.navigationBarHidden = true
	}
}

extension HomeViewController {

	func setupCollectionView() {
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: IS_IPAD() ? 20 : 10, left: 0, bottom: IS_IPAD() ? 20 : 10, right: 0)
		layout.minimumInteritemSpacing = IS_IPAD() ? 20 : 10
		layout.minimumLineSpacing = IS_IPAD() ? 20 : 10
		self.collectionView?.collectionViewLayout = layout
	}

	// MARK: UICollectionViewDataSource methods
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return homeArray!.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeCollectionViewCell.self), for: indexPath) as! HomeCollectionViewCell
		cell.datasource = homeArray![indexPath.row]
		return cell
	}

	// MARK: UICollectionViewDelegate methods
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			performSegue(withIdentifier: "toPreLogin", sender: self)
		}
	}

	// MARK: UICollectionViewDelegateFlowLayout methods
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		return CGSize(width: SCREEN_WIDTH - (IS_IPAD() ? 40 : 20), height: (SCREEN_HEIGHT - (IS_IPAD() ? (20 * 6) : 70)) / 4)
	}
}
